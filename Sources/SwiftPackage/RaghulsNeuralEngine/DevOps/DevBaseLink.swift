//
//  DevBaseLink.swift
//  DevOps
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 07/02/24.
//

import Foundation
//import RaghulsNeuralEngine

var logWallet = LogBaseFunctions()

class LogBaseFunctions : DevOpsDatabaseConnectionEstablisher {
    let imeihash = Device.getUniqueID()
    let doe = dbClock.getDate() // Assuming getDate() returns a DATE string
    let toe = dbClock.getTime() // Assuming getTime() returns a TIME string
    let syncstatus = "synced" // Assuming a static value; adjust as needed
    var tablenameglobal = ""
    var sqt2 = [SqlTracker]()
    
    override init(){
        super.init()
        
        if let date = dbClock.getDate() {
            let tablename = "t"+str_replace("-","",in: date)
            tablenameglobal = tablename
            var ctq: String = "CREATE TABLE IF NOT EXISTS "
            ctq = ctq + "t"+str_replace("-","",in: date)
            ctq = ctq + " ("
            
            
            ctq = ctq + """
        `filename` TEXT,
                    `classname` TEXT,
                    `function` TEXT,
                    `line` INT,
                    `logtype` TEXT,
                    `msg` TEXT,
                    `area` TEXT NOT NULL DEFAULT '',
                    `ipmac` TEXT NOT NULL DEFAULT '',
                    `deviceanduserainfo` TEXT NOT NULL DEFAULT 'NONE',
                    `basesite` TEXT NOT NULL DEFAULT 'NONE',
                    `owncomcode` TEXT NOT NULL DEFAULT 'NONE',
                    `testeridentity` TEXT NOT NULL DEFAULT '',
                    `testcontrol` TEXT NOT NULL DEFAULT '',
                    `adderpid` TEXT NOT NULL DEFAULT '',
                    `addername` TEXT NOT NULL DEFAULT '',
                    `adder` TEXT NOT NULL DEFAULT '',
                    `syncstatus` TEXT,
                    `mac` TEXT,
                    `counti` INTEGER PRIMARY KEY,
                    `countifromserver` TEXT DEFAULT NULL,
                    `mcounti` TEXT DEFAULT NULL,
                    `doe` DATE,
                    `toe` TIME
        """
            ctq = ctq + ")"
            executeQuery("CREATE TABLE IF NOT EXISTS querysync (`query` TEXT,`syncstatus` TEXT,`mac` TEXT,`tablename` TEXT,`countifromtable` TEXT,`counti` INTEGER PRIMARY KEY,`doe` DATE,`toe` TIME)")
            
            var _ = executeQuery(ctq)
            let randomstr1 = random(length: 5)
            let ins_query = ctq.replacingOccurrences(of: "'", with: "''")
            let ins_query_final = modifySQLQuery(ins_query)
            executeQuery("INSERT INTO querysync (`query`, `syncstatus`, `mac`, `tablename`, `countifromtable`, `doe`, `toe`) VALUES ('\(ins_query_final)', '\(syncstatus)', '\(imeihash)', '\(tablename)', '\(1)','\(doe)', '\(toe)')")

        }
        else{
            //clSecurity(minDate,minTime,minDateTimeSetter)
        }
    }
    
