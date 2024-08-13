//
//  jsReplicas.swift
//  OTGFunctions
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 28/02/24.
//

import Foundation

extension String {
    func split(_ separator: Character) -> [String] {
        return self.split(separator: separator).map { String($0) }
    }
}

