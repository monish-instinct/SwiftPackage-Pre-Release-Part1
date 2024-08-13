//
//  DatabaseUpSyncInsert.swift
//  RD Vivaha Jewellers
//
//  Created by InstincT on 30/07/24.
//

import Foundation

public class DatabaseUpSync {
    public init(){}
    private static var failedQueries: [(String, String, String, Int, Int)] = []

    public static func executeQueryInPHP(query: String, tablename: String, queryType: String, counti: Int, completion: @escaping (String?, Int?, [String: Any]?, Bool, String?) -> Void) {
        // Construct the URL dynamically based on the tablename and queryType
        let urlString = "http://localhost/RaghulMonishsNeuralEngine/NeuralMemory/\(tablename)/\(queryType).php"
        guard let url = URL(string: urlString) else {
            completion(nil, nil, nil, false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = "query=\(query)&counti=\(counti)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, nil, nil, false, error?.localizedDescription)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let status = json["status"] as? String
                    let lastId = json["last_id"] as? Int
                    let errorMessage = json["message"] as? String ?? "Unknown error"
                    let message = "[\(counti):\(lastId ?? 0)]"
                    
                    if status == "success" {
                        completion(message, lastId, json, true, nil)
                    } else {
                        completion(nil, lastId, json, false, errorMessage)
                    }
                } else {
                    completion(nil, nil, nil, false, "Invalid JSON response")
                }
            } catch {
                completion(nil, nil, nil, false, error.localizedDescription)
            }
        }
        
        task.resume()
    }

    public static func segregateAndPrintQueries(_ output: (Bool, Any?)) {
        guard let (_, queries) = output as? (Bool, [[String: String]]), !queries.isEmpty else {
            clSync("Invalid output or no queries found.")
            return
        }
        
        var queryArray: [(String, String, String, Int, Int)] = []
        for queryDict in queries {
            if let query = queryDict["query"],
               let tablename = queryDict["tablename"],
               let queryType = queryDict["querytype"],
               let countioftableStr = queryDict["countifromtable"],
               let countioftable = Int(countioftableStr),
               let countiStr = queryDict["counti"],
               let counti = Int(countiStr) {
                queryArray.append((query, tablename, queryType, countioftable, counti))
            }
        }
        executeQueries(queries: queryArray)
    }

    private static func executeQueries(queries: [(String, String, String, Int, Int)]) {
        var combinedSuccessMessages: [String] = []
        var combinedFailedMessages: [String] = []
        var currentBatch: [(String, String, String, Int, Int)] = []
        let dispatchGroup = DispatchGroup()
        
        for (query, tablename, queryType, countioftable, counti) in queries {
            let querySize = query.lengthOfBytes(using: .utf8)
            let currentBatchSize = currentBatch.reduce(0) { $0 + $1.0.lengthOfBytes(using: .utf8) }
            if currentBatchSize + querySize > 200 * 1024 {
                clSync("Current batch size: \(currentBatchSize / 1024) KB")
                
                dispatchGroup.enter()
                executeBatch(currentBatch) { successMessages, failedMessages in
                    combinedSuccessMessages.append(contentsOf: successMessages)
                    combinedFailedMessages.append(contentsOf: failedMessages)
                    dispatchGroup.leave()
                }
                currentBatch.removeAll()
            }
            
            currentBatch.append((query, tablename, queryType, countioftable, counti))
        }
        
        if !currentBatch.isEmpty {
            let currentBatchSize = currentBatch.reduce(0) { $0 + $1.0.lengthOfBytes(using: .utf8) }
            clSync("Current batch size: \(currentBatchSize / 1024) KB")
            
            dispatchGroup.enter()
            executeBatch(currentBatch) { successMessages, failedMessages in
                combinedSuccessMessages.append(contentsOf: successMessages)
                combinedFailedMessages.append(contentsOf: failedMessages)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if !combinedFailedMessages.isEmpty {
                retryFailedQueries(failedQueries)
            } else {
                let finalSuccessMessage = combinedSuccessMessages.joined(separator: ",")
                let finalFailedMessage = combinedFailedMessages.joined(separator: ",")
                let finalResponse = "{\"status\": \"synced\", \"message\": {\"success\": [\(finalSuccessMessage)], \"failed\": [\(finalFailedMessage)]}}"
                clSync("IPAddressesInfoSync Response: \(finalResponse)")
            }
        }
    }
    
    private static func executeBatch(_ batch: [(String, String, String, Int, Int)], completion: @escaping ([String], [String]) -> Void) {
        var successMessages: [String] = []
        var failedMessages: [String] = []
        let dispatchGroup = DispatchGroup()
        
        for (query, tablename, queryType, countioftable, counti) in batch {
            dispatchGroup.enter()
            executeQueryInPHP(query: query, tablename: tablename, queryType: queryType, counti: countioftable) { response, lastId, json, success, errorMessage in
                if success {
                    if queryType == "insert", let response = response, let lastId = lastId {
                        successMessages.append(response)
                        let updateQuery = "UPDATE \(tablename) SET countifromserver = \(lastId), syncstatus = 'synced' WHERE counti = \(countioftable)"
                        sql.executeQuery(updateQuery)
                    }
                } else {
                    let failedMessage = "[\(counti):\(errorMessage ?? "Unknown error")]"
                    failedMessages.append(failedMessage)
                    failedQueries.append((query, tablename, queryType, countioftable, counti))
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(successMessages, failedMessages)
        }
    }
    
    private static func retryFailedQueries(_ queries: [(String, String, String, Int, Int)]) {
        var combinedSuccessMessages: [String] = []
        var combinedFailedMessages: [String] = []
        let dispatchGroup = DispatchGroup()
        
        for (query, tablename, queryType, countioftable, counti) in queries {
            dispatchGroup.enter()
            executeQueryInPHP(query: query, tablename: tablename, queryType: queryType, counti: countioftable) { response, lastId, json, success, errorMessage in
                if success {
                    if queryType == "insert", let response = response, let lastId = lastId {
                        combinedSuccessMessages.append(response)
                        let updateQuery = "UPDATE \(tablename) SET countifromserver = \(lastId), syncstatus = 'synced' WHERE counti = \(countioftable)"
                        sql.executeQuery(updateQuery)
                    }
                } else {
                    let failedMessage = "[\(counti):\(errorMessage ?? "Unknown error")]"
                    combinedFailedMessages.append(failedMessage)
                    if queryType == "insert" {
                        let updateQuery = "UPDATE \(tablename) SET syncstatus = '\(errorMessage ?? "Unknown error")' WHERE counti = \(countioftable)"
                        sql.executeQuery(updateQuery)
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if combinedFailedMessages.isEmpty {
                let finalSuccessMessage = combinedSuccessMessages.joined(separator: ",")
                let finalResponse = "{\"status\": \"synced\", \"message\": {\"success\": [\(finalSuccessMessage)], \"failed\": []}}"
                clSync("IPAddressesInfoSync Response: \(finalResponse)")
            } else {
                let finalFailedMessage = combinedFailedMessages.joined(separator: ",")
                let finalResponse = "{\"status\": \"sync failed\", \"message\": {\"success\": [], \"failed\": [\(finalFailedMessage)]}}"
                clSync("IPAddressesInfoSync Response: \(finalResponse)")
            }
        }
    }
}
