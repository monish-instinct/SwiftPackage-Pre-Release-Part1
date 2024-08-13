//
//  SystemSecurity.swift
//  DevOps
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 25/02/24.
//

import Foundation
import CryptoKit
//import RaghulsNeuralEngine

func sha256Hash(for input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
    
    return hashString
}

class Security{
    
    public init(){}
    
    private static var deviceSpecificSecretHash = ""
    
    static func getDeviceSpecificSecretHash()->String{
        return deviceSpecificSecretHash
    }
    
    static func generateDeviceSpecificSecretHash(){
        let id = Device.getUniqueID()+"3"
        let r1 = geminiScrambler(id: id)
        let r2 = chatGPTscrambler(data: r1)
        var r3 = ""
        
        var a = 0
        var b = 0
        var c = 0
        var d = 0
        // Calculate the total iterations needed
        let totalIterations = r2.count + id.count + r1.count + r1.count

        // Indices for accessing characters in strings
        var indexR1 = r1.startIndex
        var indexR2 = r2.startIndex
        var indexR3 = r1.startIndex
        var indexID = id.startIndex

        for i in 0..<totalIterations {
            if i % 4 == 0 && a < r1.count {
                r3.append(r1[indexR1])
                a += 1
                indexR1 = r1.index(after: indexR1)
            } else if i % 3 == 0 && b < r1.count {
                // Using the same string (r1) and index because the original conditions seem to indicate this; adjust if needed
                r3.append(r1[indexR3])
                b += 1
                indexR3 = r1.index(after: indexR3)
            } else if i % 2 == 0 && c < id.count {
                r3.append(id[indexID])
                c += 1
                indexID = id.index(after: indexID)
            } else if d < r2.count {
                r3.append(r2[indexR2])
                d += 1
                indexR2 = r2.index(after: indexR2)
            }
        }
        Security.deviceSpecificSecretHash = str_replace("a","K",in:sha256Hash(for: r3))
    }
    
    static internal func chatGPTscrambler(data: String) -> String{
        var result = ""
        let characters = Array(data)
        let length = characters.count
        
        for i in 0..<length {
            let char = characters[i]
            let isEvenPosition = i % 2 == 0
            var asciiValue = Int(char.asciiValue ?? 0)
            
            if isEvenPosition {
                // Even position adjustments
                if char.isLetter {
                    // Rotate letters A-Z, a-z within their ranges
                    if char.isUppercase {
                        asciiValue = ((asciiValue - 65 + 3) % 26) + 65
                    } else {
                        asciiValue = ((asciiValue - 97 + 3) % 26) + 97
                    }
                } else if char.isNumber {
                    // Rotate numbers within 0-9
                    asciiValue = ((asciiValue - 48 + 5) % 10) + 48
                } else {
                    // For non-alphanumeric, just flip bits in a controlled manner
                    asciiValue = asciiValue ^ 3
                }
            } else {
                // Odd position adjustments
                if char.isLetter {
                    // Rotate in opposite direction
                    if char.isUppercase {
                        asciiValue = ((asciiValue - 65 - 3 + 26) % 26) + 65
                    } else {
                        asciiValue = ((asciiValue - 97 - 3 + 26) % 26) + 97
                    }
                } else if char.isNumber {
                    asciiValue = ((asciiValue - 48 - 5 + 10) % 10) + 48
                } else {
                    asciiValue = asciiValue ^ 1
                }
            }
            
            // Nested loop for additional scrambling based on current char position
            var newCharValue = asciiValue
            for j in 1...3 {
                if (i + j) % 2 == 0 {
                    newCharValue += j
                } else {
                    newCharValue -= j
                }
            }
            
            // Ensure newCharValue remains within printable ASCII range
            newCharValue = max(32, min(newCharValue, 126))
            
            result += String(UnicodeScalar(newCharValue)!)
        }
        
        return result
    }

    
    static internal func geminiScrambler(id: String) -> String {
      // Initialize variables
      var result = ""
      let length = id.count

      // 1. Reverse the first half of the string
      for i in 0..<(length / 2) {
          _ = id.index(id.startIndex, offsetBy: i)
          let reversedIndex = id.index(id.startIndex, offsetBy: length - 1 - i)
          result.append(id[reversedIndex])
      }

      // 2. Iterate through the rest, applying character shifts
      for i in (length / 2)..<length {
          let index = id.index(id.startIndex, offsetBy: i)
          let char = id[index]

          var newChar = char

          // Shift letters based on position
          if char.isLetter {
              let shift = (i % 5) + 1 // Shift between 1 and 5 positions
              newChar = geminiShiftCharacter(char, by: shift)
          }

          result.append(newChar)
      }

      // Return the scrambled result
      return result
    }

    // Helper function to shift letters circularly
    static internal func geminiShiftCharacter(_ char: Character, by shiftAmount: Int) -> Character {
      guard char.isLetter else { return char }

      let alphabetStart = char.isUppercase ? "A" : "a"
        _ = char.isUppercase ? "Z" : "z"
      let offset = (Int(char.asciiValue!) - Int(UnicodeScalar(alphabetStart)!.value) + shiftAmount) % 26
      let shiftedUnicode = UnicodeScalar(Int(UnicodeScalar(alphabetStart)!.value) + offset)!
      return Character(shiftedUnicode)
    }
}