    func read(_ query: String, file: String = #file, tracker: String = "", line: Int = #line) -> [String: String]? {
        var track = ""
        if tracker == "" {
            let fileName = (file as NSString).lastPathComponent
            let lineNumber = " @ Line : " + String(line)
            track = fileName + lineNumber
        }
        else{
            track = tracker
        }
        for sqlTracer in sqt2{
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
        if eR.0 == true{
            if let temp = eR.1{
                sqt2.insert(SqlTracker(tracker: track, tableData: temp, query: query), at: 0)
            }
            else{
                return nil
            }
        }
        else{
            return nil
        }
        return nil
    }
    
    private func ivc(_ param: String) -> String {
        return "'" + enqry(param) + "'"
    }
    
    func insert(_ tableName: String, _ kvp: [String:String], fileName: String = #file) -> (counti:Int,success:Bool,query:String){
        
        let randomstr2 = random(length: 5)
        if let date = dbClock.getDate(),
           let time = dbClock.getTime(){
            var columns: [String] = []
            var values: [String] = []
            
            // Splitting each key-value pair and appending them to respective arrays
            for (key,value) in kvp {
                columns.append(enqry(key))
                values.append(ivc(value)) // Adding quotes around values
            }
            
            columns.append("area")
            values.append(ivc(User.getDB()))
            
            columns.append("testcontrol")
            let ranTracker = random(length: 7)
            values.append(ivc(ranTracker))
            
            columns.append("ipmac")
            values.append(ivc(deviceDetails.getIP() + "[s~2]" + deviceDetails.getMac()))
            
            columns.append("deviceanduserainfo")
            values.append(ivc(deviceDetails.getDeviceAndUserDataForeignKey()))
            
            columns.append("basesite")
            values.append(ivc("gold"))
            
            columns.append("owncomcode")
            values.append(ivc(String(User.getOwnComCode())))
            
            columns.append("adderpid")
            let filename = (fileName as NSString).lastPathComponent
            values.append(ivc(filename))
            
            columns.append("addername")
            values.append(ivc(User.getName() ?? ""))
            
            columns.append("adder")
            values.append(ivc(User.getQueue() ?? ""))
            
            columns.append("syncstatus")
            values.append(ivc(randomstr2))
            
            columns.append("mac")
            values.append(ivc(Device.getUniqueID()))
            
            columns.append("doe")
            values.append(ivc(date))
            
            columns.append("toe")
            values.append(ivc(time))
            
            // Joining columns and values to form a part of SQL query
            let columnsString = columns.joined(separator: ", ")
            let valuesString = values.joined(separator: ", ")
            
            // Constructing the full SQL insert query
            let insertQuery = "INSERT INTO \(tableName)(\(columnsString)) VALUES(\(valuesString))"
            
            //hey chatgpt write code here to excecute this insert query
            var _ = executeQuery(insertQuery)
            let instinct = executeQuery("SELECT counti FROM \(tableName) WHERE syncstatus='\(randomstr2)';")
            let counti = segregateAndPrintCounti(instinct)
            
            let ins_query = insertQuery.replacingOccurrences(of: "'", with: "''")
            executeQuery("INSERT INTO querysync (`query`, `syncstatus`, `mac`, `tablename`, `countifromtable`, `doe`, `toe`) VALUES ('\(ins_query)', '\(syncstatus)', '\(imeihash)', '\(tablenameglobal)', '\(counti)', '\(doe)', '\(toe)')")
            
            let ctn = executeQuery("select counti from \(tableName) where testcontrol = '\(ranTracker)'")
            
            if let countString = ctn.1?.first?["counti"], let count = Int(countString) {
                var _ = executeQuery("update \(tableName) set mcounti='\(count)', testcontrol='' where counti = \(count) and testcontrol='\(ranTracker)' ")
                return (count, true, insertQuery)
            } else {
                return (-1, false, insertQuery)
            }
        }
        else
        {
            return (-1, false, "")
        }
    }
    
    

}

var logSyncWallet = LogSyncBaseFunctions()

class LogSyncBaseFunctions : DevOpsSyncDatabaseConnectionEstablisher {
    let imeihash = Device.getUniqueID()
    let doe = dbClock.getDate() // Assuming getDate() returns a DATE string
    let toe = dbClock.getTime() // Assuming getTime() returns a TIME string
    let syncstatus = "synced" // Assuming a static value; adjust as needed
    var tablenameglobal = ""
    
    var sqt3 = [SqlTracker]()
    
