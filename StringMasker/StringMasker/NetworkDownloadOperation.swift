//
//  NetworkDownloadOperation.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

class NetworkOperation: CustomCancelableOperation {
    private(set) var url: URL

    init(url: URL, label: String = "<No Label>", isRequired: Bool = false) {
        self.url = url
        super.init(label: label, isRequired: isRequired)
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
        guard canRun else { return }

        debugLog(action: NetworkOperationAction.willRequestForResourceAtURL(url))
        task = session.downloadTask(with: url)
        task?.resume()
    }

    func updated(downloadProgress from: Progress, to progress: Progress) {
        if (from.totalUnitCount == -1) && (progress.totalUnitCount != -1) {
            debugLog(action: NetworkOperationAction.didStartedLoadingResourceFromURL(url))
        }
        debugLog(action: NetworkOperationAction.didRecieveData(progress: downloadProgress))
    }

    func downloadedFile(tempLocalURL: URL) {
        debugLog(action: NetworkOperationAction.didDownloadResource(fromURL: url, localURL: tempLocalURL))
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

        let old = Progress(totalUnitCount: downloadProgress.totalUnitCount)
        old.completedUnitCount = downloadProgress.completedUnitCount

        if downloadProgress.totalUnitCount == -1 {
            downloadProgress.totalUnitCount = totalBytesExpectedToWrite
        }

        downloadProgress.completedUnitCount = totalBytesWritten
        updated(downloadProgress: old, to: downloadProgress)
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

        debugLog(action: NetworkOperationAction.didFail(error))
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        defer { isFinished ? nil : finish() }
        guard let error = error else { return }

        debugLog(action: NetworkOperationAction.didFail(error))
    }
}
