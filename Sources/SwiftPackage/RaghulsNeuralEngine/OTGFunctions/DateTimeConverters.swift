//
//  DateTimeConverters.swift
//  OTGFunctions
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 10/03/24.
//

import Foundation

var Clock = ClockEstablishment()

class ClockEstablishment{
    
    // Function to return date in yyyy-MM-dd format
    func getDateInYYYYMMDD() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Sample format: 2024-08-06
        
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    // Function to return date in dd-MM-yyyy format
    func getDateInDDMMYYYY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Sample format: 06-08-2024
        
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    // Function to return date in MM-dd-yyyy format
    func getDateInMMDDYYYY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy" // Sample format: 08-06-2024
        
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    // Function to return date in full format (EEEE, MMMM d, yyyy)
    func getDateInFullFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy" // Sample format: Tuesday, August 6, 2024
        
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    // Function to return date in short format (M/d/yy)
    func getDateInShortFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy" // Sample format: 8/6/24
        
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    // Function to return date in DD-MMMM-yyyy format
    func getDateInDDMMMMYYYY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy" // Sample format: 06-August-2024
        
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    // Function to return date in yyyy-MMMM-dd format
    func getDateInYYYYMMMMDD() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMMM-dd" // Sample format: 2024-August-06
        
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    // Function to return date in dd-MMM-yyyy format
    func getDateInDDMMMYYYY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy" // Sample format: 06-Aug-2024
        
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    // Function to return the current month as a three-letter abbreviation (e.g., Aug)
    func getMM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM" // Sample format: Aug
        let month = dateFormatter.string(from: Date())
        return month
    }
    
    // Function to return the current year in four-digit format (e.g., 2024)
    func getYY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy" // Sample format: 2024
        let year = dateFormatter.string(from: Date())
        return year
    }
    
    // Function to return the current day of the month as a two-digit number (e.g., 06)
    func getDD() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd" // Sample format: 06
        let day = dateFormatter.string(from: Date())
        return day
    }
    
    // Function to return date in '1st August 2024' format
    func getDateWithDaySuffix() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d" // Day of the month as a number
        let day = dateFormatter.string(from: Date())
        
        let daySuffix: String
        switch day {
        case "1", "21", "31":
            daySuffix = "st"
        case "2", "22":
            daySuffix = "nd"
        case "3", "23":
            daySuffix = "rd"
        default:
            daySuffix = "th"
        }
        
        dateFormatter.dateFormat = "MMMM yyyy" // Full month name and year
        let monthAndYear = dateFormatter.string(from: Date())
        
        return "\(day)\(daySuffix) \(monthAndYear)"
    }
    
    // Function to return date in '1st-Aug-2024' format
    func getDateInDDMMMYYYYWithSuffix() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d" // Day of the month as a number
        let day = dateFormatter.string(from: Date())
        
        let daySuffix: String
        switch day {
        case "1", "21", "31":
            daySuffix = "st"
        case "2", "22":
            daySuffix = "nd"
        case "3", "23":
            daySuffix = "rd"
        default:
            daySuffix = "th"
        }
        
        dateFormatter.dateFormat = "MMM-yyyy" // Three-letter month abbreviation and year
        let monthAndYear = dateFormatter.string(from: Date())
        
        return "\(day)\(daySuffix)-\(monthAndYear)"
    }
    
    // Function to return time in 24-hour format (HH:mm:ss)
    func getTime24HourWithSeconds() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" // Sample format: 14:41:25
        
        let currentTime = Date()
        return dateFormatter.string(from: currentTime)
    }
    
    // Function to return time in 12-hour format with seconds (h:mm:ss a)
    func getTime12HourWithSeconds() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss a" // Sample format: 2:41:25 PM
        
        let currentTime = Date()
        return dateFormatter.string(from: currentTime)
    }
    
    // Function to return time in 24-hour format (HH:mm)
    func getTime24Hour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Sample format: 14:41
        
        let currentTime = Date()
        return dateFormatter.string(from: currentTime)
    }
    
    // Function to return time in 12-hour format (h:mm a)
    func getTime12Hour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // Sample format: 2:41 PM
        
        let currentTime = Date()
        return dateFormatter.string(from: currentTime)
    }
    
    // Function to return hour in 12-hour format without leading zero
    func getHour12() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h" // Sample format: 2
        
        let currentTime = Date()
        return dateFormatter.string(from: currentTime)
    }
    
    // Function to return minutes
    func getMinutes() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm" // Sample format: 41
        
        let currentTime = Date()
        return dateFormatter.string(from: currentTime)
    }
    
    // Function to return seconds
    func getSeconds() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss" // Sample format: 25
        
        let currentTime = Date()
        return dateFormatter.string(from: currentTime)
    }
    
    // Function to return hour in 24-hour format
    func getHour24() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH" // Sample format: 14
        
        let currentTime = Date()
        return dateFormatter.string(from: currentTime)
    }
    
    // Static function to get formatted date and time based on user arguments
    func get(format: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format // Use the provided format directly
            return dateFormatter.string(from: Date())
        }
}
