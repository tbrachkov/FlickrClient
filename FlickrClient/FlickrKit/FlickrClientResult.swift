//
//  FlickerClientResult.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation

public enum Result {
    case success(URLResponse?, [FlickrPhoto])
    case Error(URLResponse?, NSError?)
    
    public func data() -> [FlickrPhoto] {
        switch self {
        case .success(_, let photos):
            return photos
        case .Error(_, _):
            return []
        }
    }
    
    public func response() -> URLResponse? {
        switch self {
        case .success(let response, _):
            return response
        case .Error(let response, _):
            return response
        }
    }
    
    public func error() -> NSError? {
        switch self {
        case .success(_, _):
            return nil
        case .Error(_, let error):
            return error
        }
    }
}
