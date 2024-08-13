//
//  Recorder.swift
//  SystemInfo
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 08/03/24.
//

import Foundation
var deviceDetails = DeviceInfoRecorder()
let doe = dbClock.getDateforDB()
let toe = dbClock.getTimeforDB()

class DeviceInfoRecorder: DeviceInfoGraphics {
    
    var sqt5 = [SqlTracker]()
    
    var osType: String? = nil
    var deviceType: String? = nil
    var IMEI: String? = nil
    
    var internetProviderKey: String? = nil
    var ipKey: String? = nil
    
    var userDetailsKey: String? = nil
    var changingDetailsKey: String? = nil
    var fixedDetailsKey: String? = nil
    var gpsDetailsKey: String? = nil
    
    override init(){
        super.init()
        ////user_and_login_info x
        ////appleid, primaryphno, secondaryphno, queue, area, areas, owncomcode, mavrichash, expirydate, counti, doe, toe, syncstatus x
        
        ////ipaddresses x
        ////publicip, ipv4, ipv6, counti, doe , toe, syncstatus x
        
        //internet_provider_details
        //everything in struct, counti, doe, toe, syncstatus
        
        ////date and time keeper
        ////systemdate, systemtime, apilink, apidate, apitime, counti, syncstatus
        
        //changing details like battery, proximity and storage
        //osversion
        
        //changing details history
        
        ////fixed device details
        ////screenheight, screenwidth, storagesize, username, devicename, imeihash, devicetype, modelname, osname, counti, doe, toe, syncstatus
        
        //gps details
        //gps history
    }
    var sqt = [SqlTracker]()
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
                    clSync("tracker : \(track) reused for \(sqlTracer.query) and \(query)",type: "SQL Warning")
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
    
