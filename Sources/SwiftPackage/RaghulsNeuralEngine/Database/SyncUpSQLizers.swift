//
//  SyncUpSQLizers.swift
//  Database
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 10/02/24.
//

import Foundation
//import RaghulsNeuralEngine

var upSyncBook = UpSyncSQLizer()

class UpSyncSQLizer : UpSyncDatabaseConnectionEstablisher{
    
    var sqt4 = [SqlTracker]()
    
    override init(){
        super.init()
        
        var ctq: String = "CREATE TABLE IF NOT EXISTS "
        ctq = ctq + "mastersyncrecords"
        ctq = ctq + " ("
        
        ctq = ctq + """
            `querytype` TEXT NOT NULL DEFAULT '',
            `kvp` TEXT NOT NULL DEFAULT '',
            `wherecondt` TEXT NOT NULL DEFAULT '',
            `orderby` TEXT NOT NULL DEFAULT '',
            `groupby` TEXT NOT NULL DEFAULT '',
            `limiters` TEXT NOT NULL DEFAULT '',
            `query` TEXT NOT NULL DEFAULT '',
            `tablename` TEXT NOT NULL DEFAULT '',
            `operatedcountis` TEXT NOT NULL DEFAULT '',
            `filename` TEXT NOT NULL DEFAULT '',
            `area` TEXT NOT NULL DEFAULT '',
            `deviceanduserainfo` TEXT NOT NULL DEFAULT 'NONE',
            `basesite` TEXT NOT NULL DEFAULT 'NONE',
            `owncomcode` TEXT NOT NULL DEFAULT 'NONE',
            `testeridentity` TEXT NOT NULL DEFAULT '',
            `testcontrol` TEXT NOT NULL DEFAULT '',
            `adderpid` TEXT NOT NULL DEFAULT '',
            `addername` TEXT NOT NULL DEFAULT '',
            `adder` TEXT NOT NULL DEFAULT '',
            `status` TEXT,
            `ipmac` TEXT NOT NULL DEFAULT '',
            `counti` INTEGER PRIMARY KEY,
            `countifromtable` TEXT NOT NULL DEFAULT '',
            `doe` DATE,
            `toe` TIME
        """
        ctq = ctq + ")"

        var _ = executeQuery(ctq)
    }
    
    func insert(queryType: String, kvp: [String:String], tableName: String, counti: Int, query: String, fileName: String = #file) -> (counti:Int, success:Bool, query:String) {
        
        guard let date = dbClock.getDate() else {
            return (-1, false, "Date Changed")
        }
        
        guard let time = dbClock.getTime() else {
            return (-1, false, "Time Changed")
        }
        
        let p1queryType = queryType
        let p2kvp = str_replace("'","\"", in: convertKVPToString(kvp: kvp))
        let p3wherecondt = stringAfterSeparator(input: query, separator: "WHERE")
        let p4orderby = stringAfterSeparator(input: query, separator: "ORDER BY")
        let p5groupby = stringAfterSeparator(input: query, separator: "GROUP BY")
        let p6limiters = stringAfterSeparator(input: query, separator: "LIMIT")
        let p7query = str_replace("'","\"", in: query)
        let p8tableName = tableName
        let p9countis = counti
        let p10filename = fileName
        let p11area = User.getDB()
        let p12deviceanduserinfo = Device.getUserName() + "[s~2]" + Device.getUniqueID()
        let p13basesite = "gold"
        let p14owncomcode = String(User.getOwnComCode())
        let p15testeridentity = "test"
        let p16testcontrol = "testcontrol"
        let p17adderpid = (fileName as NSString).lastPathComponent
        let p18addername = User.getName() ?? ""
        let p19adder = User.getQueue() ?? ""
        let p20status = "synced"
        let p21ipmac = Network.getIPv4() + "[s~2]" + Device.getUniqueID()
        let p22countifromtable = counti
        let p23doe = date
        let p24toe = time
        
        let insertQuery = """
        INSERT INTO mastersyncrecords(
            querytype, kvp, wherecondt, orderby, groupby, limiters, query, tablename,
            operatedcountis, filename, area, deviceanduserainfo, basesite, owncomcode,
            testeridentity, testcontrol, adderpid, addername, adder, status, ipmac,
            countifromtable, doe, toe
        )
        VALUES(
            '\(p1queryType)', '\(p2kvp)', '\(p3wherecondt)', '\(p4orderby)', '\(p5groupby)',
            '\(p6limiters)', '\(p7query)', '\(p8tableName)', '\(p9countis)', '\(p10filename)',
            '\(p11area)', '\(p12deviceanduserinfo)', '\(p13basesite)', '\(p14owncomcode)',
            '\(p15testeridentity)', '\(p16testcontrol)', '\(p17adderpid)', '\(p18addername)',
            '\(p19adder)', '\(p20status)', '\(p21ipmac)', '\(p22countifromtable)', '\(p23doe)', '\(p24toe)'
        )
        """
        
        let toReturnBool = executeQuery(insertQuery).0
        return (-1, toReturnBool, insertQuery)
    }
    
    
    
