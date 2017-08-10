//
//  FlickrFeedInterpreter.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol FlickrFeedInterpreting {
    func interpret(option: FlickerSearchOptions, json: JSON, urlResponse: URLResponse?) -> Result
}
class FlickrFeedInterpreter: FlickrFeedInterpreting {
    func interpret(option: FlickerSearchOptions, json: JSON, urlResponse: URLResponse?) -> Result {
        switch option {
        case .feed:
            //FIMXE: There seems to be an issue sometimes with the json data the flickr returns and can't be parsed to JSON
            guard let feedItemsJson = json.dictionary?["items"]?.array else {
                let result = Result.error(nil, NSError(domain: "com.flickr.client", code: 909, userInfo: [NSLocalizedDescriptionKey: "JSON does not exist"]))
                return result
            }
            var photos: [FlickrPhoto] = []
            for innerJson in feedItemsJson {
                if let media = innerJson["media"].dictionary,
                    let image = media["m"]?.string,
                    let published = innerJson["published"].string,
                    let title = innerJson["title"].string {
                    photos.append(FlickrPhoto(title: title, media: image, published: published))
                }
            }
            
            return Result.success(urlResponse, photos)
        case .tag:
            guard let feedItemsJson = json.dictionary?["photos"]?.dictionary?["photo"]?.array else {
                let result = Result.error(nil, NSError(domain: "com.flickr.client", code: 909, userInfo: [NSLocalizedDescriptionKey: "JSON does not exist"]))
                return result
            }
            var photos: [FlickrPhoto] = []
            for innerJson in feedItemsJson {
                if  let photoId = innerJson["id"].string,
                    let farm = innerJson["farm"].int,
                    let secret = innerJson["secret"].string,
                    let server = innerJson["server"].string,
                    let title = innerJson["title"].string {
                    photos.append(FlickrPhoto(title: title, media: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg", published: Date().iso8601))
                }
            }
            
            return Result.success(urlResponse, photos)
        }
    }
}