    override init(){
        super.init()
        
        if let date = dbClock.getDate() {
            let tablename = "s"+str_replace("-","",in: date);
            tablenameglobal = tablename
            var ctq: String = "CREATE TABLE IF NOT EXISTS "
            ctq = ctq + "s"+str_replace("-","",in: date)
            ctq = ctq + " ("
            
            
            ctq = ctq + """
        `filename` TEXT,
                    `classname` TEXT,
                    `function` TEXT,
                    `line` INT,
                    `logtype` TEXT,
                    `msg` TEXT,
                    `area` TEXT NOT NULL DEFAULT '',
                    `ipmac` TEXT NOT NULL DEFAULT '',
                    `deviceanduserainfo` TEXT NOT NULL DEFAULT 'NONE',
                    `basesite` TEXT NOT NULL DEFAULT 'NONE',
                    `owncomcode` TEXT NOT NULL DEFAULT 'NONE',
                    `testeridentity` TEXT NOT NULL DEFAULT '',
                    `testcontrol` TEXT NOT NULL DEFAULT '',
                    `adderpid` TEXT NOT NULL DEFAULT '',
                    `addername` TEXT NOT NULL DEFAULT '',
                    `adder` TEXT NOT NULL DEFAULT '',
                    `syncstatus` TEXT,
                    `mac` TEXT,
                    `counti` INTEGER PRIMARY KEY,
                    `countifromserver` TEXT DEFAULT NULL,
                    `mcounti` TEXT DEFAULT NULL,
                    `doe` DATE,
                    `toe` TIME
        """
            ctq = ctq + ")"
            executeQuery("CREATE TABLE IF NOT EXISTS querysync (`query` TEXT,`syncstatus` TEXT,`mac` TEXT,`tablename` TEXT,`countifromtable` TEXT,`counti` INTEGER PRIMARY KEY,`doe` DATE,`toe` TIME)")
            
            var _ = executeQuery(ctq)
            let randomstr1 = random(length: 5)
            let ins_query = ctq.replacingOccurrences(of: "'", with: "''")
            let ins_query_final = modifySQLQuery(ins_query)
            executeQuery("INSERT INTO querysync (`query`, `syncstatus`, `mac`, `tablename`, `countifromtable`, `doe`, `toe`) VALUES ('\(ins_query_final)', '\(syncstatus)', '\(imeihash)', '\(tablename)', '\(1)','\(doe)', '\(toe)')")

        }
        else{
            //clSecurity(minDate,minTime,minDateTimeSetter)
        }
    }
    
