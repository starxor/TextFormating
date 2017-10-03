//
// ElasticLogger
// EE Utilities
//
// Created by Alexander Babaev.
// Copyright (c) 2016 Eugene Egorov.
// License: MIT, https://github.com/eugeneego/utilities-ios/blob/master/LICENSE
//

import UIKit

public class ElasticLogger: Logger {
    private let restClient: LightRestClient
    private let token: String
    private let type: String

    private let environment: String

    private let userParameters: () -> [String: String]

    private var logsToSend: [[String: String]] = []

    private var sendLogsTimer: Timer?
    private let sendLogsTimerDelay: TimeInterval = 5.0
    private let maxNumberOfLogs: Int = 1000
    private let maxNumberOfLogsToSendInBulk: Int = 20

    private let appAndSystemParameters: [String: String]

    private let queue: DispatchQueue

    public init(
        restClient: LightRestClient, queue: DispatchQueue,
        token: String, type: String, environment: String, deviceInfo: DeviceInfo,
        userParameters: @escaping () -> [String: String] = {[:]}
    ) {
        self.restClient = restClient
        self.queue = queue
        self.token = token
        self.type = type
        self.environment = environment
        self.userParameters = userParameters

        appAndSystemParameters = [
            "device": deviceInfo.machineName,
            "os": "\(deviceInfo.system) \(deviceInfo.systemVersion)",
            "app": deviceInfo.bundleIdentifier,
            "app_version": deviceInfo.bundleVersion,
            "app_build": deviceInfo.bundleBuild,
            "environment": environment,
        ]

        subscribeToAppEvents()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func subscribeToAppEvents() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }

    private static let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()

    private func severity(for level: LoggingLevel) -> String {
        switch level {
            case .verbose:
                return "verbose"
            case .debug:
                return "debug"
            case .info:
                return "info"
            case .warning:
                return "warn"
            case .error:
                return "err"
        }
    }

    public func log(_ message: @autoclosure () -> String, level: LoggingLevel, for tag: String, function: String) {
        let timestamp = ElasticLogger.timestampFormatter.string(from: Date())
        let message = message()

        var logData: [String: String] = [
            "@timestamp": timestamp,
            "severity": severity(for: level),
            "tag": tag,
            "function": function,
            "message": message,
        ]
        appAndSystemParameters.forEach { logData[$0.key] = $0.value }
        userParameters().forEach { logData[$0.key] = $0.value }

        queue.async {
            self.add(logData: logData)
        }
    }

    private func add(logData: [String: String]) {
        logsToSend.append(logData)

        if logsToSend.count > maxNumberOfLogs {
            NSLog("Ⓛ Exceeded maximum log messages: \(maxNumberOfLogs)")
            logsToSend.removeSubrange(0 ..< (logsToSend.count - maxNumberOfLogs))
        }

        if !logsToSend.isEmpty && sendLogsTimer == nil {
            startSendLogsTimer()
        }
    }

    private var sending: Bool = false

    @objc private func onSendLogs() {
        queue.async {
            self.sendLogs()
        }
    }

    @objc private func sendLogs() {
        guard !sending else { return }
        guard !logsToSend.isEmpty else { return stopSendLogsTimer() }

        sending = true

        let logs = Array(logsToSend.prefix(maxNumberOfLogsToSendInBulk))
        logsToSend = Array(logsToSend.dropFirst(maxNumberOfLogsToSendInBulk))

        let path = logs.count == 1
            ? "/\(token)/\(type)"
            : "/_bulk"
        let string = logs.count == 1
            ? serialize(log: logs[0])
            : serialize(logs: logs)

        guard let data = string?.data(using: .utf8) else {
            sending = false
            return
        }

        let taskId = UIApplication.shared.beginBackgroundTask(withName: String(describing: Swift.type(of: self)))

        restClient.create(
            path: path, id: nil,
            data: data,
            contentType: "",
            headers: [:],
            responseTransformer: VoidLightTransformer()
        ) { result in
            self.sending = false

            if result.error != nil {
                self.logsToSend.insert(contentsOf: logs, at: 0)
            }

            UIApplication.shared.endBackgroundTask(taskId)
        }
    }

    private func serialize(logs: [[String: String]]) -> String {
        let metaInfo = [
            "index": [
                "_index": token,
                "_type": type,
            ]
        ]

        guard let metaInfoLine = Json(value: metaInfo).string else { fatalError("Can't create meta info for elastic logs bulk update") }

        let result = logs.reduce("") { result, log in
            result + (serialize(log: log).map { "\(metaInfoLine)\n\($0)\n" } ?? "")
        }

        return result
    }

    private func serialize(log: [String: String]) -> String? {
        return Json(value: log).string
    }

    private func startSendLogsTimer() {
        sendLogsTimer = Timer.scheduledTimer(
            timeInterval: sendLogsTimerDelay,
            target: self,
            selector: #selector(onSendLogs),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopSendLogsTimer() {
        sendLogsTimer?.invalidate()
        sendLogsTimer = nil
    }

    // MARK: - App state notifications

    @objc private func didEnterBackground() {
        stopSendLogsTimer()
    }

    @objc private func willEnterForeground() {
        if !logsToSend.isEmpty {
            startSendLogsTimer()
        }
    }
}