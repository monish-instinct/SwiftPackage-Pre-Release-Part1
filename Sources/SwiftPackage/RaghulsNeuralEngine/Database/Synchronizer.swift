//
//  Synchronizer.swift
//  Database
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 04/01/24.
//

import Foundation
//import RaghulsNeuralEngine

struct TableWiseRowCount {
    var tableName: String
    var noOfEntriesToDownload: Int
    var totalRemaining: Int

    static func getNoOfEntries(for tableName: String, in rows: [TableWiseRowCount]) -> Int? {
        return rows.first(where: { $0.tableName == tableName })?.noOfEntriesToDownload
    }
}

class SynchronizationController: ObservableObject {
    public init(){}
    @Published var prgoress: Double = 0.0
    @Published var prgoressText: String = "Synchronizing Database"
    @Published var centerText: String = "1 Hour Ago"

    func updateValues(progress: Double, progressText: String, centerText: String) {
        self.prgoress = progress
        self.prgoressText = progressText
        self.centerText = centerText
    }
}

class DatabaseSynchronizer {
    var twrc: [TableWiseRowCount] = []
    var totalCount: Int = 0
    var tableRows = [TableWiseRowCount]()
    var iterationCounter = 0
    
    var syncController: SynchronizationController
    
    public init(syncController: SynchronizationController) {
            self.syncController = syncController
        // Assuming the query returns a string array for each row
    }

    private var isSynchronizing = false

    func startSynchronization() {
        clSync("RNE",type: "incl")
        DatabaseStructure.create()
        guard !isSynchronizing else { return }
        isSynchronizing = true
        upSync()
        getSyncData()
    }
    
    
    var upSyncTableTracker = 1
    func upSync(){
        var chanchalFlag = 0
        var toUploadJSON = "["
        cl(DatabaseStructure.tables[upSyncTableTracker].tableName,type:"RNE")
        while let toInsert = upSyncBook.read(status: "pending",queryType: "insert", tableName: DatabaseStructure.tables[upSyncTableTracker].tableName) {
            cl(toInsert,type:"RNE")
            toUploadJSON += convertUpSyncRowToJSON(toInsert) + ","
            cl(toUploadJSON,type:"RNE")
            if sizeOf(toUploadJSON) > 200000 {
                chanchalFlag = 1
                break;
            }
        }
        toUploadJSON = removeLast(from: toUploadJSON,ifEndsWith: ",")
        toUploadJSON += "]"
        
        toUploadJSON = str_replace("'","{||}",in: toUploadJSON)
        
        cl(toUploadJSON+DatabaseStructure.tables[upSyncTableTracker].tableName,type:"RNE")
        
        if(toUploadJSON=="[]"){
            self.upSyncTableTracker += 1
            if(DatabaseStructure.tables.count > upSyncTableTracker){
                self.upSync()
            }
            else{
                self.getSyncData()
            }
        }
        else{
            
            cl(toUploadJSON,type: "RNE")
            let url = URL(string: "https://www.auruvie.com/developers-scripts/iOS-API/upsync/"+DatabaseStructure.tables[upSyncTableTracker].tableName+"/insert.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            cl(url,type:"rudra")
            
            let postData = "secretkey=rne&insertion_data=\(toUploadJSON)&area=rdvj"
            request.httpBody = postData.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    clSync("Error 61: \(error?.localizedDescription ?? "No data")")
                    return
                }
                
                // Print the raw data for debugging
                //clSync("Received data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Parse the JSON response
                    do {
                        clSync(String(data: data, encoding: .utf8) ?? "No string representation of data")
                        
                        _ = upSyncBook.markAsSynced(response: "[{accepted:1,insertedat:27},{rejected:2},{accepted:3,insertedat:87}]")
                        if chanchalFlag == 0{
                            self.upSyncTableTracker += 1
                        }
                        self.upSync()
                    }
                } else {
                    clSync("HTTP Response Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
            }.resume()
        }
    }
    
    func getSyncData(){
        let url = URL(string: "https://www.auruvie.com/developers-scripts/iOS-API/master.php")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"
             request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var maxCountiTracker = 2
        var jsonString: String = "["
        for i in 0..<DatabaseStructure.tables.count {
            maxCountiTracker += 1
                let tableName = DatabaseStructure.tables[i].tableName
                
                // Now query this table for max COUNTI value
                if let maxCountiRow = sql.read(tracker: 6, query: "SELECT MAX(COUNTI) FROM \(tableName)") {
                    if let maxCounti = maxCountiRow.first {
                        jsonString.append("{\"table_name\":\"\(tableName)\", \"counti\":\"\(maxCounti)\"}")
                    }
                }
        }
        jsonString.append("]")
        clSync(jsonString, type:"jsonResponse")
        
        let postData = "secretkey=mohan&table_details=\(jsonString)&area=rdvj"
        request.httpBody = postData.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                clSync("Error 61: \(error?.localizedDescription ?? "No data")")
                return
            }
            