    func read(status: String, queryType: String, tableName: String, file: String = #file, tracker: String = "", line: Int = #line) -> [String:String]?{
        let query = "select querytype,kvp,query from mastersyncrecords where status='\(status)' and querytype='\(queryType)' and tablename='\(tableName)'"
        var track = ""
        if tracker == "" {
            let fileName = (file as NSString).lastPathComponent
            let lineNumber = " @ Line : " + String(line)
            track = fileName + lineNumber
        }
        else{
            track = tracker
        }
        
        for sqlTracer in sqt4{
            if sqlTracer.tracker == track{
                if sqlTracer.query == query{
                    if sqlTracer.tableData.indices.contains(sqlTracer.nextRow) {
                        let returnData =  sqlTracer.tableData[sqlTracer.nextRow]
                        sqlTracer.nextRow += 1
                        return returnData
                    } else {
                        return nil
                    }
                }
                else{
                    cl("tracker : \(track) reused for \(sqlTracer.query) and \(query)",type: "SQL Warning")
                    return nil
                }
            }
        }
        
        let eR = executeQuery(query)
        cl(eR,type:"sahana")
        cl(query,type:"sahana")
        if eR.0 == true{
            if let temp = eR.1{
                sqt4.insert(SqlTracker(tracker: track, tableData: temp, query: query), at: 0)
                cl("sqt4",type:"sahana")
                
                if eR.1?.count == 0{
                    return nil
                } else{
                    return eR.1?[0]
                }
            }
            else{
                return nil
            }
        }
        else{
            return nil
        }
    }
    
    func markAsSynced(response : String) -> Int{
        let chunkSize = 25

        guard let data = response.data(using: .utf8) else { return 0 }
            
        var uniqueIDs: [Int] = []
        var uniqueIDsRejected: [Int] = []
        // Attempt to decode the JSON data
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Int]] {
                // Iterate through each dictionary in the array
                for dict in jsonArray {
                    if let accepted = dict["accepted"] {
                        uniqueIDs.append(accepted)
                    } else if let rejected = dict["rejected"] {
                        uniqueIDsRejected.append(rejected)
                    }
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
        
    
        var unique2dIDs: [[Int]] = []
        var unique2dIDsRejected: [[Int]] = []
        for i in stride(from: 0, to: uniqueIDs.count, by: chunkSize) {
            let chunk = uniqueIDs[i..<min(i + chunkSize, uniqueIDs.count)]
            unique2dIDs.append(Array(chunk))
        }
        for i in stride(from: 0, to: uniqueIDsRejected.count, by: chunkSize) {
            let chunk = uniqueIDsRejected[i..<min(i + chunkSize, uniqueIDs.count)]
            unique2dIDsRejected.append(Array(chunk))
        }

        for j in unique2dIDs{
            var query = "update mastersyncrecords set stauts='accepted' where "
            for i in j{
                query += "counti='\(i)' or "
            }
            query += "1=2"
            var _ = executeQuery(query)
        }
        for j in unique2dIDsRejected{
            var query = "update mastersyncrecords set stauts='rejected' where "
            for i in j{
                query += "counti='\(i)' or "
            }
            query += "1=2"
            var _ = executeQuery(query)
        }
        return uniqueIDs.count + uniqueIDsRejected.count
    }
    
    func stringAfterSeparator(input: String, separator: String) -> String {
        // Convert both input and separator to lowercase for case-insensitive comparison
        let lowercasedInput = input.lowercased()
        let lowercasedSeparator = separator.lowercased()
        
        // Split the lowercased string by the lowercased separator
        let components = lowercasedInput.components(separatedBy: lowercasedSeparator)
        
        // Check if there are enough components after splitting
        if components.count > 1 {
            // Trim leading and trailing whitespaces and newlines
            var result = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Replace single quotes with double quotes
            result = result.replacingOccurrences(of: "'", with: "\"")
            
            return result
        } else {
            return ""
        }
    }
    
}
