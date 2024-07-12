//
//  URLSession + Extensions.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 12.07.2024.
//
//  Created with the help of https://github.com/swiftlang/swift-evolution/blob/main/proposals/0300-continuation.md
//  Created with the help of https://github.com/swiftlang/swift-evolution/blob/main/proposals/0302-concurrent-value-and-concurrent-closures.md
// Created with the help of https://github.com/swiftlang/swift-evolution/blob/main/proposals/0304-structured-concurrency.md
// Created with the help of https://forums.swift.org/t/how-to-use-withtaskcancellationhandler-properly/54341/11

import Foundation

extension URLSession {
     fileprivate final class TaskCancellation: @unchecked Sendable {
         private var task: URLSessionDataTask?
         private var isCancelled: Bool = false

         private let lock: NSLock = NSLock()

         func bind(task: URLSessionDataTask) {
             lock.withLock {
                 if isCancelled {
                     task.cancel()
                 } else {
                     isCancelled = false
                     self.task = task
                 }
             }
         }

         func cancel() {
             lock.withLock {
                 let task = self.task
                 self.task = nil

                 isCancelled = true

                 task?.cancel()
             }
         }
     }

    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let taskCancellation = TaskCancellation()
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                let sessionTask = dataTask(with: urlRequest) { data, response, error in
                    if let error {
                        if (error as NSError).code == NSURLErrorCancelled {
                            // Comment from Swift evolution-0304: "Ideally translate NSURLErrorCancelled to CancellationError here"
                            continuation.resume(throwing: CancellationError())
                        } else {
                            continuation.resume(throwing: error)
                        }
                    }
                    if let data, let response {
                        continuation.resume(returning: (data, response))
                    }
                }

                sessionTask.resume()
                taskCancellation.bind(task: sessionTask)
            }
        } onCancel: {
            taskCancellation.cancel()
        }
    }
}
