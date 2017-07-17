//
//  FlickrClient.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation

public protocol Flickring {
    func getPhotoFeed(callback: @escaping (Result) -> ())
}

open class FlickrClient: Flickring {

    open var apiKey: String
    private static var queue: OperationQueue {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 4
        return operationQueue
    }
    
    // MARK: -
    // MARK: Initialization
    
    public init(apiKey: String? = nil) {
        self.apiKey = apiKey ?? Const.APIKey
    }
    
    // MARK: -
    // MARK: Retrieving photos
    
    open func getPhotoFeed(callback: @escaping (Result) -> ()) {
        call("?format=json&nojsoncallback=1", callback: callback)
    }

    // MARK: -
    // MARK: Retrieving search tag

    
    // MARK: -
    // MARK: Call the api
    
    fileprivate func call(_ method: String, callback: @escaping (Result) -> ()) {
        guard let url = URL(string: Const.basePath + method) else {
            let result = Result.error(nil, NSError(domain: "com.flickr.client", code: 909, userInfo: nil))
            callback(result)
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            var error: NSError? = error as NSError?
            var dictionary: NSDictionary?
            
            guard let data = data else {
                let result = Result.error(nil, NSError(domain: "com.flickr.client", code: 909, userInfo: nil))
                callback(result)
                return
            }
            
            do {
                dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
            } catch let err as NSError {
                error = err
            }
            
            FlickrClient.queue.addOperation {
                var result = Result.success(response, [])
                if error != nil {
                    result = Result.error(response, error)
                }
                result = FlickrFeedInterpreter().interpret(json: dictionary, urlResponse: response)
                callback(result)
            }
        })
        task.resume()
    }
}
