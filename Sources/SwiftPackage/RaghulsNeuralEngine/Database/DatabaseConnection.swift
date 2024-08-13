//
//  CipherDatabase.swift
//  Database
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 01/01/24.
//

import Foundation

#if canImport(SQLCipher)
import SQLCipher

class DatabaseConnectionEstablisher {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file

    init() {
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("NeuralMemory.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("NeuralMemory.sqlite3")
            path = fileURL.path
            #endif


            if sqlite3_open(path, &db) != SQLITE_OK {
                print("Unable to open database : NeuralMemory")
                return
            }

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                print("Unable to set key for database : NeuralMemory")
                sqlite3_close(db)
                return
            }

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    public func restart(){
        sqlite3_close(db)
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("NeuralMemory.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("NeuralMemory.sqlite3")
            path = fileURL.path
            #endif


            if sqlite3_open(path, &db) != SQLITE_OK {
                print("Unable to re-open database : NeuralMemory")
                return
            }

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                print("Unable to re-set key for database : NeuralMemory")
                sqlite3_close(db)
                return
            }

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var result = sqlite3_step(statement)
            if result == SQLITE_ROW {
                // Handle SELECT queries
                var rows = [[String: String]]()
                repeat {
                    var row = [String: String]()
                    for i in 0..<sqlite3_column_count(statement) {
                        if let columnName = sqlite3_column_name(statement, i) {
                            let name = String(cString: columnName)
                            if let columnText = sqlite3_column_text(statement, i) {
                                let value = String(cString: columnText)
                                row[name] = value
                            }
                        }
                    }
                    rows.append(row)
                    result = sqlite3_step(statement)
                } while result == SQLITE_ROW
                sqlite3_finalize(statement)
                return (true, rows)
            } else if result == SQLITE_DONE {
                // Handle non-SELECT queries (INSERT, UPDATE, DELETE)
                sqlite3_finalize(statement)
                return (true, nil)
            } else {
                // If result is not SQLITE_ROW or SQLITE_DONE, it's an error
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Failure @ SQL: \(errmsg) Query : \(query)")
                sqlite3_finalize(statement)
                return (false, nil)
            }
        } else {
            // Handle SQL preparation error
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Failure @ SQL: \(errmsg) Query : \(query)")
            sqlite3_finalize(statement)
            return (false, nil)
        }
    }

}

class DevOpsDatabaseConnectionEstablisher {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file

    init() {
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("DevOps.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("DevOps.sqlite3")
            path = fileURL.path
            #endif



            if sqlite3_open(path, &db) != SQLITE_OK {
                let errorMsg = String(cString: sqlite3_errmsg(db))
                print("Unable to open database : DevOps. Error: \(errorMsg)")
                return
            }

            // Enable extended result codes
            sqlite3_extended_result_codes(db, 1);

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                let errorMsg = String(cString: sqlite3_errmsg(db))
                print("Unable to set key for database : DevOps. Detailed Error: \(errorMsg)")
                sqlite3_close(db)
                return
            }

            // Additional diagnostic prints can be placed here to verify the state and results of operations

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    public func restart(){
        sqlite3_close(db)
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("DevOps.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("DevOps.sqlite3")
            path = fileURL.path
            #endif


            if sqlite3_open(path, &db) != SQLITE_OK {
                print("Unable to re-open database : DevOpes")
                return
            }

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                print("Unable to re-set key for database : DevOps")
                sqlite3_close(db)
                return
            }

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
        // Ensure the database is initialized
        if db == nil {
            print("Database not initialized")
            return (false, nil)
        }
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var result = sqlite3_step(statement)
            if result == SQLITE_ROW {
                // Handle SELECT queries
                var rows = [[String: String]]()
                repeat {
                    var row = [String: String]()
                    for i in 0..<sqlite3_column_count(statement) {
                        if let columnName = sqlite3_column_name(statement, i) {
                            let name = String(cString: columnName)
                            if let columnText = sqlite3_column_text(statement, i) {
                                let value = String(cString: columnText)
                                row[name] = value
                            }
                        }
                    }
                    rows.append(row)
                    result = sqlite3_step(statement)
                } while result == SQLITE_ROW
                sqlite3_finalize(statement)
                return (true, rows)
            } else if result == SQLITE_DONE {
                // Handle non-SELECT queries (INSERT, UPDATE, DELETE)
                sqlite3_finalize(statement)
                return (true, nil)
            } else {
                // If result is not SQLITE_ROW or SQLITE_DONE, it's an error
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Failure @ SQL: \(errmsg) Query : \(query)")
                sqlite3_finalize(statement)
                return (false, nil)
            }
        } else {
            // Handle SQL preparation error
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Failure @ SQL: \(errmsg) Query : \(query)")
            sqlite3_finalize(statement)
            return (false, nil)
        }
    }
}

