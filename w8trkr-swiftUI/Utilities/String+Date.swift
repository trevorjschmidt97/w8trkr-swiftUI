//
//  String+Date.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/27/21.
//

import Foundation

let monthYearDateFormat = "MMMM YYYY"
let shortestStringDateFormat = "MMM d"
let shortStringDateFormat = "EEEE, MMM d, YYYY"
let longStringDateFormat = "YYYY-MM-dd"

extension Date {
    func toLongString() -> String {
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = longStringDateFormat
            return df
        }()
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toMonthYearDateString() -> String {
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = longStringDateFormat
            return df
        }()
        
        guard let date = dateFormatter.date(from: self) else { return "Error formatting date" }
        
        let prettyDateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = monthYearDateFormat
            return df
        }()
        return prettyDateFormatter.string(from: date)
    }
    
    func toPrettyShortFormattedDateString() -> String {
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = longStringDateFormat
            return df
        }()
        
        guard let date = dateFormatter.date(from: self) else { return "Error formatting date" }
        
        let prettyDateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = shortestStringDateFormat
            return df
        }()
        return prettyDateFormatter.string(from: date)
    }
    
    func toPrettyFormattedDateString() -> String {
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = longStringDateFormat
            return df
        }()
        
        guard let date = dateFormatter.date(from: self) else { return "Error formatting date" }
        
        let prettyDateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = shortStringDateFormat
            return df
        }()
        return prettyDateFormatter.string(from: date)
    }
    
    func fromLongToDate() -> Date {
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = longStringDateFormat
            return df
        }()
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
}
