//
//  Temporary.swift
//  OTGFunctions
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 02/02/24.
//

import Foundation
//import RaghulsNeuralEngine

func enqry(_ query: String) -> String {
    return str_replace("'","qj5iqxj77bq",in: str_replace("\"","qj7iqxj55bq",in: query))
}

func deqry(_ query: String) -> String {
    return str_replace("qj5iqxj77bq","'",in: str_replace("qj7iqxj55bq","\"",in: query))
}

func convertKVPToString(kvp: [String: String]) -> String {
    guard JSONSerialization.isValidJSONObject(kvp) else { return "" }

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: kvp, options: [])
        return String(data: jsonData, encoding: .utf8) ?? ""
    } catch {
        clSync("Error converting to JSON: \(error)")
        return ""
    }
}

func removeLast(from string: String, ifEndsWith character: Character) -> String {
    guard string.hasSuffix(String(character)) else {
        return string
    }
    return String(string.dropLast())
}

func sizeOf(_ myString: String) -> Int {
    return myString.lengthOfBytes(using: .utf8)
}

func convertUpSyncRowToJSON(_ toInsert: [String: String]) -> String {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: toInsert, options: [])
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    } catch {
        clSync("Error converting to JSON: \(error)")
    }
    return "{}"
}

func ivc(_ param: String) -> String {
    return "'" + enqry(param) + "'"
}
