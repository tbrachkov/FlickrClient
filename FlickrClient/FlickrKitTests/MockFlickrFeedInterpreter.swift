//
//  File.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation
@testable import FlickrKit

class MockFlickrFeedInterpreter: FlickrFeedInterpreting {

    func interpret(json: NSDictionary?, urlResponse: URLResponse?) -> Result {
        
        return Result.success(urlResponse, [FlickrPhoto(title: "Demo Demo", media: "https://demo.com", published: "2017-07-17T21:04:27Z")])
    }
}