            // Print the raw data for debugging
            //clSync("Received data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Parse the JSON response
                do {
                    clSync(String(data: data, encoding: .utf8) ?? "No string representation of data")

                            // Parse the JSON data
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                var totalRemaining = 0

                                // Process each dictionary in the array
                                for dict in jsonArray {
                                    if let tableName = dict["table_name"] as? String, let count = dict["counti"] as? Int {
                                        clSync(tableName)
                                        clSync(count)
                                        self.tableRows.append(TableWiseRowCount(tableName: tableName, noOfEntriesToDownload: count, totalRemaining: totalRemaining))
                                    }

                                    // Assuming 'total_entries' holds the total remaining count
                                    if let total = dict["total_entries"] as? Int {
                                        totalRemaining = total
                                    }
                                }

                                // Update totalRemaining for each row
                                self.tableRows = self.tableRows.map { row in
                                    var newRow = row
                                    newRow.totalRemaining = totalRemaining
                                    return newRow
                                }

                                // Now tableRows contains your array of TableWiseRowCount objects
                                // Example usage:
                                if let entries = TableWiseRowCount.getNoOfEntries(for: "gold_display_jewels_stock_book", in: self.tableRows) {
                                    clSync("Number of entries to download for 'gold_display_jewels_stock_book': \(entries)")
                                }
                                clSync()
                                //self.synchronizeDatabase()
                            }
                        } catch let error as NSError {
                            clSync("JSON parsing failed: \(error.localizedDescription)")
                        }
                    } else {
                        clSync("HTTP Response Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                    }
        }.resume()
            
    }

    func synchronizeDatabase() {
        // Check for isSynchronizing flag to prevent multiple synchronizations
        guard isSynchronizing else { return }

        let url = URL(string: "https://www.auruvie.com/developers-scripts/iOS-API/gold_display_jewels_stock_book.php")!
             var request = URLRequest(url: url)
             request.httpMethod = "POST"
             request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
             
             var counti: Int = 0
             //sql.reset(tracker: 1)
             if let mohan = sql.read(tracker: 1, query: "select max(counti) from gold_display_jewels_stock_book"){
                 counti = Int(mohan["counti"] ?? "0") ?? 0
             }
             else{
                 counti = 0
             }
             
             clSync(counti)
             // Replace 0 with the actual counti value you want to send
             let postData = "secretkey=mohan&counti=\(counti)&area=rdvj"
             request.httpBody = postData.data(using: .utf8)

             URLSession.shared.dataTask(with: request) { data, response, error in
                 guard let data = data, error == nil else {
                     clSync("Error 61: \(error?.localizedDescription ?? "No data")")
                     return
                 }

                 // Print the raw data for debugging
                 //clSync("Received data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")

                 if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                     // Parse the JSON response
                     do {
                         if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[Any]] {
                             var counter = 0
                             for row in jsonArray {
                                 counter += 1
                                 self.iterationCounter += 1
                                 self.syncController.updateValues(progress: Double(self.iterationCounter)/Double(self.tableRows[0].totalRemaining), progressText: "Syncronysing Database", centerText: "A Moment Ago")
                                 var item = [String: Any]()
                                 for (index, value) in row.enumerated() {
                                     
                                     let key = DatabaseStructure.tables[0].columns[index]
                                     item[key] = value
                                 }
                                 let insertSQL = self.createInsertStatement(from: item)
                                 //clSync("SQL Statement: \(insertSQL)")
                                 //sql.restart()
                                 //sql.reset(tracker: counter)
                                 let _ = sql.executeQuery(insertSQL)
                                 //clSync("SQL Execution Result \(counter): \(sqlResult)")
                             }
                             self.synchronizeDatabase()
                         } else {
                             clSync("Error: JSON data format is not as expected.")
                         }
                     } catch let error as NSError {
                         clSync("JSON parsing failed: \(error.localizedDescription)")
                     }
                 } else {
                     clSync("HTTP Response Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                 }
             }.resume()
    }

    func createInsertStatement(from item: [String: Any]) -> String {
        let values = DatabaseStructure.tables[0].columns.map { column in
                   guard let value = item[column] else { return "NULL" }
                   if let stringValue = value as? String {
                       return "'\(stringValue)'"
                   } else if let intValue = value as? Int {
                       return "\(intValue)"
                   } else if let doubleValue = value as? Double {
                       return "\(doubleValue)"
                   } else {
                       return "NULL"
                   }
               }.joined(separator: ", ")

        return "INSERT INTO gold_display_jewels_stock_book (\(DatabaseStructure.tables[0].columns.joined(separator: ", "))) VALUES (\(values));"
    }

    func stopSynchronization() {
        isSynchronizing = false
    }
}

