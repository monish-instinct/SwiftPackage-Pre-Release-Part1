//
//  SecureSQLHashGenerator.swift
//  Database
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 02/01/24.
//

import Foundation
import CryptoKit

class HashGenerator {
    public init(){}
    static func generateHash(from string: String) -> String {
        // Preprocess the input string by adding complexity
        let enhancedString = preprocessString(string)
        
        // Convert the enhanced string to Data and compute the SHA-256 hash
        let data = Data(enhancedString.utf8)
        let hash = SHA256.hash(data: data)
        
        // Postprocess the hash to further enhance its complexity
        let enhancedHash = postprocessHash(hash)
        
        return enhancedHash
    }

    private static func preprocessString(_ string: String) -> String {
        // Example: Reverse the string and append a constant
        return String(string.reversed()) + "Constant"
    }

    private static func postprocessHash(_ hash: SHA256Digest) -> String {
        // Example: Insert a custom string in the middle of the hash
        let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()
        let middleIndex = hashString.index(hashString.startIndex, offsetBy: hashString.count / 2)
        return hashString[..<middleIndex] + "CustomString" + hashString[middleIndex...]
    }
}