    func read(_ query: String, file: String = #file, tracker: String = "", line: Int = #line) -> [String: String]? {
        var track = ""
        if tracker == "" {
            let fileName = (file as NSString).lastPathComponent
            let lineNumber = " @ Line : " + String(line)
            track = fileName + lineNumber
        }
        else{
            track = tracker
        }
        for sqlTracer in sqt3{
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
        if eR.0 == true{
            if let temp = eR.1{
                sqt3.insert(SqlTracker(tracker: track, tableData: temp, query: query), at: 0)
            }
            else{
                return nil
            }
        }
        else{
            return nil
        }
        return nil
    }
    
    private func ivc(_ param: String) -> String {
        return "'" + enqry(param) + "'"
    }
    
    func insert(_ tableName: String, _ kvp: [String:String], fileName: String = #file) -> (counti:Int,success:Bool,query:String){
        let randomstr2 = random(length: 5)
        if let date = dbClock.getDate(),
           let time = dbClock.getTime(){
            var columns: [String] = []
            var values: [String] = []
            
            // Splitting each key-value pair and appending them to respective arrays
            for (key,value) in kvp {
                columns.append(enqry(key))
                values.append(ivc(value)) // Adding quotes around values
            }
            
            columns.append("area")
            values.append(ivc(User.getDB()))
            
            columns.append("testcontrol")
            let ranTracker = random(length: 7)
            values.append(ivc(ranTracker))
            
            columns.append("ipmac")
            values.append(ivc(deviceDetails.getIP() + "[s~2]" + deviceDetails.getMac()))
            
            columns.append("deviceanduserainfo")
            values.append(ivc(deviceDetails.getDeviceAndUserDataForeignKey()))
            
            columns.append("basesite")
            values.append(ivc("gold"))
            
            columns.append("owncomcode")
            values.append(ivc(String(User.getOwnComCode())))
            
            columns.append("adderpid")
            let filename = (fileName as NSString).lastPathComponent
            values.append(ivc(filename))
            
            columns.append("addername")
            values.append(ivc(User.getName() ?? ""))
            
            columns.append("adder")
            values.append(ivc(User.getQueue() ?? ""))
            
            columns.append("syncstatus")
            values.append(ivc(randomstr2))
            
            columns.append("mac")
            values.append(ivc(Device.getUniqueID()))
            
            columns.append("doe")
            values.append(ivc(date))
            
            columns.append("toe")
            values.append(ivc(time))
            
            // Joining columns and values to form a part of SQL query
            let columnsString = columns.joined(separator: ", ")
            let valuesString = values.joined(separator: ", ")
            
            // Constructing the full SQL insert query
            let insertQuery = "INSERT INTO \(tableName)(\(columnsString)) VALUES(\(valuesString))"
            
            //hey chatgpt write code here to excecute this insert query
            var _ = executeQuery(insertQuery)
            let instinct = executeQuery("SELECT counti FROM \(tableName) WHERE syncstatus='\(randomstr2)';")
            let counti = segregateAndPrintCounti(instinct)
            
            let ins_query = insertQuery.replacingOccurrences(of: "'", with: "''")
            executeQuery("INSERT INTO querysync (`query`, `syncstatus`, `mac`, `tablename`, `countifromtable`, `doe`, `toe`) VALUES ('\(ins_query)', '\(syncstatus)', '\(imeihash)', '\(tablenameglobal)', '\(counti)', '\(doe)', '\(toe)')")
            
            let ctn = executeQuery("select counti from \(tableName) where testcontrol = '\(ranTracker)'")
            
            if let countString = ctn.1?.first?["counti"], let count = Int(countString) {
                var _ = executeQuery("update \(tableName) set mcounti='\(count)', testcontrol='' where counti = \(count) and testcontrol='\(ranTracker)' ")
                return (count, true, insertQuery)
            } else {
                return (-1, false, insertQuery)
            }
        }
        else{
            return (-1, false, "")
        }
    }
    
    func syncquery(query: String) {
        print(query)
        do {
            let ins_query = query.replacingOccurrences(of: "'", with: "''")
            let imeihash = Device.getUniqueID()
            let doe = dbClock.getDate() // Assuming getDate() returns a DATE string
            let toe = dbClock.getTime() // Assuming getTime() returns a TIME string
            let syncstatus = "synced" // Assuming a static value; adjust as needed

            // Building the insert query
            let insertQuery = """
            INSERT INTO query_sync (
                `query`,
                `mac`,
                `doe`,
                `toe`,
                `syncstatus`
            ) VALUES (
                '\(ins_query)',
                '\(imeihash)',
                '\(doe)',
                '\(toe)',
                '\(syncstatus)'
            )
            """

            // Executing the insert query
            let (success, _) = executeQuery(insertQuery)
            if success {
                cl("Data inserted successfully", type: "si")
            } else {
                cl("Failed to insert data", type: "si")
            }
        } catch {
            cl("Error: \(error)", type: "si")
        }
    }

}
func modifySQLQuery(_ query: String) -> String {
    var modifiedQuery = query
    
    if query.hasPrefix("CREATE") {
        modifiedQuery = modifiedQuery.replacingOccurrences(of: "`counti` INTEGER PRIMARY KEY", with: "`counti` INT PRIMARY KEY AUTO_INCREMENT")
        modifiedQuery = modifiedQuery.replacingOccurrences(of: "`countifromserver` TEXT DEFAULT NULL,", with: "")
    }
    
    return modifiedQuery
}

func segregateAndPrintCounti(_ output: (Bool, Any?)) -> Int {
    // Ensure the output is valid
    guard let (_, queries) = output as? (Bool, [[String: String]]), !queries.isEmpty else {
        return -1
    }
    
    // Extract the first counti value
    if let countiStr = queries.first?["counti"], let counti = Int(countiStr) {
        return counti
    } else {
        return -1
    }
}


