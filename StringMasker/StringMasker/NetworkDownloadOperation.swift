//
//  NetworkDownloadOperation.swift
//  StringMasker
//
//  Created by Stanislav Starzhevskiy on 03.10.17.
//  Copyright © 2017 _My_Company_. All rights reserved.
//

import Foundation

class NetworkDownloadOperation: NetworkOperation {
    private var downloadTask: URLSessionDownloadTask!
    override var task: URLSessionTask {
        return downloadTask
    }

    var downloadProgress: Progress = Progress(totalUnitCount: -1)

    override func main() {
        guard canRun else { return }

        debugLog(action: NetworkOperationAction.willRequestForResourceAtURL(url))
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
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
