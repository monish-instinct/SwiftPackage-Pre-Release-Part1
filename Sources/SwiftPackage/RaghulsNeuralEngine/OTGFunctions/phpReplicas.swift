//
//  phpReplicas.swift
//  OTGFunctions
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 02/02/24.
//

import Foundation

func str_replace(_ search: String, _ replace: String, in originalString: String) -> String {
    return originalString.replacingOccurrences(of: search, with: replace)
}

func explode(_ delimiter: Character, _ string: String) -> [String] {
    return string.split(separator: delimiter).map(String.init)
}

