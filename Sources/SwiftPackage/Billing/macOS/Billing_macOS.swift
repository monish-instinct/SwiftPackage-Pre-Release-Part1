//
//  Billing_iPhone.swift
//  RD Vivaha Jewellers
//
//  Created by Raghul S on 31/12/23.
//

#if os(visionOS) || os(macOS)

import SwiftUI
//import RaghulsNeuralEngine
struct Billing: View {
    @State private var name: String = ""
    @State private var email: String = ""

    var sql = Sqlize()
    var body: some View {
        VStack {
            TextField("Date",text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Time", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
            Button("Insert 25 / 123") {
                _ = sql.insert(gold_finalized_bills_after_payment_t2,[t2.advance_amt:"25",t2.billid:"123"])

            }
            .padding()
            
            Button("Check SystemInfo") {
                for _ in 0...5{
                    cl("a")
                }
                cl("Hello from Skynet ")
                cl("b")
                cl()
                
                cl(User.getDB(),type:"si")
                cl(User.getName(),type:"si")
                cl(User.getQueue(),type:"si")
                cl(User.getOwnComCode(),type:"si")
                
                cl(Device.getModelName(),type:"si")
                cl(Device.getUniqueID(),type:"si")
                cl(Device.getUserName(),type:"si")
                cl(Device.getOSName(),type:"si")
                cl(Device.getOSVersion(),type:"si")
                cl(Device.getStorageSize(),type:"si")
                cl(Device.getFreeSpace(),type:"si")
                cl(Device.getUsedSpace(),type:"si")
                
                #if os(macOS)
                cl(Device.getScreenWidth(),type:"si")
                cl(Device.getScreenHeight(),type:"si")
                #endif
                
                cl(Network.getIPv4(),type:"si")
                cl(Network.getIPv6(),type:"si")
                cl(Network.getIP(),type:"si")
                cl(Network.getLocation(),type:"si")
                cl(Network.getISP(),type:"si")
                cl(Network.publicIPbasedDetils_ipinfoIoAPIToken,type:"si")
                
                cl(GPS.getLatitude(),type:"si")
                cl(GPS.getLongitude(),type:"si")
                cl(GPS.getAltitude(),type:"si")
                cl(GPS.getAddress(),type:"si")
                cl(GPS.getLocationPermissionStatus(),type:"si")
                cl(GPS.getAccuracy(),type:"si")
                
                cl(dbClock.getDate(),type:"si")
                cl(dbClock.getTime(),type:"si")
                cl(dbClock.minDate,type:"si")
                cl(dbClock.minTime,type:"si")
            }
            .padding()
                
            Button("Read and Print") {
                while let data = sql.read(tracker: 1, query: "select "+t2.billid+" from "+gold_finalized_bills_after_payment_t2){
                    cl(data,type:"checkrp")
                }
                //sql.write(tracker: 2, query: "INSERT INTO Users (Name, Email) VALUES ('\(name)', '\(email)');")
                //sql.debug(tracker: 2)
            }
            .padding()
            
            
            Button("Get Hash"){
                print(Security.getDeviceSpecificSecretHash())
                print(ServerSecurity.getServerSpecificSecretHash())
            }
            .padding()
            
            Button("Generate Hash"){
//                print(sha256Hash(for: "1"))
                cl(Network.getIPv4(),type:"si")
                cl(Network.getIPv6(),type:"si")
                cl(Network.getIP(),type:"si")

            }
            .padding()
            
            Button("DevOps Sync"){
//                print(Device.getUniqueID())
//                print(deviceDetails.executeQuery("SELECT query,tablename,countifromtable FROM querysync"))
//                deviceDetails.executeRandom3NetworkAPIFunctions()
                
                let cllog: (Bool, Any?) = logWallet.executeQuery("SELECT query, tablename, countifromtable, counti FROM querysync;")
                print(SecurityBreachLoggers.segregateAndPrintQueries(cllog))
                
                let clsynclog: (Bool, Any?) = logSyncWallet.executeQuery("SELECT query, tablename, countifromtable, counti FROM querysync;")
                print(SecurityBreachClLoggers.segregateAndPrintQueries(clsynclog))
               
            }
            .padding()
        
            Button("DeviceInfo Sync"){
//                print(deviceDetails.executeQuery("SELECT query,tablename,countifromtable,counti FROM querysync"))
                let ipdata: (Bool, Any?) = deviceDetails.executeQuery("SELECT query, tablename, countifromtable, counti FROM querysync WHERE tablename = 'ipdata';")
                print(IPDataInfoSync.segregateAndPrintQueries(ipdata))
                
                let ipaddresses: (Bool, Any?) = deviceDetails.executeQuery("SELECT query, tablename, countifromtable, counti FROM querysync WHERE tablename = 'ipaddresses';")
                print(IPAddressesInfoSync.segregateAndPrintQueries(ipaddresses))

            }
            Button("Neural Memory Test"){
                sql.insert("logs_from_devops", ["filename" : "insert"])
                                sql.update(tableName: "logs_from_devops", setters: "filename = 'update'", whereCondition: "area = 'test'")
                                sql.end("logs_from_devops", "area = 'test'")
                                sql.delete("logs_from_devops", "area = 'test'")
            }
            
            Button("Database Check"){
//                upSyncBook.executeQuery("UPDATE mastersyncrecords SET doe='2024-03-13', toe='02:28:14' WHERE doe='NULL' AND toe='NULL'")
//                print("UPDATE mastersyncrecords SET doe='2024-03-13', toe='02:28:14' WHERE doe='NULL' AND toe='NULL'")
//                upSyncBook.insert(queryType: "insert", kvp: ["insert" : "insert"], tableName: "insert", countis: "insert", query: "insert")
                
                let database: (Bool, Any?) = upSyncBook.executeQuery("SELECT query, querytype, tablename, countifromtable, counti FROM mastersyncrecords WHERE tablename = 'logs_from_devops' ORDER BY counti ASC;")
                print(DatabaseUpSync.segregateAndPrintQueries(database))
            }
            
            Button("Check phpRelicas"){
                cl(Network.getIP(),type:"si")
                print("aabb".replacingOccurrences(of: "a", with: "b"))
                
            }
        }
    }
}


#endif