class DeviceInfoGraphics {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file

    init() {
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("DeviceFingerprints.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("DeviceFingerprints.sqlite3")
            path = fileURL.path
            #endif



            if sqlite3_open(path, &db) != SQLITE_OK {
                let errorMsg = String(cString: sqlite3_errmsg(db))
                print("Unable to open database : DeviceFingerprints Error: \(errorMsg)")
                return
            }

            // Enable extended result codes
            sqlite3_extended_result_codes(db, 1);

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                let errorMsg = String(cString: sqlite3_errmsg(db))
                print("Unable to set key for database : DeviceFingerprints Detailed Error: \(errorMsg)")
                sqlite3_close(db)
                return
            }

            // Additional diagnostic prints can be placed here to verify the state and results of operations

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    public func restart(){
        sqlite3_close(db)
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("DeviceFingerprints.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("DeviceFingerprints.sqlite3")
            path = fileURL.path
            #endif


            if sqlite3_open(path, &db) != SQLITE_OK {
                print("Unable to re-open database : DeviceFingerprints")
                return
            }

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                print("Unable to re-set key for database : DeviceFingerprints")
                sqlite3_close(db)
                return
            }

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
        // Ensure the database is initialized
        if db == nil {
            clSync("Database not initialized")
            return (false, nil)
        }
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var result = sqlite3_step(statement)
            if result == SQLITE_ROW {
                // Handle SELECT queries
                var rows = [[String: String]]()
                repeat {
                    var row = [String: String]()
                    for i in 0..<sqlite3_column_count(statement) {
                        if let columnName = sqlite3_column_name(statement, i) {
                            let name = String(cString: columnName)
                            if let columnText = sqlite3_column_text(statement, i) {
                                let value = String(cString: columnText)
                                row[name] = value
                            }
                        }
                    }
                    rows.append(row)
                    result = sqlite3_step(statement)
                } while result == SQLITE_ROW
                sqlite3_finalize(statement)
                return (true, rows)
            } else if result == SQLITE_DONE {
                // Handle non-SELECT queries (INSERT, UPDATE, DELETE)
                sqlite3_finalize(statement)
                return (true, nil)
            } else {
                // If result is not SQLITE_ROW or SQLITE_DONE, it's an error
                let errmsg = String(cString: sqlite3_errmsg(db))
                clSync("Failure @ SQL: \(errmsg) Query : \(query)")
                sqlite3_finalize(statement)
                return (false, nil)
            }
        } else {
            // Handle SQL preparation error
            let errmsg = String(cString: sqlite3_errmsg(db))
            clSync("Failure @ SQL: \(errmsg) Query : \(query)")
            sqlite3_finalize(statement)
            return (false, nil)
        }
    }
}

class DevOpsSyncDatabaseConnectionEstablisher {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file

