//
//  NetworkDownloadOperation.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

protocol LabeledEntity {
    var label: String { get }
}

protocol RequiredOperationDependency {
    var isRequired: Bool { get }
}

class NetworkOperation: Operation, LabeledEntity, RequiredOperationDependency {
    private(set) var label: String
    private(set) var url: URL
    private(set) var isRequired: Bool

    init(label: String, url: URL, isRequired: Bool = false) {
        self.label = label
        self.url = url
        self.isRequired = isRequired
    }

    // MARK: - Validate execution
    func canRun() -> Bool {
        guard !isCancelled else {
            print("\(type(of: self)).\(self.label) was canceled")
            return false
        }

        for dependency in dependencies {
            if let op = dependency as? RequiredOperationDependency, op.isRequired, dependency.isCancelled {
                print("\(type(of: self)).\(self.label) cancel() self because required dependecy was canceled")
                cancel()
                return false
            }
        }

        return true
    }

    // MARK: - Finished state managment
    func finish() {
        _finished = true
    }

    private var _finished: Bool = false {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }

    override var isFinished: Bool {
        return _finished
    }

    // MARK: - Canceling
    override func cancel() {
        super.cancel()
        print("\(type(of: self)).\(self.label) will \(#function)")
        _finished = true
    }

    deinit {
        print("\(type(of: self)).\(self.label) will \(#function)")
    }
}

class NetworkDownloadOperation: NetworkOperation {
    private lazy var delegateQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .default
        return queue
    }()

    private lazy var session: URLSession = {
        return URLSession(configuration: .default, delegate: self, delegateQueue: self.delegateQueue)
    }()

    private var task: URLSessionDownloadTask?

    var downloadProgress: Progress = Progress(totalUnitCount: -1)

    override func main() {
        guard canRun() else { return }

        // TODO: Logic
        guard let url = URL(string: "https://i.imgur.com/AEGaQNj.jpg") else { return }

        task = session.downloadTask(with: url)
        task?.resume()
    }

    func downloadedFile(tempLocalURL: URL) {
        print("File successfuly downloaded to \(tempLocalURL)")
    }
}

extension NetworkDownloadOperation: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        downloadedFile(tempLocalURL: location)
        session.finishTasksAndInvalidate()
        finish()
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        if downloadProgress.totalUnitCount == -1 {
            downloadProgress.totalUnitCount = totalBytesExpectedToWrite
        }

        downloadProgress.completedUnitCount = totalBytesWritten

        print(downloadProgress.localizedDescription)
    }
}

extension NetworkDownloadOperation: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        defer { isFinished ? nil : finish() }
        guard let error = error else {
            /*finished successfuly*/
            session.finishTasksAndInvalidate()
            return
        }

        print("\(type(of: self)).\(label) \(#function) \n \(error.localizedDescription)")
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        defer { isFinished ? nil : finish() }
        guard let error = error else { return }

        print("\(type(of: self)).\(label) \(#function) \n \(error.localizedDescription)")
    }
}
