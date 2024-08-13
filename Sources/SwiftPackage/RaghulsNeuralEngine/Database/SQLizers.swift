//
//  SQLizers.swift
//  Database
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 02/01/24.
//

import Foundation
var sql = Sqlize()

class SqlTracker {
    var tracker: String
    var nextRow: Int = 0
    var query: String
    var tableData: [[String: String]]
    
    init(tracker: String, tableData: [[String: String]], query: String) {
        self.tableData = tableData
        self.tracker = tracker
        self.query = query
    }
}

class Sqlize: DatabaseConnectionEstablisher {
    
    var sqt = [SqlTracker]()
    
    override init(){
        super.init()
    }
    
    func read(tracker: Double, query: String) -> [String: String]? {
        return read(query, tracker: String(tracker))
    }
    
    func read(tracker: Float, query: String) -> [String: String]? {
        return read(query, tracker: String(tracker))
    }
    
    func read(tracker: Int, query: String) -> [String: String]? {
        return read(query, tracker: String(tracker))
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
        for sqlTracer in sqt{
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
                sqt.insert(SqlTracker(tracker: track, tableData: temp, query: query), at: 0)
                guard temp.isEmpty else{
                    sqt[0].nextRow = 1
                    return temp[0]
                }
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
    
    func delete(_ tableName: String, _ whereCondition: String) -> (count:Int,success:Bool,query:String){
        
        let randomstr = random(length: 5)
        let ipaddresses = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM ipaddresses;"))
        let ipdata = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM ipdata;"))
        let deviceinfo = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM deviceinfo;"))
        let systemdetails = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM systemdetails;"))
        let historydata = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM \(Clock.getMM() + Clock.getYY());"))
        var deviceanduserainfo = "{~del][~ip}\(ipaddresses)[/ip}[~mac}\(ipdata)[/mac}[~d}\(deviceinfo)[/d}[~s}\(systemdetails)[/s}[~h}\(historydata)[/h}{/del]"
        deviceanduserainfo = deviceanduserainfo.replacingOccurrences(of: "\"", with: "'")
        deviceanduserainfo = "\""+deviceanduserainfo+"\""
        
        var ipmac = "{~del][~ip}\(Network.getIPv4())[/ip}[~us}\(Device.getUserName())[/us}[~uid}\(Device.getUniqueID())[/uid}[~osn}\(Device.getOSName())[/osn}{/del]"
        ipmac = ipmac.replacingOccurrences(of: "\"", with: "'")
        ipmac = "\""+ipmac+"\""
        
        let selquery = "select count(*) from \(tableName) WHERE \(whereCondition) and todat='0000-00-00';"
        let affectedRows: Int = Int(executeQuery(selquery).1?.first?["count"] ?? "0") ?? 0
        
        let query = "UPDATE \(tableName) SET todat='\(dbClock.getDateforDB())', deviceanduserainfo = deviceanduserainfo || \(deviceanduserainfo), ipmac = ipmac || \(ipmac) WHERE \(whereCondition) and todat='0000-00-00';"
        if executeQuery(query).0 == true{
            let instinct = executeQuery("SELECT counti FROM \(tableName) WHERE syncstatus='\(randomstr)';")
            let counti = segregateAndPrintCounti(instinct)
            cl(query, type: "Delete query executed successfully in table => \(tableName)")
            upSyncBook.insert(queryType: "todate", kvp: ["whereCondition" : whereCondition], tableName: tableName, counti: counti, query: "UPDATE \(tableName) SET todat='\(dbClock.getDateforDB())', deviceanduserainfo = CONCAT(CAST(deviceanduserainfo AS CHAR), \(deviceanduserainfo)), ipmac = CONCAT(CAST(ipmac AS CHAR), \(ipmac)) WHERE \(whereCondition) AND todat='0000-00-00';")
            return (affectedRows, true, query)
        }
        else{
            return (affectedRows, false, query)
        }
    }
    

    
    func end(_ tableName: String, _ whereCondition: String) -> (count:Int,success:Bool,query:String){
        
        let randomstr = random(length: 5)
        let ipaddresses = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM ipaddresses;"))
        let ipdata = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM ipdata;"))
        let deviceinfo = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM deviceinfo;"))
        let systemdetails = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM systemdetails;"))
        let historydata = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM \(Clock.getMM() + Clock.getYY());"))
        var deviceanduserainfo = "{~e][~ip}\(ipaddresses)[/ip}[~mac}\(ipdata)[/mac}[~d}\(deviceinfo)[/d}[~s}\(systemdetails)[/s}[~h}\(historydata)[/h}{/e]"
        deviceanduserainfo = deviceanduserainfo.replacingOccurrences(of: "\"", with: "'")
        deviceanduserainfo = "\""+deviceanduserainfo+"\""
        
        var ipmac = "{~e][~ip}\(Network.getIPv4())[/ip}[~us}\(Device.getUserName())[/us}[~uid}\(Device.getUniqueID())[/uid}[~osn}\(Device.getOSName())[/osn}{/e]"
        ipmac = ipmac.replacingOccurrences(of: "\"", with: "'")
        ipmac = "\""+ipmac+"\""
        
        let selquery = "select count(*) from \(tableName) WHERE \(whereCondition) and ftodat='0000-00-00';"
        let affectedRows: Int = Int(executeQuery(selquery).1?.first?["count"] ?? "0") ?? 0
        
        let query = "UPDATE \(tableName) SET ftodat='\(dbClock.getDateforDB())', deviceanduserainfo = deviceanduserainfo || \(deviceanduserainfo), ipmac = ipmac || \(ipmac) WHERE \(whereCondition) and ftodat='0000-00-00';"
        if executeQuery(query).0 == true{
            let instinct = executeQuery("SELECT counti FROM \(tableName) WHERE syncstatus='\(randomstr)';")
            let counti = segregateAndPrintCounti(instinct)
            cl(query, type: "ftodat update query executed successfully in table => \(tableName)")
            upSyncBook.insert(queryType: "ftodate", kvp: ["whereCondition" : whereCondition], tableName: tableName, counti: counti, query: "UPDATE \(tableName) SET ftodat='\(dbClock.getDateforDB())', deviceanduserainfo = CONCAT(CAST(deviceanduserainfo AS CHAR), \(deviceanduserainfo)), ipmac = CONCAT(CAST(ipmac AS CHAR), \(ipmac)) WHERE \(whereCondition) AND ftodat='0000-00-00';")
            return (affectedRows, true, query)
        }
        else{
            return (affectedRows, false, query)
        }
    }
    

    
    func update(tableName: String, setters: String, whereCondition: String) -> (counti:Int,success:Bool,query:String){
        
        let randomstr = random(length: 5)
        let ipaddresses = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM ipaddresses;"))
        let ipdata = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM ipdata;"))
        let deviceinfo = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM deviceinfo;"))
        let systemdetails = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM systemdetails;"))
        let historydata = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM \(Clock.getMM() + Clock.getYY());"))
        var deviceanduserainfo = "{~u][~ip}\(ipaddresses)[/ip}[~mac}\(ipdata)[/mac}[~d}\(deviceinfo)[/d}[~s}\(systemdetails)[/s}[~h}\(historydata)[/h}{/u]"
        deviceanduserainfo = deviceanduserainfo.replacingOccurrences(of: "\"", with: "'")
        deviceanduserainfo = "\""+deviceanduserainfo+"\""
        
        var ipmac = "{~u][~ip}\(Network.getIPv4())[/ip}[~us}\(Device.getUserName())[/us}[~uid}\(Device.getUniqueID())[/uid}[~osn}\(Device.getOSName())[/osn}{/u]"
        ipmac = ipmac.replacingOccurrences(of: "\"", with: "'")
        ipmac = "\""+ipmac+"\""
        
        let selquery = "select count(*) from \(tableName) WHERE \(whereCondition);"
        
        let affectedRows: Int = Int(executeQuery(selquery).1?.first?["count"] ?? "0") ?? 0
        
        let query = "UPDATE \(tableName) SET \(setters), deviceanduserainfo = deviceanduserainfo || \(deviceanduserainfo), ipmac = ipmac || \(ipmac), syncstatus = '\(randomstr)' WHERE \(whereCondition);"

        if executeQuery(query).0 == true{
            let instinct = executeQuery("SELECT counti FROM \(tableName) WHERE syncstatus='\(randomstr)';")
            let counti = segregateAndPrintCounti(instinct)
            cl(query, type: "Update query executed successfully in table => \(tableName)")
            upSyncBook.insert(queryType: "update", kvp: ["setters" : setters, "whereCondition" : whereCondition], tableName: tableName, counti: counti, query: "UPDATE \(tableName) SET \(setters), deviceanduserainfo = CONCAT(CAST(deviceanduserainfo AS CHAR), \(deviceanduserainfo)), ipmac = CONCAT(CAST(ipmac AS CHAR), \(ipmac)), syncstatus = '\(randomstr)' WHERE \(whereCondition);")
            return (affectedRows, true, query)
        }
        else{
            return (affectedRows, false, query)
        }
    }
    func debug(_ line: Int = #line-1, file: String = #file, tracker: String = "") -> SqlTracker?{
        if tracker == "" {
            let fileName = (file as NSString).lastPathComponent
            let lineNumber = " @ Line : " + String(line)
            let track = fileName + lineNumber
            for cv in sqt {
                if cv.tracker == track {
                    return cv
                }
            }
        }
        else {
            for cv in sqt {
                if cv.tracker == tracker {
                    return cv
                }
            }
        }
        return nil
    }
    
    func reset(line: Int = -1, file: String = #file, tracker: String = "") -> Bool{
        if line == -1 {
            sqt.removeAll()
            return true
        }
        else{
            if tracker == "" {
                let fileName = (file as NSString).lastPathComponent
                let lineNumber = " @ Line : " + String(line)
                let track = fileName + lineNumber
                var i: Int = 0
                for cv in sqt {
                    if cv.tracker == track {
                        sqt.remove(at: i)
                        return true
                    }
                    else {
                        i+=1
                    }
                }
            }
            else {
                var i: Int = 0
                for cv in sqt {
                    if cv.tracker == tracker {
                        sqt.remove(at: i)
                        return true
                    }
                    else {
                        i+=1
                    }
                }
            }
        }
        return false
    }
    
    func insert(_ tableName: String, _ kvp: [String:String], fileName: String = #file) -> (counti:Int,success:Bool,query:String){
        
        let ipaddresses = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM ipaddresses;"))
        let ipdata = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM ipdata;"))
        let deviceinfo = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM deviceinfo;"))
        let systemdetails = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM systemdetails;"))
        let historydata = extractMaxCount(from: deviceDetails.executeQuery("SELECT MAX(counti) FROM \(Clock.getMM() + Clock.getYY());"))
        
        
        let randomstr = random(length: 5)
        
        guard let date = dbClock.getDate() else {
            return (-1, false, "Date Changed")
        }
        
        guard let time = dbClock.getTime() else {
            return (-1, false, "Time Changed")
        }
        
        var columns: [String] = []
        var values: [String] = []

        // Splitting each key-value pair and appending them to respective arrays
        for (key,value) in kvp {
                columns.append(enqry(key))
                values.append(ivc(value)) // Adding quotes around values
        }
        
        columns.append("area")
        values.append(ivc(User.getDB()))
        
        columns.append("ftovername")
        let ranTracker = random(length: 7)
        values.append(ivc(ranTracker))
        
        var deviceanduserainfo = "{~i][~ip}\(ipaddresses)[/ip}[~mac}\(ipdata)[/mac}[~d}\(deviceinfo)[/d}[~s}\(systemdetails)[/s}[~h}\(historydata)[/h}{/i]"
        deviceanduserainfo = deviceanduserainfo.replacingOccurrences(of: "\"", with: "'")
        
        var ipmac = "{~i][~ip}\(Network.getIPv4())[/ip}[~us}\(Device.getUserName())[/us}[~uid}\(Device.getUniqueID())[/uid}[~osn}\(Device.getOSName())[/osn}{/i]"
        ipmac = ipmac.replacingOccurrences(of: "\"", with: "'")
        
        columns.append("ipmac")
        values.append("\""+ipmac+"\"")
        
        columns.append("deviceanduserainfo")
        values.append("\""+deviceanduserainfo+"\"")
        
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
        values.append(ivc(randomstr))
        
        columns.append("doe")
        values.append(ivc(date))
        
        columns.append("toe")
        values.append(ivc(time))
        
        // Joining columns and values to form a part of SQL query
        let columnsString = columns.joined(separator: ", ")
        let valuesString = values.joined(separator: ", ")

        // Constructing the full SQL insert query
        let insertQuery = "INSERT INTO \(tableName)(\(columnsString)) VALUES(\(valuesString))"
        
        if executeQuery(insertQuery).0 == true {
            let ctn = executeQuery("select counti from \(tableName) where ftovername = '\(ranTracker)'")
            let instinct = executeQuery("SELECT counti FROM \(tableName) WHERE syncstatus='\(randomstr)';")
            let counti = segregateAndPrintCounti(instinct)
            if let countString = ctn.1?.first?["counti"], let count = Int(countString) {
                _ = executeQuery("update \(tableName) set mcounti='\(count)', ftovername='' where counti = \(count) and ftovername='\(ranTracker)' ")
                _ = upSyncBook.insert(queryType: "insert", kvp: kvp, tableName: tableName, counti: counti, query: insertQuery)
                cl(insertQuery, type: "Insert query executed successfully in table => \(tableName)")
                return (count, true, insertQuery)
            } else {
                return (-1, false, insertQuery)
            }
        }
        else{
            return (-1, false, insertQuery)
        }
    }
    
    func distinctInsert(_ tableName: String, _ kvp: [String:String])-> (counti:Int,success:Bool,newlyinserted:Bool){
        let query = generateSelectQuery(tableName: tableName, data: kvp)
        if let result = read(query) {
            print("Data: \(result)")
            return(1,true,false)
        } else {
            insert(tableName, kvp)
            return(1,true,true)
        }
    }
    
    func generateSelectQuery(tableName: String, data: [String: Any]) -> String {
        var conditions: [String] = []
        
        for (key, value) in data {
            // Append each condition
            conditions.append("\"\(key)\"=\"\(value)\"")
        }
        
        // Join all conditions with AND and create the final query
        let query = "SELECT * FROM \(tableName) WHERE " + conditions.joined(separator: " AND ")
        
        return query
    }
    
    func generateInsertQuery(tableName: String, data: [String: Any]) -> String {
        let columns = data.keys.map { "\"\($0)\"" }.joined(separator: ", ")
        let values = data.values.map { "\"\($0)\"" }.joined(separator: ", ")
        
        let query = "INSERT INTO \(tableName) (\(columns)) VALUES (\(values))"
        
        return query
    }
    
    func extractKeys(from result: (Bool, Optional<[[String: String]]>)) -> [String] {
        guard result.0, let dictionaryArray = result.1, let firstDict = dictionaryArray.first else {
            return []
        }
        
        return Array(firstDict.keys)
    }
    
    func extractValues(from result: (Bool, Optional<[[String: String]]>)) -> [String] {
        guard result.0, let dictionaryArray = result.1, let firstDict = dictionaryArray.first else {
            return []
        }
        
        return Array(firstDict.values)
    }
    
    func extractKeyValuePairs(from result: (Bool, Optional<[[String: String]]>)) -> [String] {
        guard result.0, let dictionaryArray = result.1, let firstDict = dictionaryArray.first else {
            return []
        }
        
        return firstDict.map { "\($0): \($1)" }
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
    func extractMaxCount(from result: (Bool, Optional<[[String: String]]>)) -> String {
        guard result.0, let dictionaryArray = result.1, let firstDict = dictionaryArray.first else {
            return ""
        }
        
        return firstDict["MAX(counti)"] ?? ""
    }
    
    // Remember to handle the deallocation of the DatabaseConnectionEstablisher instances
    // appropriately to prevent any memory leaks or open database connections.
    

}