    func createBasicTables() {
        // ipaddress
        clSync(type:"create Basic SystemInfo | DeviceFingerPrints Tables")
        do{
            var ctq: String = "CREATE TABLE IF NOT EXISTS "
            ctq = ctq + "querysync"
            ctq = ctq + " ("
            ctq = ctq + """
        `query` TEXT,
        `syncstatus` TEXT,
        `mac` TEXT,
        `tablename` TEXT,
        `counti` INTEGER PRIMARY KEY,
        `countifromtable` TEXT,
        `doe` DATE,
        `toe` TIME
    """
            ctq = ctq + ")"
            var _ = executeQuery(ctq)
            clSync("Table Created",type:"ipaddresses")
        }
        catch{
            clSync("Table Not Created",type:"ipaddresses")
        }
        
        do{
            var ctq: String = "CREATE TABLE IF NOT EXISTS "
            ctq = ctq + "ipaddresses"
            ctq = ctq + " ("
            ctq = ctq + """
            `publicip` TEXT DEFAULT NULL,
            `ipv4` TEXT DEFAULT NULL,
            `ipv6` TEXT DEFAULT NULL,
            `syncstatus` TEXT DEFAULT NULL,
            `mac` TEXT DEFAULT NULL,
            `counti` INTEGER PRIMARY KEY,
            `countifromserver` TEXT DEFAULT NULL,
            `doe` DATE,
            `toe` TIME
        """
            ctq = ctq + ")"
            var _ = executeQuery(ctq)
            clSync("Table Created",type:"ipaddresses")
        }catch{
            clSync("Table Not Created",type:"ipaddresses")
        }
        do {
            let randomstr = random(length: 5)
            let publicip = Network.getIP()
            let ipv4 = Network.getIPv4()
            let ipv6 = Network.getIPv6()
            let mac = Device.getUniqueID()
            let doe = dbClock.getDateforDB() // Assuming getDateforDB() returns a DATE string
            let toe = dbClock.getTimeforDB() // Assuming getTimeforDB() returns a TIME string
            
            // Building the insert query
            var insertQuery: String = "INSERT INTO ipaddresses "
            insertQuery = insertQuery + "("
            insertQuery = insertQuery + """
            `publicip`,
            `ipv4`,
            `ipv6`,
            `syncstatus`,
            `mac`,
            `doe`,
            `toe`
            """
            insertQuery = insertQuery + ") VALUES ("
            insertQuery = insertQuery + """
            '\(publicip)',
            '\(ipv4)',
            '\(ipv6)',
            '\(randomstr)',
            '\(mac)',
            '\(doe)',
            '\(toe)'
            """
            insertQuery = insertQuery + ")"
            var selectQuery: String = "SELECT * FROM ipaddresses WHERE `publicip` = '\(publicip)' AND `ipv4` = '\(ipv4)' AND `ipv6` = '\(ipv6)'"
            if let result = read(selectQuery){
                clSync(result,type:"ipaddresses ==> Data already available")
            }
            else{
                let (success, _) = executeQuery(insertQuery)
                let instinct = deviceDetails.executeQuery("SELECT counti FROM ipaddresses WHERE syncstatus='\(randomstr)';")
                let counti = deviceDetails.segregateAndPrintCounti(instinct)
                if success {
                    self.sync_query(query: insertQuery, table: "ipaddresses", countifromtable: counti)
                    clSync("Data inserted successfully", type: "si")
                } else {
                    clSync("Failed to insert data", type: "si")
                }
            }
        } catch {
            clSync("Error: \(error)", type: "si")
        }
        
        
        
        do {
            var ctq: String = "CREATE TABLE IF NOT EXISTS "
            ctq += Clock.getMM() + Clock.getYY()
            ctq += " ("
            ctq += """
            `longitude` TEXT DEFAULT NULL,
            `latitude` TEXT DEFAULT NULL,
            `altitude` TEXT DEFAULT NULL,
            `storagesize` TEXT DEFAULT NULL,
            `freespace` TEXT DEFAULT NULL,
            `usedspace` TEXT DEFAULT NULL,
            `syncstatus` TEXT DEFAULT NULL,
            `mac` TEXT DEFAULT NULL,
            `counti` INTEGER PRIMARY KEY,
            `doe` DATE DEFAULT NULL,
            `toe` TIME DEFAULT NULL
            """
            ctq += ")"
            let _ = executeQuery(ctq)
            clSync("Table Created", type: "ipaddresses")
        } catch {
            clSync("Table Not Created", type: "ipaddresses")
        }

        do {
            let randomstr = random(length: 5)
            let latitude = String(describing: GPS.getLatitude())
            let longitude = String(describing: GPS.getLongitude())
            let altitude = String(describing: GPS.getAltitude())
            let storagesize = Device.getStorageSize()
            let freespace = Device.getFreeSpace()
            let usedspace = Device.getUsedSpace()
            let mac = Device.getUniqueID()
            let doe = dbClock.getDateforDB() // Ensure this returns a valid DATE string
            let toe = dbClock.getTimeforDB() // Ensure this returns a valid TIME string
            
            // Building the insert query
            var insertQuery: String = "INSERT INTO \(Clock.getMM() + Clock.getYY()) "
            insertQuery += "("
            insertQuery += """
            `longitude`,
            `latitude`,
            `altitude`,
            `storagesize`,
            `freespace`,
            `usedspace`,
            `syncstatus`,
            `mac`,
            `doe`,
            `toe`
            """
            insertQuery += ") VALUES ("
            insertQuery += """
            '\(longitude)',
            '\(latitude)',
            '\(altitude)',
            '\(storagesize)',
            '\(freespace)',
            '\(usedspace)',
            '\(randomstr)',
            '\(mac)',
            '\(doe)',
            '\(toe)'
            """
            insertQuery += ")"
            
            var selectQuery: String = "SELECT * FROM \(Clock.getMM() + Clock.getYY()) WHERE `longitude` = '\(longitude)' AND `latitude` = '\(latitude)' AND `altitude` = '\(altitude)' AND `storagesize` = '\(storagesize)' AND `freespace` = '\(freespace)' AND `usedspace` = '\(usedspace)'"
            
            if let result = read(selectQuery){
                clSync(result,type:"\(Clock.getMM() + Clock.getYY()) ==> Data already available")
            }
            else{
                let (success, _) = executeQuery(insertQuery)
                clSync(insertQuery)
                let instinct = deviceDetails.executeQuery("SELECT counti FROM \(Clock.getMM() + Clock.getYY()) WHERE syncstatus='\(randomstr)';")
                let counti = deviceDetails.segregateAndPrintCounti(instinct)
                
                if success {
                    self.sync_query(query: insertQuery, table: Clock.getMM() + Clock.getYY(), countifromtable: counti)
                    clSync("Data inserted successfully", type: "si")
                } else {
                    clSync("Failed to insert data", type: "si")
                }
            } }
        catch {
            clSync("Error: \(error)", type: "si")
        }

        
        
        
        
        
        
        
        
        do {
            var ctq: String = "CREATE TABLE IF NOT EXISTS "
            ctq = ctq + "appleuserdetails"
            ctq = ctq + " ("
            ctq = ctq + """
            `appleid` TEXT,
            `primaryphno` TEXT,
            `secondaryphno` TEXT,
            `queue` TEXT,
            `area` TEXT,
            `areas` TEXT,
            `owncomcode` TEXT,
            `mavrichash` TEXT,
            `expirydate` DATE,
            `syncstatus` TEXT,
            `mac` TEXT,
            `counti` INTEGER PRIMARY KEY,
            `doe` DATE,
            `toe` TIME
            """
            ctq = ctq + ")"
            var _ = executeQuery(ctq)
            clSync("table created", type: "mounish")
        } catch {
            clSync("table not created", type: "mounish")
        }

        
        
        
        
        do {
            var ctq: String = "CREATE TABLE IF NOT EXISTS "
            ctq = ctq + "systemdetails"
            ctq = ctq + " ("
            ctq = ctq + """
            `systemdate` DATE,
            `systemtime` TIME,
            `apilink` TEXT,
            `apidate` DATE,
            `apitime` TIME,
            `syncstatus` TEXT,
            `mac` TEXT,
            `counti` INTEGER PRIMARY KEY
            """
            ctq = ctq + ")"
            var _ = executeQuery(ctq)
            clSync("table created", type: "mounish")
        } catch {
            clSync("table not created", type: "mounish")
        }
        
        
        
        
        do {
            var ctq: String = "CREATE TABLE IF NOT EXISTS "
            ctq += "ipdata ("
            ctq += """
            `ip_address` TEXT DEFAULT NULL,
            `is_eu` TEXT DEFAULT NULL,
            `city` TEXT DEFAULT NULL,
            `city_geoname_id` INTEGER DEFAULT NULL,
            `region` TEXT DEFAULT NULL,
            `region_iso_code` TEXT DEFAULT NULL,
            `region_geoname_id` INTEGER DEFAULT NULL,
            `postal_code` TEXT DEFAULT NULL,
            `zip_code` TEXT DEFAULT NULL,
            `country` TEXT DEFAULT NULL,
            `country_code` TEXT DEFAULT NULL,
            `country_geoname_id` INTEGER DEFAULT NULL,
            `country_is_eu` INTEGER DEFAULT NULL,
            `continent` TEXT DEFAULT NULL,
            `continent_code` TEXT DEFAULT NULL,
            `continent_geoname_id` INTEGER DEFAULT NULL,
            `longitude` REAL DEFAULT NULL,
            `latitude` REAL DEFAULT NULL,
            `calling_code` INTEGER DEFAULT NULL,
            `is_vpn` INTEGER DEFAULT NULL,
            `is_threat` INTEGER DEFAULT NULL,
            `is_proxy` INTEGER DEFAULT NULL,
            `timezone_name` TEXT DEFAULT NULL,
            `timezone_abbreviation` TEXT DEFAULT NULL,
            `timezone_gmt_offset` INTEGER DEFAULT NULL,
            `timezone_current_time` TEXT DEFAULT NULL,
            `timezone_is_dst` INTEGER DEFAULT NULL,
            `flag_emoji` TEXT DEFAULT NULL,
            `flag_unicode` TEXT DEFAULT NULL,
            `flag_png_url` TEXT DEFAULT NULL,
            `flag_svg_url` TEXT DEFAULT NULL,
            `currency_name` TEXT DEFAULT NULL,
            `currency_code` TEXT DEFAULT NULL,
            `asn_asn` TEXT DEFAULT NULL,
            `asn_name` TEXT DEFAULT NULL,
            `asn_route` TEXT DEFAULT NULL,
            `asn_type` TEXT DEFAULT NULL,
            `asn_domain` TEXT DEFAULT NULL,
            `connection_autonomous_system_number` INTEGER DEFAULT NULL,
            `connection_autonomous_system_organization` TEXT DEFAULT NULL,
            `connection_type` TEXT DEFAULT NULL,
            `connection_isp_name` TEXT DEFAULT NULL,
            `connection_organization_name` TEXT DEFAULT NULL,
            `area` TEXT DEFAULT NULL,
            `ipmac` TEXT DEFAULT NULL,
            `deviceanduserinfo` TEXT DEFAULT 'NONE',
            `basesite` TEXT DEFAULT 'NONE',
            `owncomcode` TEXT DEFAULT 'NONE',
            `testeridentity` TEXT DEFAULT NULL,
            `testcontrol` TEXT DEFAULT NULL,
            `adderpid` TEXT DEFAULT NULL,
            `addername` TEXT DEFAULT NULL,
            `adder` TEXT DEFAULT NULL,
            `asn` TEXT DEFAULT NULL,
            `loc` TEXT DEFAULT NULL,
            `region_type` TEXT DEFAULT NULL,
            `flag` TEXT DEFAULT NULL,
            `emojiFlag` TEXT DEFAULT NULL,
            `emojiUnicode` TEXT DEFAULT NULL,
            `currency_symbol` TEXT DEFAULT NULL,
            `currency_native` TEXT DEFAULT NULL,
            `currency_plural` TEXT DEFAULT NULL,
            `languages_name` TEXT DEFAULT NULL,
            `languages_code` TEXT DEFAULT NULL,
            `languages_native` TEXT DEFAULT NULL,
            `timezone_offset` TEXT DEFAULT NULL,
            `isTor` INTEGER DEFAULT NULL,
            `isIcloudRelay` INTEGER DEFAULT NULL,
            `isDatacenter` INTEGER DEFAULT NULL,
            `isAnonymous` INTEGER DEFAULT NULL,
            `isKnownAttacker` INTEGER DEFAULT NULL,
            `isKnownAbuser` INTEGER DEFAULT NULL,
            `isBogon` INTEGER DEFAULT NULL,
            `blocklists` TEXT DEFAULT NULL,
            `privacy_vpn` INTEGER DEFAULT NULL,
            `privacy_proxy` INTEGER DEFAULT NULL,
            `privacy_tor` INTEGER DEFAULT NULL,
            `privacy_relay` INTEGER DEFAULT NULL,
            `privacy_hosting` INTEGER DEFAULT NULL,
            `privacy_service` TEXT DEFAULT NULL,
            `abuse_address` TEXT DEFAULT NULL,
            `abuse_country` TEXT DEFAULT NULL,
            `abuse_email` TEXT DEFAULT NULL,
            `abuse_name` TEXT DEFAULT NULL,
            `abuse_network` TEXT DEFAULT NULL,
            `abuse_phone` TEXT DEFAULT NULL,
            `domains_page` INTEGER DEFAULT NULL,
            `domains_total` INTEGER DEFAULT NULL,
            `domains_list` TEXT DEFAULT NULL,
            `website` TEXT DEFAULT NULL,
            `api_key` TEXT DEFAULT NULL,
            `syncstatus` TEXT DEFAULT NULL,
            `mac` TEXT DEFAULT NULL,
            `counti` INTEGER PRIMARY KEY AUTOINCREMENT,
            `countifromserver` INTEGER DEFAULT NULL,
            `doe` DATE DEFAULT NULL,
            `toe` TIME DEFAULT NULL
            """
            ctq += ")"
            let (success, _) = executeQuery(ctq)
            if success {
                clSync("table created", type: "mounish")
            } else {
                clSync("table not created", type: "mounish")
            }
        } catch {
            clSync("Error: \(error)", type: "mounish")
        }
        
        do {
            var ctq: String = "CREATE TABLE IF NOT EXISTS "
            ctq += "deviceinfo" // Name of the new table
            ctq += " ("
            ctq += """
            `screenheight` TEXT,
            `screenwidth` TEXT,
            `storagesize` TEXT,
            `username` TEXT,
            `devicename` TEXT,
            `devicetype` TEXT,
            `modelname` TEXT,
            `osname` TEXT,
            `osversion` TEXT,
            `syncstatus` TEXT,
            `mac` TEXT,
            `counti` INTEGER PRIMARY KEY,
            `doe` DATE,
            `toe` TIME
            """
            ctq += ")"
            var _ = executeQuery(ctq)
            clSync("table created", type: "mounish")
        } catch {
            clSync("table not created", type: "mounish")
        }
        
        do {
            let screenheight = Device.getScreenHeight()
            let screenwidth = Device.getScreenWidth()
            let storagesize = Device.getStorageSize()
            let username = Device.getUserName()
            let devicename = Device.getModelName()
            let mac = Device.getUniqueID()
            let devicetype = "smartphone" // Assuming a static value; adjust as needed
            let modelname = Device.getModelName()
            let osname = Device.getOSName()
            let osversion = Device.getOSVersion()
            let doe = dbClock.getDateforDB() // Assuming getDateforDB() returns a DATE string
            let toe = dbClock.getTimeforDB() // Assuming getTimeforDB() returns a TIME string
            let syncstatus = "synced" // Assuming a static value; adjust as needed
            
            // Building the insert query
            var insertQuery: String = "INSERT INTO deviceinfo "
            insertQuery += " ("
            insertQuery += """
            `screenheight`,
            `screenwidth`,
            `storagesize`,
            `username`,
            `devicename`,
            `mac`,
            `devicetype`,
            `modelname`,
            `osname`,
            `osversion`,
            `doe`,
            `toe`,
            `syncstatus`
            """
            insertQuery += ") VALUES ("
            insertQuery += """
            '\(screenheight)',
            '\(screenwidth)',
            '\(storagesize)',
            '\(username)',
            '\(devicename)',
            '\(mac)',
            '\(devicetype)',
            '\(modelname)',
            '\(osname)',
            '\(osversion)',
            '\(doe)',
            '\(toe)',
            '\(syncstatus)'
            """
            insertQuery += ")"
            
            var selectQuery: String = "SELECT * FROM deviceinfo WHERE `screenheight` = '\(screenheight)' AND `screenwidth` = '\(screenwidth)' AND `storagesize` = '\(storagesize)' AND `username` = '\(username)' AND `devicename` = '\(devicename)' AND `mac` = '\(mac)' AND `devicetype` = '\(devicetype)' AND `modelname` = '\(modelname)' AND `osname` = '\(osname)' AND `osversion` = '\(osversion)'"
            
            if let result = read(selectQuery){
                clSync(result,type:"deviceinfo ==> Data already available")
            }
            else{
                // Executing the insert query
                let (success, _) = executeQuery(insertQuery)
                
                if success {
                    clSync("Data inserted successfully", type: "si")
                } else {
                    clSync("Failed to insert data", type: "si")
                }
            } }catch {
            clSync("Error: \(error)", type: "si")
        }
        
        
        
        
        
    }
    
