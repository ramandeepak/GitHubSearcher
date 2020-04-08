//
//  DateUtils.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/7/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

extension DateFormatter {
    public static var userAccountCreatedDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }
    
    public static var shortFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
}

extension Date {
    public static func getUserAccountCreatedDate(dateString: String) -> Date? {
        return DateFormatter.userAccountCreatedDateFormatter.date(from: dateString)
    }
    
    public static func shortDate(date: Date) -> String? {
        return DateFormatter.shortFormatter.string(from: date)
    }
}