    init() {
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("DevOpsSync.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("DevOpsSync.sqlite3")
            path = fileURL.path
            #endif


            if sqlite3_open(path, &db) != SQLITE_OK {
                print("Unable to open database : DevOpsSync")
                return
            }

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                print("Unable to set key for database : DevOpsSync")
                sqlite3_close(db)
                return
            }

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    public func restart(){
        sqlite3_close(db)
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("DevOpsSync.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("DevOpsSync.sqlite3")
            path = fileURL.path
            #endif


            if sqlite3_open(path, &db) != SQLITE_OK {
                print("Unable to re-open database : DevOpsSync")
                return
            }

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                print("Unable to re-set key for database : DevOpsSync")
                sqlite3_close(db)
                return
            }

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
        // Ensure the database is initialized
        if db == nil {
            print("Database not initialized")
            return (false, nil)
        }
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var result = sqlite3_step(statement)
            if result == SQLITE_ROW {
                // Handle SELECT queries
                var rows = [[String: String]]()
                repeat {
                    var row = [String: String]()
                    for i in 0..<sqlite3_column_count(statement) {
                        if let columnName = sqlite3_column_name(statement, i) {
                            let name = String(cString: columnName)
                            if let columnText = sqlite3_column_text(statement, i) {
                                let value = String(cString: columnText)
                                row[name] = value
                            }
                        }
                    }
                    rows.append(row)
                    result = sqlite3_step(statement)
                } while result == SQLITE_ROW
                sqlite3_finalize(statement)
                return (true, rows)
            } else if result == SQLITE_DONE {
                // Handle non-SELECT queries (INSERT, UPDATE, DELETE)
                sqlite3_finalize(statement)
                return (true, nil)
            } else {
                // If result is not SQLITE_ROW or SQLITE_DONE, it's an error
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Failure @ SQL: \(errmsg) Query : \(query)")
                sqlite3_finalize(statement)
                return (false, nil)
            }
        } else {
            // Handle SQL preparation error
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Failure @ SQL: \(errmsg) Query : \(query)")
            sqlite3_finalize(statement)
            return (false, nil)
        }
    }
}


class UpSyncDatabaseConnectionEstablisher {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file

    init() {
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("Synchronize.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("Synchronize.sqlite3")
            path = fileURL.path
            #endif


            if sqlite3_open(path, &db) != SQLITE_OK {
                print("Unable to open database : Synchronize")
                return
            }

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                print("Unable to set key for database : Synchronize")
                sqlite3_close(db)
                return
            }

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    public func restart(){
        sqlite3_close(db)
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("Synchronize.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("Synchronize.sqlite3")
            path = fileURL.path
            #endif


            if sqlite3_open(path, &db) != SQLITE_OK {
                print("Unable to re-open database : Synchronize")
                return
            }

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                print("Unable to re-set key for database : Synchronize")
                sqlite3_close(db)
                return
            }

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var result = sqlite3_step(statement)
            if result == SQLITE_ROW {
                // Handle SELECT queries
                var rows = [[String: String]]()
                repeat {
                    var row = [String: String]()
                    for i in 0..<sqlite3_column_count(statement) {
                        if let columnName = sqlite3_column_name(statement, i) {
                            let name = String(cString: columnName)
                            if let columnText = sqlite3_column_text(statement, i) {
                                let value = String(cString: columnText)
                                row[name] = value
                            }
                        }
                    }
                    rows.append(row)
                    result = sqlite3_step(statement)
                } while result == SQLITE_ROW
                sqlite3_finalize(statement)
                return (true, rows)
            } else if result == SQLITE_DONE {
                // Handle non-SELECT queries (INSERT, UPDATE, DELETE)
                sqlite3_finalize(statement)
                return (true, nil)
            } else {
                // If result is not SQLITE_ROW or SQLITE_DONE, it's an error
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Failure @ SQL-SecurityBreach: \(errmsg) Query : \(query)")
                sqlite3_finalize(statement)
                return (false, nil)
            }
        } else {
            // Handle SQL preparation error
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Failure @ SQL-SecurityBreach: \(errmsg) Query : \(query)")
            sqlite3_finalize(statement)
            return (false, nil)
        }
    }
}

