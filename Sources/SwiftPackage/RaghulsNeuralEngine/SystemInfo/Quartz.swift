//
//  Quartz.swift
//  SystemInfo
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 02/02/24.
//
import Foundation

var dbClock = dbClockEstablishment()

class dbClockEstablishment{
    
    public init(){}
    
    var minDate: String = "0000-00-00"
    var minTime: String = "00:00:00"
    var minDateTimeSetter: String = ""
    func getDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let currentTime = Date()
        let timeString = timeFormatter.string(from: currentTime)
        
        if(dateString+"T"+timeString) >= minDate + "T" + minTime{
            return dateString
        }
        else{
            if dateString > minDate {
                blockUIUXaccess("datechanged")
            }
            else {
                blockUIUXaccess("timechanged")
            }
            return nil
        }
    }
    
    func getDateforDB() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let currentTime = Date()
        let timeString = timeFormatter.string(from: currentTime)
        
        let minDate = "2024-07-01"  // Example minimum date
        let minTime = "00:00:00"    // Example minimum time
        
        if (dateString + "T" + timeString) >= minDate + "T" + minTime {
            return dateString
        } else {
            if dateString > minDate {
                blockUIUXaccess("datechanged")
            } else {
                blockUIUXaccess("timechanged")
            }
            return ""  // Return an empty string instead of nil
        }
    }
    
    
    func getTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let currentTime = Date()
        let timeString = timeFormatter.string(from: currentTime)
        
        if(dateString+"T"+timeString) >= minDate + "T" + minTime{
            return timeString
        }
        else{
            if dateString > minDate {
                blockUIUXaccess("datechanged")
            }
            else {
                blockUIUXaccess("timechanged")
            }
            return nil
        }
    }
    
    func getTimeforDB() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let currentTime = Date()
        let timeString = timeFormatter.string(from: currentTime)
        
        let minDate = "2024-07-01"  // Example minimum date
        let minTime = "00:00:00"    // Example minimum time
        
        if (dateString + "T" + timeString) >= minDate + "T" + minTime {
            return timeString
        } else {
            if dateString > minDate {
                blockUIUXaccess("datechanged")
            } else {
                blockUIUXaccess("timechanged")
            }
            return ""  // Return an empty string instead of nil
        }
    }
}

//Time Conversion Functions
class Timezone{
    static func checkAllDateTimeFunctions(){
        Timezone.fetchDateAndTimeFromAruvie()
        Timezone.fetchDateAndTimeFromSkynet()
        Timezone.fetchDateAndTimeFromDataBase()
        Timezone.fetchDataAndTimeFromWorldTimeAPI()
    }
    
    static func setMinDateTime(){
        
    }
    
    internal static func fetchDateAndTimeFromDataBase(){
        
    }
    
    internal static func fetchDataAndTimeFromWorldTimeAPI(){
        
    }
    
    internal static func fetchDateAndTimeFromAruvie(){
        let task = URLSession.shared.dataTask(with: skynetTime) { data, response, error in 
            if let error = error {
                clSync("Error fetching data: \(error.localizedDescription)",#line)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                clSync("Invalid response",#line)
                return
            }

            guard let data = data else {
                clSync("No data received",#line)
                return
            }

            // Assuming the API returns the date-time string directly
            if let dateTimeString = String(data: data, encoding: .utf8) {
                clSync(dateTimeString,#line)
            } else {
                clSync("Error converting data to string",#line)
            }
        }
        task.resume()
    }
    internal static func fetchDateAndTimeFromSkynet(){
        let task = URLSession.shared.dataTask(with: aruvieTime) { data, response, error in
            if let error = error {
                clSync("Error fetching data: \(error.localizedDescription)",#line)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                clSync("Invalid response",#line)
                return
            }

            guard let data = data else {
                clSync("No data received",#line)
                return
            }

            // Assuming the API returns the date-time string directly
            if let dateTimeString = String(data: data, encoding: .utf8) {
                clSync(dateTimeString,#line)
            } else {
                clSync("Error converting data to string",#line)
            }
        }
        task.resume()
    
    }
}


