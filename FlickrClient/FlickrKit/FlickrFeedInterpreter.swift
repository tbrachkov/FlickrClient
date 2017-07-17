//
//  FlickrFeedInterpreter.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation

protocol FlickrFeedInterpreting {
    func interpret(json: NSDictionary?, urlResponse: URLResponse?) -> Result
}
class FlickrFeedInterpreter: FlickrFeedInterpreting {
    func interpret(json: NSDictionary?, urlResponse: URLResponse?) -> Result {
        guard let json = json, let feedItemsJson = json["items"] as? [[String: Any]] else {
            let result = Result.Error(nil, NSError(domain: "com.flickr.client", code: 909, userInfo: nil))
            return result
        }
        let photos: [FlickrPhoto] = feedItemsJson.flatMap { innerJson in
            guard let media = innerJson["media"] as? [String: Any],
                let image = media["m"] as? String,
                let published = innerJson["published"] as? String,
                let title = innerJson["title"] as? String
                else { return nil }
            
            return FlickrPhoto(title: title, media: image, published: published)
        }
        return Result.success(urlResponse, photos)
    }
}