    func getMac() -> String {
        return ""
    }
    
    func getIP() -> String {
        return ""
    }
    
    func getDeviceAndUserDataForeignKey() -> String {
        return ""
    }
    
    // Struct to hold the IP data
    
    func updateAddressFromipinfoIoAPIToken1() {
        let randomstr = random(length: 5)
        // Your IPInfo API access token
        let accessToken = ipinfoIoAccessToken1 // Raghul's Access Token
        
        // The IPInfo API URL
        let urlString = "\(ipinfoIo)?token=\(accessToken)" // https://ipinfo.io
        
        clSync(urlString)
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            clSync("Invalid URL: \(urlString)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipinfoIoAPIToken1")
            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if URL is invalid
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipinfoIoAPIToken1")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Ensure there is data returned
            guard let data = data else {
                clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipinfoIoAPIToken1")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Attempt to decode the data as JSON
            do {
                // Decode the JSON data, ensuring optional values are handled correctly
                let decodedData = try JSONDecoder().decode(ipinfoIoAPIToken.self, from: data)
                
                // Prepare columns and values dictionary
                var columnsAndValues: [String: Any?] = [
                    "ip_address": decodedData.ip,
                    "city": decodedData.city,
                    "region": decodedData.region,
                    "country": decodedData.country,
                    "loc": decodedData.loc,
                    "postal_code": decodedData.postal,
                    "timezone_name": decodedData.timezone,
                    "asn_asn": decodedData.asn?.asn,
                    "asn_name": decodedData.asn?.name,
                    "asn_route": decodedData.asn?.route,
                    "asn_type": decodedData.asn?.type,
                    "asn_domain": decodedData.asn?.domain,
                    "doe": doe,
                    "toe": toe,
                    "website": ipinfoIo,
                    "api_key": accessToken,
                    "syncstatus": randomstr
                ]
                
                // Filter out the nil values
                columnsAndValues = columnsAndValues.filter { $0.value != nil }
                
                // Convert values to SQL-friendly format
                let columns = columnsAndValues.keys.joined(separator: ", ")
                let values = columnsAndValues.values.map { value -> String in
                    if let boolValue = value as? Bool {
                        return boolValue ? "1" : "0"
                    } else if let stringValue = value as? String {
                        return "'\(stringValue)'"
                    } else if let intValue = value as? Int {
                        return "\(intValue)"
                    } else if let doubleValue = value as? Double {
                        return "\(doubleValue)"
                    } else {
                        return "NULL"
                    }
                }.joined(separator: ", ")
                
                // Construct the SQL INSERT query
                let insertQuery = "INSERT INTO ipdata (\(columns)) VALUES (\(values))"
                let selectQuery = self.generateSelectQuery(from: columnsAndValues, tableName: "ipdata")
                
                if let result = self.read(selectQuery){
                    clSync(result,type:"updateAddressFromipinfoIoAPIToken1 ==> Data already available")
                }
                else{
                    // Execute the SQL query
                    let (success, _) = self.executeQuery(insertQuery)
                    let instinct = deviceDetails.executeQuery("SELECT counti FROM ipdata WHERE syncstatus='\(randomstr)';")
                    let counti = deviceDetails.segregateAndPrintCounti(instinct)
                    if success {
                        self.sync_query(query: insertQuery, table: "ipdata", countifromtable: counti)
                        clSync(insertQuery)
                        clSync("Data inserted successfully")
                    } else {
                        clSync("Failed to insert data")
                        deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if query execution fails
                    }
                    
                } }catch {
                clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromipinfoIoAPIToken1")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
            }
        }
        
        // Start the task
        task.resume()
        clSync("Successfully Fetched Details from \(ipinfoIo) for Token-1 \(ipinfoIoAccessToken1)")
    }

    
    func updateAddressFromipinfoIoAPIToken2() {
        let randomstr = random(length: 5)
        // Your IPInfo API access token
        let accessToken = ipinfoIoAccessToken2 // Shahina's Access Token
        
        // The IPInfo API URL
        let urlString = "\(ipinfoIo)?token=\(accessToken)" // https://ipinfo.io
        
        clSync(urlString)
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            clSync("Invalid URL: \(urlString)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipinfoIoAPIToken2")
            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if URL is invalid
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipinfoIoAPIToken2")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Ensure there is data returned
            guard let data = data else {
                clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipinfoIoAPIToken2")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Attempt to decode the data as JSON
            do {
                // Decode the JSON data, ensuring optional values are handled correctly
                let decodedData = try JSONDecoder().decode(ipinfoIoAPIToken.self, from: data)
                
                // Prepare columns and values dictionary
                var columnsAndValues: [String: Any?] = [
                    "ip_address": decodedData.ip,
                    "city": decodedData.city,
                    "region": decodedData.region,
                    "country": decodedData.country,
                    "loc": decodedData.loc,
                    "postal_code": decodedData.postal,
                    "timezone_name": decodedData.timezone,
                    "asn_asn": decodedData.asn?.asn,
                    "asn_name": decodedData.asn?.name,
                    "asn_route": decodedData.asn?.route,
                    "asn_type": decodedData.asn?.type,
                    "asn_domain": decodedData.asn?.domain,
                    "doe": doe,
                    "toe": toe,
                    "website": ipinfoIo,
                    "api_key": accessToken,
                    "syncstatus": randomstr
                ]
                
                // Filter out the nil values
                columnsAndValues = columnsAndValues.filter { $0.value != nil }
                
                // Convert values to SQL-friendly format
                let columns = columnsAndValues.keys.joined(separator: ", ")
                let values = columnsAndValues.values.map { value -> String in
                    if let boolValue = value as? Bool {
                        return boolValue ? "1" : "0"
                    } else if let stringValue = value as? String {
                        return "'\(stringValue)'"
                    } else if let intValue = value as? Int {
                        return "\(intValue)"
                    } else if let doubleValue = value as? Double {
                        return "\(doubleValue)"
                    } else {
                        return "NULL"
                    }
                }.joined(separator: ", ")
                
                // Construct the SQL INSERT query
                let insertQuery = "INSERT INTO ipdata (\(columns)) VALUES (\(values))"
                
                let selectQuery = self.generateSelectQuery(from: columnsAndValues, tableName: "ipdata")
                
                if let result = self.read(selectQuery){
                    clSync(result,type:"updateAddressFromipinfoIoAPIToken2 ==> Data already available")
                }
                else{
                    // Execute the SQL query
                    let (success, _) = self.executeQuery(insertQuery)
                    let instinct = deviceDetails.executeQuery("SELECT counti FROM ipdata WHERE syncstatus='\(randomstr)';")
                    let counti = deviceDetails.segregateAndPrintCounti(instinct)
                    if success {
                        self.sync_query(query: insertQuery, table: "ipdata", countifromtable: counti)
                        clSync(insertQuery)
                        clSync("Data inserted successfully")
                    } else {
                        clSync("Failed to insert data")
                        deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if query execution fails
                    }
                    
                } }catch {
                clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromipinfoIoAPIToken2")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
            }
        }
        
        // Start the task
        task.resume()
        clSync("Successfully Fetched Details from \(ipinfoIo) for Token-2 \(ipinfoIoAccessToken2)")
    }

    
    func updateAddressFromipDataCoAccessToken1() {
        let randomstr = random(length: 5)
        // The ipdata.co API URL
        let urlString = "https://api.ipdata.co/?api-key=\(ipDataCoAccessToken1)"
        clSync(urlString, #line)
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            clSync("Invalid URL: \(urlString)", "Network Error")
            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if URL is invalid
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                clSync("Couldn't fetch data: \(error)", "Network Error")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Ensure there is data returned
            guard let data = data else {
                clSync("No data returned", "Network Error")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Attempt to decode the data as JSON
            do {
                // Decode the JSON data (using the 'IPData' struct)
                let decoded = try JSONDecoder().decode(IPData.self, from: data)
                
                // Prepare columns and values dictionary
                var columnsAndValues: [String: Any?] = [
                    "ip_address": decoded.ip,
                    "is_eu": decoded.isEu,
                    "country": decoded.countryName,
                    "country_code": decoded.countryCode,
                    "continent": decoded.continentName,
                    "latitude": decoded.latitude,
                    "longitude": decoded.longitude,
                    "calling_code": decoded.callingCode,
                    "flag_svg_url": decoded.flag,
                    "flag_emoji": decoded.emojiFlag,
                    "asn_asn": decoded.asn.asn,
                    "asn_name": decoded.asn.name,
                    "asn_route": decoded.asn.route,
                    "asn_type": decoded.asn.type,
                    "currency_name": decoded.currency.name,
                    "currency_code": decoded.currency.code,
                    "currency_symbol": decoded.currency.symbol,
                    "currency_native": decoded.currency.native,
                    "timezone_name": decoded.timeZone.name,
                    "timezone_offset": decoded.timeZone.offset,
                    "timezone_current_time": decoded.timeZone.currentTime,
                    "is_threat": decoded.threat.isThreat,
                    "doe": doe,
                    "toe": toe,
                    "website": "https://api.ipdata.co/",
                    "api_key": ipDataCoAccessToken1,
                    "syncstatus": randomstr
                ]
                
                // Handle languages
                var languageNames = [String]()
                var languageCodes = [String]()
                var languageNatives = [String]()
                decoded.languages.forEach { language in
                    languageNames.append(language.name)
                    languageCodes.append(language.code)
                    languageNatives.append(language.native)
                }
                columnsAndValues["languages_name"] = languageNames.joined(separator: ", ")
                columnsAndValues["languages_code"] = languageCodes.joined(separator: ", ")
                columnsAndValues["languages_native"] = languageNatives.joined(separator: ", ")
                
                // Filter out the nil values
                columnsAndValues = columnsAndValues.filter { $0.value != nil }
                
                // Convert values to SQL-friendly format
                let columns = columnsAndValues.keys.joined(separator: ", ")
                let values = columnsAndValues.values.map { value -> String in
                    if let boolValue = value as? Bool {
                        return boolValue ? "1" : "0"
                    } else if let stringValue = value as? String {
                        return "'\(stringValue)'"
                    } else if let intValue = value as? Int {
                        return "\(intValue)"
                    } else if let doubleValue = value as? Double {
                        return "\(doubleValue)"
                    } else {
                        return "NULL"
                    }
                }.joined(separator: ", ")
                
                // Construct the SQL INSERT query
                let insertQuery = "INSERT INTO ipdata (\(columns)) VALUES (\(values))"
                
                let selectQuery = self.generateSelectQuery(from: columnsAndValues, tableName: "ipdata")
                
                if let result = self.read(selectQuery){
                    clSync(result,type:"updateAddressFromipDataCoAccessToken1 ==> Data already available")
                }
                else{
                    // Execute the SQL query
                    let (success, _) = self.executeQuery(insertQuery)
                    let instinct = deviceDetails.executeQuery("SELECT counti FROM ipdata WHERE syncstatus='\(randomstr)';")
                    let counti = deviceDetails.segregateAndPrintCounti(instinct)
                    if success {
                        self.sync_query(query: insertQuery, table: "ipdata", countifromtable: counti)
                        clSync(insertQuery)
                        clSync("Data inserted successfully")
                    } else {
                        clSync("Failed to insert data")
                        deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if query execution fails
                    }
                    
                } }catch {
                clSync("Couldn't decode JSON: \(error)", "API Error")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
            }
        }
        
        // Start the task
        task.resume()
    }

    
    func updateAddressFromipDataCoAccessToken2() {
        let randomstr = random(length: 5)
        // The ipdata.co API URL
        let urlString = "https://api.ipdata.co/?api-key=\(ipDataCoAccessToken2)"
        clSync(urlString, #line)
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            clSync("Invalid URL: \(urlString)", "Network Error")
            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if URL is invalid
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                clSync("Couldn't fetch data: \(error)", "Network Error")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Ensure there is data returned
            guard let data = data else {
                clSync("No data returned", "Network Error")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Attempt to decode the data as JSON
            do {
                // Decode the JSON data (using the 'IPData' struct)
                let decoded = try JSONDecoder().decode(IPData.self, from: data)
                
                // Prepare columns and values dictionary
                var columnsAndValues: [String: Any?] = [
                    "ip_address": decoded.ip,
                    "is_eu": decoded.isEu,
                    "country": decoded.countryName,
                    "country_code": decoded.countryCode,
                    "continent": decoded.continentName,
                    "latitude": decoded.latitude,
                    "longitude": decoded.longitude,
                    "calling_code": decoded.callingCode,
                    "flag_svg_url": decoded.flag,
                    "flag_emoji": decoded.emojiFlag,
                    "asn_asn": decoded.asn.asn,
                    "asn_name": decoded.asn.name,
                    "asn_route": decoded.asn.route,
                    "asn_type": decoded.asn.type,
                    "currency_name": decoded.currency.name,
                    "currency_code": decoded.currency.code,
                    "currency_symbol": decoded.currency.symbol,
                    "currency_native": decoded.currency.native,
                    "timezone_name": decoded.timeZone.name,
                    "timezone_offset": decoded.timeZone.offset,
                    "timezone_current_time": decoded.timeZone.currentTime,
                    "is_threat": decoded.threat.isThreat,
                    "doe": doe,
                    "toe": toe,
                    "website": "https://api.ipdata.co/",
                    "api_key": ipDataCoAccessToken2,
                    "syncstatus": randomstr
                ]
                
                // Handle languages
                var languageNames = [String]()
                var languageCodes = [String]()
                var languageNatives = [String]()
                decoded.languages.forEach { language in
                    languageNames.append(language.name)
                    languageCodes.append(language.code)
                    languageNatives.append(language.native)
                }
                columnsAndValues["languages_name"] = languageNames.joined(separator: ", ")
                columnsAndValues["languages_code"] = languageCodes.joined(separator: ", ")
                columnsAndValues["languages_native"] = languageNatives.joined(separator: ", ")
                
                // Filter out the nil values
                columnsAndValues = columnsAndValues.filter { $0.value != nil }
                
                // Convert values to SQL-friendly format
                let columns = columnsAndValues.keys.joined(separator: ", ")
                let values = columnsAndValues.values.map { value -> String in
                    if let boolValue = value as? Bool {
                        return boolValue ? "1" : "0"
                    } else if let stringValue = value as? String {
                        return "'\(stringValue)'"
                    } else if let intValue = value as? Int {
                        return "\(intValue)"
                    } else if let doubleValue = value as? Double {
                        return "\(doubleValue)"
                    } else {
                        return "NULL"
                    }
                }.joined(separator: ", ")
                
                // Construct the SQL INSERT query
                let insertQuery = "INSERT INTO ipdata (\(columns)) VALUES (\(values))"
                let selectQuery = self.generateSelectQuery(from: columnsAndValues, tableName: "ipdata")
                
                if let result = self.read(selectQuery){
                    clSync(result,type:"updateAddressFromipDataCoAccessToken2 ==> Data already available")
                }
                else{
                    // Execute the SQL query
                    let (success, _) = self.executeQuery(insertQuery)
                    let instinct = deviceDetails.executeQuery("SELECT counti FROM ipdata WHERE syncstatus='\(randomstr)';")
                    let counti = deviceDetails.segregateAndPrintCounti(instinct)
                    if success {
                        self.sync_query(query: insertQuery, table: "ipdata", countifromtable: counti)
                        clSync(insertQuery)
                        clSync("Data inserted successfully")
                    } else {
                        clSync("Failed to insert data")
                        deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if query execution fails
                    }
                    
                } }catch {
                clSync("Couldn't decode JSON: \(error)", "API Error")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
            }
        }
        
        // Start the task
        task.resume()
    }

    
    func updateAddressFromabstractAPIIPGeolocationAPIAccessToken1() {
        let randomstr = random(length: 5)
        // Your Abstract API IP Geolocation API access token - Shahina's Token
        let accessToken = abstractAPIIPGeolocationAPIAccessToken1
        
        // The Abstract API IP Geolocation API URL
        let urlString = "\(abstractAPIIPGeolocationAPI)?api_key=\(accessToken)"
        clSync("\(urlString)")
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            clSync("Invalid URL: \(urlString)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromabstractAPIIPGeolocationAPIAccessToken1")
            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if URL is invalid
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromabstractAPIIPGeolocationAPIAccessToken1")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Ensure there is data returned
            guard let data = data else {
                clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromabstractAPIIPGeolocationAPIAccessToken1")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Attempt to decode the data as JSON
            do {
                // Decode the JSON data (using a struct named 'abstractAPIResponse' below)
                let decodedData = try JSONDecoder().decode(abstractAPIResponse.self, from: data)
                
                // Prepare columns and values dictionary
                var columnsAndValues: [String: Any?] = [
                    "ip_address": decodedData.ip_address,
                    "city": decodedData.city,
                    "city_geoname_id": decodedData.city_geoname_id,
                    "region": decodedData.region,
                    "region_iso_code": decodedData.region_iso_code,
                    "region_geoname_id": decodedData.region_geoname_id,
                    "postal_code": decodedData.postal_code,
                    "country": decodedData.country,
                    "country_code": decodedData.country_code,
                    "country_geoname_id": decodedData.country_geoname_id,
                    "country_is_eu": decodedData.country_is_eu,
                    "continent": decodedData.continent,
                    "continent_code": decodedData.continent_code,
                    "continent_geoname_id": decodedData.continent_geoname_id,
                    "longitude": decodedData.longitude,
                    "latitude": decodedData.latitude,
                    "is_vpn": decodedData.security.is_vpn,
                    "timezone_name": decodedData.timezone.name,
                    "timezone_abbreviation": decodedData.timezone.abbreviation,
                    "timezone_gmt_offset": decodedData.timezone.gmt_offset,
                    "timezone_current_time": decodedData.timezone.current_time,
                    "timezone_is_dst": decodedData.timezone.is_dst,
                    "flag_emoji": decodedData.flag.emoji,
                    "flag_unicode": decodedData.flag.unicode,
                    "flag_png_url": decodedData.flag.png,
                    "flag_svg_url": decodedData.flag.svg,
                    "currency_name": decodedData.currency.currency_name,
                    "currency_code": decodedData.currency.currency_code,
                    "connection_autonomous_system_number": decodedData.connection.autonomous_system_number,
                    "connection_autonomous_system_organization": decodedData.connection.autonomous_system_organization,
                    "connection_type": decodedData.connection.connection_type,
                    "connection_isp_name": decodedData.connection.isp_name,
                    "connection_organization_name": decodedData.connection.organization_name,
                    "doe": doe,
                    "toe": toe,
                    "website": abstractAPIIPGeolocationAPI,
                    "api_key": accessToken,
                    "syncstatus": randomstr
                ]
                
                // Filter out the nil values
                columnsAndValues = columnsAndValues.filter { $0.value != nil }
                
                // Convert values to SQL-friendly format
                let columns = columnsAndValues.keys.joined(separator: ", ")
                let values = columnsAndValues.values.map { value -> String in
                    if let boolValue = value as? Bool {
                        return boolValue ? "1" : "0"
                    } else if let stringValue = value as? String {
                        return "'\(stringValue)'"
                    } else if let intValue = value as? Int {
                        return "\(intValue)"
                    } else if let doubleValue = value as? Double {
                        return "\(doubleValue)"
                    } else {
                        return "NULL"
                    }
                }.joined(separator: ", ")
                
                // Construct the SQL INSERT query
                let insertQuery = "INSERT INTO ipdata (\(columns)) VALUES (\(values))"
                let selectQuery = self.generateSelectQuery(from: columnsAndValues, tableName: "ipdata")
                
                if let result = self.read(selectQuery){
                    clSync(result,type:"updateAddressFromabstractAPIIPGeolocationAPIAccessToken1 ==> Data already available")
                }
                else{
                    // Execute the SQL query
                    let (success, _) = self.executeQuery(insertQuery)
                    let instinct = deviceDetails.executeQuery("SELECT counti FROM ipdata WHERE syncstatus='\(randomstr)';")
                    let counti = deviceDetails.segregateAndPrintCounti(instinct)
                    if success {
                        self.sync_query(query: insertQuery, table: "ipdata", countifromtable: counti)
                        clSync(insertQuery)
                        clSync("Data inserted successfully")
                    } else {
                        clSync("Failed to insert data")
                        deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if query execution fails
                    }
                    
                } }catch {
                clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromabstractAPIIPGeolocationAPIAccessToken1")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
            }
        }
        
        // Start the task
        task.resume()
    }

    
    func updateAddressFromabstractAPIIPGeolocationAPIAccessToken2() {
        let randomstr = random(length: 5)
        // Your Abstract API IP Geolocation API access token
        let accessToken = abstractAPIIPGeolocationAPIAccessToken2
        
        // The Abstract API IP Geolocation API URL
        let urlString = "\(abstractAPIIPGeolocationAPI)?api_key=\(accessToken)"
        clSync("\(urlString)")
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            clSync("Invalid URL: \(urlString)")
            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if URL is invalid
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                clSync("Couldn't fetch data: \(error)", "Network Error")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Ensure there is data returned
            guard let data = data else {
                clSync("No data returned", "Network Error")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                return
            }
            
            // Attempt to decode the data as JSON
            do {
                // Decode the JSON data (using a struct named 'abstractAPIResponse' below)
                let decodedData = try JSONDecoder().decode(abstractAPIResponse.self, from: data)
                
                // Prepare columns and values dictionary
                var columnsAndValues: [String: Any?] = [
                    "ip_address": decodedData.ip_address,
                    "city": decodedData.city,
                    "city_geoname_id": decodedData.city_geoname_id,
                    "region": decodedData.region,
                    "region_iso_code": decodedData.region_iso_code,
                    "region_geoname_id": decodedData.region_geoname_id,
                    "postal_code": decodedData.postal_code,
                    "country": decodedData.country,
                    "country_code": decodedData.country_code,
                    "country_geoname_id": decodedData.country_geoname_id,
                    "country_is_eu": decodedData.country_is_eu,
                    "continent": decodedData.continent,
                    "continent_code": decodedData.continent_code,
                    "continent_geoname_id": decodedData.continent_geoname_id,
                    "longitude": decodedData.longitude,
                    "latitude": decodedData.latitude,
                    "is_vpn": decodedData.security.is_vpn,
                    "timezone_name": decodedData.timezone.name,
                    "timezone_abbreviation": decodedData.timezone.abbreviation,
                    "timezone_gmt_offset": decodedData.timezone.gmt_offset,
                    "timezone_current_time": decodedData.timezone.current_time,
                    "timezone_is_dst": decodedData.timezone.is_dst,
                    "flag_emoji": decodedData.flag.emoji,
                    "flag_unicode": decodedData.flag.unicode,
                    "flag_png_url": decodedData.flag.png,
                    "flag_svg_url": decodedData.flag.svg,
                    "currency_name": decodedData.currency.currency_name,
                    "currency_code": decodedData.currency.currency_code,
                    "connection_autonomous_system_number": decodedData.connection.autonomous_system_number,
                    "connection_autonomous_system_organization": decodedData.connection.autonomous_system_organization,
                    "connection_type": decodedData.connection.connection_type,
                    "connection_isp_name": decodedData.connection.isp_name,
                    "connection_organization_name": decodedData.connection.organization_name,
                    "doe": doe,
                    "toe": toe,
                    "website": abstractAPIIPGeolocationAPI,
                    "api_key": accessToken,
                    "syncstatus": randomstr
                ]
                
                // Filter out the nil values
                columnsAndValues = columnsAndValues.filter { $0.value != nil }
                
                // Convert values to SQL-friendly format
                let columns = columnsAndValues.keys.joined(separator: ", ")
                let values = columnsAndValues.values.map { value -> String in
                    if let boolValue = value as? Bool {
                        return boolValue ? "1" : "0"
                    } else if let stringValue = value as? String {
                        return "'\(stringValue)'"
                    } else if let intValue = value as? Int {
                        return "\(intValue)"
                    } else if let doubleValue = value as? Double {
                        return "\(doubleValue)"
                    } else {
                        return "NULL"
                    }
                }.joined(separator: ", ")
                
                // Construct the SQL INSERT query
                let insertQuery = "INSERT INTO ipdata (\(columns)) VALUES (\(values))"
                let selectQuery = self.generateSelectQuery(from: columnsAndValues, tableName: "ipdata")
                
                if let result = self.read(selectQuery){
                    clSync(result,type:"updateAddressFromabstractAPIIPGeolocationAPIAccessToken2 ==> Data already available")
                }
                else{
                    // Execute the SQL query
                    let (success, _) = self.executeQuery(insertQuery)
                    let instinct = deviceDetails.executeQuery("SELECT counti FROM ipdata WHERE syncstatus='\(randomstr)';")
                    let counti = deviceDetails.segregateAndPrintCounti(instinct)
                    if success {
                        self.sync_query(query: insertQuery, table: "ipdata", countifromtable: counti)
                        clSync(insertQuery)
                        clSync("Data inserted successfully")
                    } else {
                        clSync("Failed to insert data")
                        deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if query execution fails
                    }
                    
                } }catch {
                clSync("Couldn't decode JSON: \(error)", "API Error")
                deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
            }
        }
        
        // Start the task
        task.resume()
    }

    
    
    func updateAddressFromip2LocationAccessToken1() {
        let randomstr = random(length: 5)
        // Your IP2Location base URL and API Access Token
        let accessToken = ipLocation2APIAccessToken1
        
        // Construct the URL with the correct query parameter for the API key (`key` should be `api_key`)
        // And replace "YOUR_IP_ADDRESS_HERE" with the actual IP address you wish to query
        let urlString = "\(ip2Location)?key=\(accessToken)"
        
        clSync("\(urlString)")
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Check for errors
                if let error = error {
                    clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromip2LocationAccessToken1")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                    return
                }
                
                // Ensure there is data returned
                guard let data = data else {
                    clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromip2LocationAccessToken1")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                    return
                }
                
                // Attempt to decode the data as JSON
                do {
                    // Decode the JSON data
                    let decodedData = try JSONDecoder().decode(IPGeolocationData.self, from: data)
                    
                    // Prepare columns and values dictionary for ipdata table
                    var columnsAndValues: [String: Any?] = [
                        "ip_address": decodedData.ip,
                        "city": decodedData.city_name,
                        "region": decodedData.region_name,
                        "country": decodedData.country_name,
                        "latitude": decodedData.latitude,
                        "longitude": decodedData.longitude,
                        "zip_code": decodedData.zip_code ?? "zipCode",
                        "timezone_name": decodedData.time_zone,
                        "asn": decodedData.asn,
                        "is_proxy": decodedData.is_proxy,
                        "doe": doe,
                        "toe": toe,
                        "website": ip2Location,
                        "api_key": accessToken,
                        "syncstatus": randomstr
                    ]
                    
                    // Filter out the nil values
                    columnsAndValues = columnsAndValues.filter { $0.value != nil }
                    
                    // Convert values to SQL-friendly format
                    let columns = columnsAndValues.keys.joined(separator: ", ")
                    let values = columnsAndValues.values.map { value -> String in
                        if let boolValue = value as? Bool {
                            return boolValue ? "1" : "0"
                        } else if let stringValue = value as? String {
                            return "'\(stringValue)'"
                        } else if let doubleValue = value as? Double {
                            return "\(doubleValue)"
                        } else {
                            return "NULL"
                        }
                    }.joined(separator: ", ")
                    
                    // Construct the SQL INSERT query for ipdata table
                    let insertQuery = "INSERT INTO ipdata (\(columns)) VALUES (\(values))"
                    let selectQuery = self.generateSelectQuery(from: columnsAndValues, tableName: "ipdata")
                    
                    if let result = self.read(selectQuery){
                        clSync(result,type:"updateAddressFromip2LocationAccessToken1 ==> Data already available")
                    }
                    else{
                        // Execute the SQL query
                        let (success, _) = self.executeQuery(insertQuery)
                        let instinct = deviceDetails.executeQuery("SELECT counti FROM ipdata WHERE syncstatus='\(randomstr)';")
                        let counti = deviceDetails.segregateAndPrintCounti(instinct)
                        if success {
                            self.sync_query(query: insertQuery, table: "ipdata", countifromtable: counti)
                            clSync(insertQuery)
                            clSync("Data inserted successfully into ipdata table")
                        } else {
                            clSync("Failed to insert data into ipdata table")
                            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here in case of query failure
                        }
                        
                    } }catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromip2LocationAccessToken1")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                }
            }
            
            // Start the task
            task.resume()
        } else {
            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if URL is invalid
        }
    }

    
    func updateAddressFromip2LocationAccessToken2() {
        let randomstr = random(length: 5)
        // Your IP2Location base URL and API Access Token
        let accessToken = ipLocation2APIAccessToken2
        
        // Construct the URL with the correct query parameter for the API key (`key` should be `api_key`)
        // And replace "YOUR_IP_ADDRESS_HERE" with the actual IP address you wish to query
        let urlString = "\(ip2Location)?key=\(accessToken)"
        
        clSync("\(urlString)")
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Check for errors
                if let error = error {
                    clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromip2LocationAccessToken2")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                    return
                }
                
                // Ensure there is data returned
                guard let data = data else {
                    clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromip2LocationAccessToken2")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                    return
                }
                
                // Attempt to decode the data as JSON
                do {
                    // Decode the JSON data
                    let decodedData = try JSONDecoder().decode(IPGeolocationData.self, from: data)
                    
                    // Prepare columns and values dictionary for ipdata table
                    var columnsAndValues: [String: Any?] = [
                        "ip_address": decodedData.ip,
                        "city": decodedData.city_name,
                        "region": decodedData.region_name,
                        "country": decodedData.country_name,
                        "latitude": decodedData.latitude,
                        "longitude": decodedData.longitude,
                        "zip_code": decodedData.zip_code ?? "zipCode",
                        "timezone_name": decodedData.time_zone,
                        "asn": decodedData.asn,
                        "is_proxy": decodedData.is_proxy,
                        "doe": doe,
                        "toe": toe,
                        "website": ip2Location,
                        "api_key": accessToken,
                        "syncstatus": randomstr
                    ]
                    
                    // Filter out the nil values
                    columnsAndValues = columnsAndValues.filter { $0.value != nil }
                    
                    // Convert values to SQL-friendly format
                    let columns = columnsAndValues.keys.joined(separator: ", ")
                    let values = columnsAndValues.values.map { value -> String in
                        if let boolValue = value as? Bool {
                            return boolValue ? "1" : "0"
                        } else if let stringValue = value as? String {
                            return "'\(stringValue)'"
                        } else if let doubleValue = value as? Double {
                            return "\(doubleValue)"
                        } else {
                            return "NULL"
                        }
                    }.joined(separator: ", ")
                    
                    // Construct the SQL INSERT query for ipdata table
                    let insertQuery = "INSERT INTO ipdata (\(columns)) VALUES (\(values))"
                    let selectQuery = self.generateSelectQuery(from: columnsAndValues, tableName: "ipdata")
                    
                    if let result = self.read(selectQuery){
                        clSync(result,type:"updateAddressFromip2LocationAccessToken2 ==> Data already available")
                    }
                    else{
                        // Execute the SQL query
                        let (success, _) = self.executeQuery(insertQuery)
                        let instinct = deviceDetails.executeQuery("SELECT counti FROM ipdata WHERE syncstatus='\(randomstr)';")
                        let counti = deviceDetails.segregateAndPrintCounti(instinct)
                        if success {
                            self.sync_query(query: insertQuery, table: "ipdata", countifromtable: counti)
                            clSync(insertQuery)
                            clSync("Data inserted successfully into ipdata table")
                        } else {
                            clSync("Failed to insert data into ipdata table")
                            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here in case of query failure
                        }
                        
                    } }catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromip2LocationAccessToken2")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                }
            }
            
            // Start the task
            task.resume()
        } else {
            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if URL is invalid
        }
    }


    
    func updateAddressFromipfyorgToken1() {
        let randomstr = random(length: 5)
        // Your IPFY.org base URL and API Access Token
        let accessToken = ipfyorgAccessToken1
        
        // Construct the URL with the correct query parameter for the API key (`apiKey` should be `at_`)
        let urlString = "\(ipfyorg1)?apiKey=at_\(accessToken)"
        
        clSync("\(urlString)")
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Check for errors
                if let error = error {
                    clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipfyorgToken1")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                    return
                }
                
                // Ensure there is data returned
                guard let data = data else {
                    clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipfyorgToken1")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                    return
                }
                
                // Attempt to decode the JSON data
                do {
                    // Decode the JSON data
                    let decodedData = try JSONDecoder().decode(DataIPfyorg.self, from: data)
                    
                    // Prepare columns and values dictionary for ipdata table
                    var columnsAndValues: [String: Any?] = [
                        "ip_address": decodedData.ip ?? "ip",
                        "region": decodedData.location?.region,
                        "country": decodedData.location?.country,
                        "timezone_name": decodedData.location?.timezone,
                        "asn": decodedData.as?.asn,
                        "connection_isp_name": decodedData.isp ?? "isp",
                        "doe": doe,
                        "toe": toe,
                        "website": ipfyorg1,
                        "api_key": accessToken,
                        "syncstatus": randomstr
                    ]
                    
                    // Filter out the nil values
                    columnsAndValues = columnsAndValues.filter { $0.value != nil }
                    
                    // Convert values to SQL-friendly format
                    let columns = columnsAndValues.keys.joined(separator: ", ")
                    let values = columnsAndValues.values.map { value -> String in
                        if let boolValue = value as? Bool {
                            return boolValue ? "1" : "0"
                        } else if let stringValue = value as? String {
                            return "'\(stringValue)'"
                        } else if let doubleValue = value as? Double {
                            return "\(doubleValue)"
                        } else {
                            return "NULL"
                        }
                    }.joined(separator: ", ")
                    
                    // Construct the SQL INSERT query for ipdata table
                    let insertQuery = "INSERT INTO ipdata (\(columns)) VALUES (\(values))"
                    let selectQuery = self.generateSelectQuery(from: columnsAndValues, tableName: "ipdata")
                    
                    if let result = self.read(selectQuery){
                        clSync(result,type:"updateAddressFromipfyorgToken1 ==> Data already available")
                    }
                    else{
                        // Execute the SQL query
                        let (success, _) = self.executeQuery(insertQuery)
                        let instinct = deviceDetails.executeQuery("SELECT counti FROM ipdata WHERE syncstatus='\(randomstr)';")
                        let counti = deviceDetails.segregateAndPrintCounti(instinct)
                        if success {
                            self.sync_query(query: insertQuery, table: "ipdata", countifromtable: counti)
                            clSync(insertQuery)
                            clSync("Data inserted successfully into ipdata table")
                        } else {
                            clSync("Failed to insert data into ipdata table")
                            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here in case of query failure
                        }
                        
                    } }catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromipfyorgToken1")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                }
            }
            
            // Start the task
            task.resume()
        } else {
            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if URL is invalid
        }
    }

    
    func updateAddressFromipfyorgToken2() {
        let randomstr = random(length: 5)
        // Your IPFY.org base URL and API Access Token
        let accessToken = ipfyorgAccessToken2
        
        // Construct the URL with the correct query parameter for the API key (`apiKey` should be `at_`)
        let urlString = "\(ipfyorg1)?apiKey=at_\(accessToken)"
        
        clSync("\(urlString)")
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Check for errors
                if let error = error {
                    clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipfyorgToken2")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                    return
                }
                
                // Ensure there is data returned
                guard let data = data else {
                    clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipfyorgToken2")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                    return
                }
                
                // Attempt to decode the JSON data
                do {
                    // Decode the JSON data
                    let decodedData = try JSONDecoder().decode(DataIPfyorg.self, from: data)
                    
                    // Prepare columns and values dictionary for ipdata table
                    var columnsAndValues: [String: Any?] = [
                        "ip_address": decodedData.ip ?? "ip",
                        "region": decodedData.location?.region,
                        "country": decodedData.location?.country,
                        "timezone_name": decodedData.location?.timezone,
                        "asn": decodedData.as?.asn,
                        "connection_isp_name": decodedData.isp ?? "isp",
                        "doe": doe,
                        "toe": toe,
                        "website": ipfyorg1,
                        "api_key": accessToken,
                        "syncstatus": randomstr
                    ]
                    
                    // Filter out the nil values
                    columnsAndValues = columnsAndValues.filter { $0.value != nil }
                    
                    // Convert values to SQL-friendly format
                    let columns = columnsAndValues.keys.joined(separator: ", ")
                    let values = columnsAndValues.values.map { value -> String in
                        if let boolValue = value as? Bool {
                            return boolValue ? "1" : "0"
                        } else if let stringValue = value as? String {
                            return "'\(stringValue)'"
                        } else if let doubleValue = value as? Double {
                            return "\(doubleValue)"
                        } else {
                            return "NULL"
                        }
                    }.joined(separator: ", ")
                    
                    // Construct the SQL INSERT query for ipdata table
                    let insertQuery = "INSERT INTO ipdata (\(columns)) VALUES (\(values))"
                    let selectQuery = self.generateSelectQuery(from: columnsAndValues, tableName: "ipdata")
                    
                    if let result = self.read(selectQuery){
                        clSync(result,type:"updateAddressFromipfyorgToken2 ==> Data already available")
                    }
                    else{
                        // Execute the SQL query
                        let (success, _) = self.executeQuery(insertQuery)
                        let instinct = deviceDetails.executeQuery("SELECT counti FROM ipdata WHERE syncstatus='\(randomstr)';")
                        let counti = deviceDetails.segregateAndPrintCounti(instinct)
                        if success {
                            self.sync_query(query: insertQuery, table: "ipdata", countifromtable: counti)
                            clSync(insertQuery)
                            clSync("Data inserted successfully into ipdata table")
                        } else {
                            clSync("Failed to insert data into ipdata table")
                            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here in case of query failure
                        }
                        
                    } }catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromipfyorgToken2")
                    deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here
                }
            }
            
            // Start the task
            task.resume()
        } else {
            deviceDetails.executeRandomNetworkAPIFunction(condition: "false") // Call the function here if URL is invalid
        }
    }

    
    
    func executeRandomNetworkAPIFunction(condition: String) {
        // Array of function references
        let functions: [() -> Void] = [
            updateAddressFromipinfoIoAPIToken1,
            updateAddressFromipinfoIoAPIToken2,
            updateAddressFromipDataCoAccessToken1,
            updateAddressFromipDataCoAccessToken2,
            updateAddressFromabstractAPIIPGeolocationAPIAccessToken1,
            updateAddressFromabstractAPIIPGeolocationAPIAccessToken2,
            updateAddressFromip2LocationAccessToken1,
            updateAddressFromip2LocationAccessToken2,
            updateAddressFromipfyorgToken1,
            updateAddressFromipfyorgToken2
        ]
        
        // Shuffle the array
        let shuffledFunctions = functions.shuffled()
        
        // Execute the first function only if the condition is not "false"
        if condition.lowercased() == "false" {
            shuffledFunctions.first?()
        }
    }
    
    
    func generateSelectQuery(from insertColumnsAndValues: [String: Any?], tableName: String) -> String {
        // Specify the keys to exclude
        let excludedKeys: Set<String> = ["doe", "toe", "syncstatus"]
        
        // Filter out nil values and excluded keys
        let filteredColumnsAndValues = insertColumnsAndValues.filter {
            $0.value != nil && !excludedKeys.contains($0.key)
        }
        
        // Map the key-value pairs into WHERE conditions
        let conditions = filteredColumnsAndValues.map { column, value -> String in
            if let boolValue = value as? Bool {
                return "\"\(column)\" = \(boolValue ? "1" : "0")"
            } else if let stringValue = value as? String {
                return "\"\(column)\" = '\(stringValue)'"
            } else if let intValue = value as? Int {
                return "\"\(column)\" = \(intValue)"
            } else if let doubleValue = value as? Double {
                return "\"\(column)\" = \(doubleValue)"
            } else {
                return "\"\(column)\" IS NULL"
            }
        }.joined(separator: " AND ")
        
        // Construct the SELECT query
        let selectQuery = "SELECT * FROM \(tableName) WHERE \(conditions);"
        
        return selectQuery
    }
    

    
    func distinctInsert(_ tableName: String, _ kvp: [String:String])-> (counti:Int,success:Bool,newlyinserted:Bool){
        let query = generateSelectQueryusingkvp(tableName: tableName, kvp: kvp)
        if let result = sql.read(query) {
            print("Data: \(result)")
            return(1,true,false)
        } else {
            let insertQuery = generateInsertQuery(tableName: tableName, data: kvp)
            executeQuery(insertQuery)
            return(1,true,true)
        }
    }
    
    func generateSelectQueryusingkvp(tableName: String, kvp: [String: Any]) -> String {
        var conditions: [String] = []
        
        for (key, value) in kvp {
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
    
    
    func sync_query(query: String, table: String, countifromtable: Int) {
        clSync(query)
        do {
            let ins_query = query.replacingOccurrences(of: "'", with: "''")
            let imeihash = Device.getUniqueID()
            let doe = dbClock.getDateforDB() // Assuming getDateforDB() returns a DATE string
            let toe = dbClock.getTimeforDB() // Assuming getTimeforDB() returns a TIME string
            let syncstatus = "synced" // Assuming a static value; adjust as needed
            
            // Building the insert query
            let insertQuery = """
            INSERT INTO querysync (
                `query`,
                `mac`,
                `tablename`,
                `countifromtable`,
                `doe`,
                `toe`,
                `syncstatus`
            ) VALUES (
                '\(ins_query)',
                '\(imeihash)',
                '\(table)',
                '\(countifromtable)',
                '\(doe)',
                '\(toe)',
                '\(syncstatus)'
            )
            """
            
            // Executing the insert query
            let (success, _) = executeQuery(insertQuery)
            if success {
                clSync("Data inserted successfully", type: "si")
            } else {
                clSync("Failed to insert data", type: "si")
            }
        } catch {
            clSync("Error: \(error)", type: "si")
        }
    }
    
    
}




