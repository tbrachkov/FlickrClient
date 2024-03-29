//
//  Date+Format.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 18/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation

public extension Formatter {
    public static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
public extension Date {
    public var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

public extension String {
    public var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}