class SecurityBreachBase {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file

    init() {
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("SecurityBreach.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("SecurityBreach.sqlite3")
            path = fileURL.path
            #endif


            if sqlite3_open(path, &db) != SQLITE_OK {
                print("Unable to open database : SecurityBreach")
                return
            }

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                print("Unable to set key for database : SecurityBreach")
                sqlite3_close(db)
                return
            }

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    public func restart(){
        sqlite3_close(db)
        do {
            #if os(visionOS) || os(iOS)
            let fileManager = FileManager.default
            
            let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let appSupportDirectory = urls[0]

            // If the directory does not exist, this will create it
            if !fileManager.fileExists(atPath: appSupportDirectory.path) {
                try fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        
            let fileURL = appSupportDirectory.appendingPathComponent("Synchronize.sqlite3")
            path = fileURL.path
            #endif
            
            #if os(macOS)
            let fileManager = FileManager.default
            // Change the search directory to `.documentDirectory` to get the path for the Documents directory
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = urls[0]

            // Create the file URL for the database
            let fileURL = documentsDirectory.appendingPathComponent("Synchronize.sqlite3")
            path = fileURL.path
            #endif


            if sqlite3_open(path, &db) != SQLITE_OK {
                print("Unable to re-open database : Synchronize")
                return
            }

            let key = Security.getDeviceSpecificSecretHash()
            if sqlite3_key(db, key, Int32(key.count)) != SQLITE_OK {
                print("Unable to re-set key for database : Synchronize")
                sqlite3_close(db)
                return
            }

        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            var result = sqlite3_step(statement)
            if result == SQLITE_ROW {
                // Handle SELECT queries
                var rows = [[String: String]]()
                repeat {
                    var row = [String: String]()
                    for i in 0..<sqlite3_column_count(statement) {
                        if let columnName = sqlite3_column_name(statement, i) {
                            let name = String(cString: columnName)
                            if let columnText = sqlite3_column_text(statement, i) {
                                let value = String(cString: columnText)
                                row[name] = value
                            }
                        }
                    }
                    rows.append(row)
                    result = sqlite3_step(statement)
                } while result == SQLITE_ROW
                sqlite3_finalize(statement)
                return (true, rows)
            } else if result == SQLITE_DONE {
                // Handle non-SELECT queries (INSERT, UPDATE, DELETE)
                sqlite3_finalize(statement)
                return (true, nil)
            } else {
                // If result is not SQLITE_ROW or SQLITE_DONE, it's an error
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Failure @ SQL-SecurityBreach: \(errmsg) Query : \(query)")
                sqlite3_finalize(statement)
                return (false, nil)
            }
        } else {
            // Handle SQL preparation error
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Failure @ SQL-SecurityBreach: \(errmsg) Query : \(query)")
            sqlite3_finalize(statement)
            return (false, nil)
        }
    }
}

#else


class DatabaseConnectionEstablisher {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
            print("Could Not Import SQLCipher From DatabaseConnectionEstablisher (SQLizers)")
            return (false, nil)

    }

}

class DevOpsDatabaseConnectionEstablisher {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
            print("Could Not Import SQLCipher From DevOpsDatabaseConnectionEstablisher (DevBaseLink)")
            return (false, nil)

    }

}

class DeviceInfoGraphics {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
            print("Could Not Import SQLCipher From DeviceInfoGraphics (Recorder)")
            return (false, nil)

    }

}

class DevOpsSyncDatabaseConnectionEstablisher {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
            print("Could Not Import SQLCipher From DevOpsSyncDatabaseConnectionEstablisher (DevBaseLink)")
            return (false, nil)

    }

}



class UpSyncDatabaseConnectionEstablisher {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
            print("Could Not Import SQLCipher From UpSyncDatabaseConnectionEstablisher (SyncUpSQLizers)")
            return (false, nil)

    }

}


