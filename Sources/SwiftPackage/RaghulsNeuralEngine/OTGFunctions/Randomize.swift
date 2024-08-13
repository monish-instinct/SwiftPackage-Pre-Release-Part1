//
//  Randomize.swift
//  OTGFunctions
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 02/02/24.
//

import Foundation

func random(start: Int, end: Int) -> Int {
    return Int.random(in: start...end)
}


func random(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
    var randomString = ""

    for _ in 0..<length {
        let randomIndex = Int.random(in: 0..<letters.count)
        let index = letters.index(letters.startIndex, offsetBy: randomIndex)
        randomString.append(letters[index])
    }

    return randomString
}