class ServerSecurity{
    private static var serverSpecificSecretHash = ""
    
    static func getServerSpecificSecretHash()->String{
        return serverSpecificSecretHash
    }
    
    static func generateServerSpecificSecretHash(){
        let id = "RaghulMonish"+"3"
        let r1 = geminiScrambler(id: id)
        let r2 = chatGPTscrambler(data: r1)
        var r3 = ""
        
        var a = 0
        var b = 0
        var c = 0
        var d = 0
        // Calculate the total iterations needed
        let totalIterations = r2.count + id.count + r1.count + r1.count

        // Indices for accessing characters in strings
        var indexR1 = r1.startIndex
        var indexR2 = r2.startIndex
        var indexR3 = r1.startIndex
        var indexID = id.startIndex

        for i in 0..<totalIterations {
            if i % 4 == 0 && a < r1.count {
                r3.append(r1[indexR1])
                a += 1
                indexR1 = r1.index(after: indexR1)
            } else if i % 3 == 0 && b < r1.count {
                // Using the same string (r1) and index because the original conditions seem to indicate this; adjust if needed
                r3.append(r1[indexR3])
                b += 1
                indexR3 = r1.index(after: indexR3)
            } else if i % 2 == 0 && c < id.count {
                r3.append(id[indexID])
                c += 1
                indexID = id.index(after: indexID)
            } else if d < r2.count {
                r3.append(r2[indexR2])
                d += 1
                indexR2 = r2.index(after: indexR2)
            }
        }
        ServerSecurity.serverSpecificSecretHash = str_replace("a","K",in:sha256Hash(for: r3))
    }
    
    static internal func chatGPTscrambler(data: String) -> String{
        var result = ""
        let characters = Array(data)
        let length = characters.count
        
        for i in 0..<length {
            let char = characters[i]
            let isEvenPosition = i % 2 == 0
            var asciiValue = Int(char.asciiValue ?? 0)
            
            if isEvenPosition {
                // Even position adjustments
                if char.isLetter {
                    // Rotate letters A-Z, a-z within their ranges
                    if char.isUppercase {
                        asciiValue = ((asciiValue - 65 + 3) % 26) + 65
                    } else {
                        asciiValue = ((asciiValue - 97 + 3) % 26) + 97
                    }
                } else if char.isNumber {
                    // Rotate numbers within 0-9
                    asciiValue = ((asciiValue - 48 + 5) % 10) + 48
                } else {
                    // For non-alphanumeric, just flip bits in a controlled manner
                    asciiValue = asciiValue ^ 3
                }
            } else {
                // Odd position adjustments
                if char.isLetter {
                    // Rotate in opposite direction
                    if char.isUppercase {
                        asciiValue = ((asciiValue - 65 - 3 + 26) % 26) + 65
                    } else {
                        asciiValue = ((asciiValue - 97 - 3 + 26) % 26) + 97
                    }
                } else if char.isNumber {
                    asciiValue = ((asciiValue - 48 - 5 + 10) % 10) + 48
                } else {
                    asciiValue = asciiValue ^ 1
                }
            }
            
            // Nested loop for additional scrambling based on current char position
            var newCharValue = asciiValue
            for j in 1...3 {
                if (i + j) % 2 == 0 {
                    newCharValue += j
                } else {
                    newCharValue -= j
                }
            }
            
            // Ensure newCharValue remains within printable ASCII range
            newCharValue = max(32, min(newCharValue, 126))
            
            result += String(UnicodeScalar(newCharValue)!)
        }
        
        return result
    }

    
    static internal func geminiScrambler(id: String) -> String {
      // Initialize variables
      var result = ""
      let length = id.count

      // 1. Reverse the first half of the string
      for i in 0..<(length / 2) {
          _ = id.index(id.startIndex, offsetBy: i)
          let reversedIndex = id.index(id.startIndex, offsetBy: length - 1 - i)
          result.append(id[reversedIndex])
      }

      // 2. Iterate through the rest, applying character shifts
      for i in (length / 2)..<length {
          let index = id.index(id.startIndex, offsetBy: i)
          let char = id[index]

          var newChar = char

          // Shift letters based on position
          if char.isLetter {
              let shift = (i % 5) + 1 // Shift between 1 and 5 positions
              newChar = geminiShiftCharacter(char, by: shift)
          }

          result.append(newChar)
      }

      // Return the scrambled result
      return result
    }

    // Helper function to shift letters circularly
    static internal func geminiShiftCharacter(_ char: Character, by shiftAmount: Int) -> Character {
      guard char.isLetter else { return char }

      let alphabetStart = char.isUppercase ? "A" : "a"
        _ = char.isUppercase ? "Z" : "z"
      let offset = (Int(char.asciiValue!) - Int(UnicodeScalar(alphabetStart)!.value) + shiftAmount) % 26
      let shiftedUnicode = UnicodeScalar(Int(UnicodeScalar(alphabetStart)!.value) + offset)!
      return Character(shiftedUnicode)
    }
}