class SecurityBreachBase {
    var db: OpaquePointer? = nil
    var path: String = ""// Make sure to use the actual path to your database file
    
    func executeQuery(_ query: String) -> (Bool, [[String: String]]?) {
            print("Could Not Import SQLCipher From SecurityBreachBase ()")
            return (false, nil)

    }

}



#endif


class Table{
    var tableName: String
    var columns: [String] = []
    
    init(_ tableName: String, _ columnNames: String...){
        self.tableName = tableName
        cl("table \(tableName) init",type: "insert")
        var ctq: String = "CREATE TABLE IF NOT EXISTS "
                ctq = ctq + tableName
                ctq = ctq + " ("
                for cn in columnNames{
                    self.columns.append(getName(cn))
                    ctq = ctq + sqlize(cn)
                }
                columns.append("area")
                columns.append("mcounti")
                columns.append("fromdat")
                columns.append("ftodat")
                columns.append("ftotim")
                columns.append("ftovername")
                columns.append("ftover")
                columns.append("ftopid")
                columns.append("todat")
                columns.append("totim")
                columns.append("tovername")
                columns.append("tover")
                columns.append("topid")
                columns.append("deviceanduserainfo")
                columns.append("basesite")
                columns.append("owncomcode")
                columns.append("testeridentity")
                columns.append("testcontrol")
                columns.append("adderpid")
                columns.append("addername")
                columns.append("adder")
                columns.append("syncstatus")
                columns.append("ipmac")
                columns.append("counti")
                columns.append("countifromserver")
                columns.append("doe")
                columns.append("toe")
                
                ctq = ctq + """
                    area TEXT NOT NULL DEFAULT '',
                    mcounti INTEGER NOT NULL DEFAULT 0,
                    fromdat DATE,
                    ftodat DATE DEFAULT '0000-00-00',
                    ftotim TIME,
                    ftovername TEXT NOT NULL DEFAULT '',
                    ftover TEXT NOT NULL DEFAULT '',
                    ftopid TEXT NOT NULL DEFAULT '',
                    todat DATE DEFAULT '0000-00-00',
                    totim TIME,
                    tovername TEXT NOT NULL DEFAULT '',
                    tover TEXT NOT NULL DEFAULT '',
                    topid TEXT NOT NULL DEFAULT '',
                    deviceanduserainfo TEXT NOT NULL DEFAULT 'NONE',
                    basesite TEXT NOT NULL DEFAULT 'NONE',
                    owncomcode TEXT NOT NULL DEFAULT 'NONE',
                    testeridentity TEXT NOT NULL DEFAULT '',
                    testcontrol TEXT NOT NULL DEFAULT '',
                    adderpid TEXT NOT NULL DEFAULT '',
                    addername TEXT NOT NULL DEFAULT '',
                    adder TEXT NOT NULL DEFAULT '',
                    syncstatus TEXT NOT NULL DEFAULT '',
                    ipmac TEXT NOT NULL DEFAULT '',
                    counti INTEGER PRIMARY KEY,
                    countifromserver TEXT NOT NULL DEFAULT '',
                    doe DATE,
                    toe TIME
                """
                ctq = ctq + ")"
        

        var _ = sql.executeQuery(ctq)

    }
    
    private func sqlize(_ nameType: String) -> String{
        if nameType.contains("TEXT"){
            return nameType.replacingOccurrences(of: "TEXT", with: "TEXT NOT NULL DEFAULT '',")
        }
        else if nameType.contains("INTEGER"){
            return nameType.replacingOccurrences(of: "INTEGER", with: "INTEGER NOT NULL DEFAULT 0,")
        }
        else if nameType.contains("REAL"){
            return nameType.replacingOccurrences(of: "REAL", with: "REAL NOT NULL DEFAULT 0,")
        }
        else{
            return nameType + ", "
        }
    }
    
    private func getName(_ nameType :String) -> String{
        return String(nameType.split(separator: "`")[0])
    }
}


