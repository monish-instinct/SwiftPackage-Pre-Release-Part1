//
//  SmartLogs.swift
//  DevOps
//  Raghul'S Neural Engine
//
//  Created by Raghul Rd on 28/01/24.
//

import Foundation
//import RaghulsNeuralEngine

var clIterator: Int = 0
var clPrevMsg: String = ""
var clPrevType: String = ""
var clPrevLine: Int = -1
var clPrevFunction: String = ""
var clPrevClassName: String = ""
var clPrevFileName: String = ""

func cl<T>(_ object: Any? = nil, _ msg: T = "Reached Line $line : Iterated $i times", type: String = "Quick Print", line: Int = #line, function: String = #function, file: String = #file){
    var m = String(describing: msg)
    if m == "Reached Line $line : Iterated $i times"{
        m = "Reached Line \(line)"
    }
    
    let filename = (file as NSString).lastPathComponent
    let className: String
    if let object = object {
        className = String(describing: Swift.type(of: object))
    } else {
        className = "nil"
    }
    
    weak var _ = logWallet.insert("t"+str_replace("-","",in: dbClock.getDate() ?? "1010-10-10"), [ "filename":filename,"classname":className,"function":function,"line":String(line),"logtype":type,"msg":m ]);
        
    if clPrevFileName != filename || clPrevClassName != className || clPrevFunction != function || clPrevType != type{
        clIterator = 0
        clPrevFileName = filename
        clPrevClassName = className
        clPrevFunction = function
        clPrevType = type
        clPrevLine = line
        print("\(type) : --------------------------")
        print("\(type) : \(filename) / \(className) / \(function)")
        print("\(type) : on Line \(line) : \(m)")
    }
    else{
        if clPrevLine != line{
            clIterator = 0
            clPrevLine = line
            print("\(type) : on Line \(line) : \(m)")
        }
        else{
            clIterator += 1
            print("\(type) : on Line \(line) : \(m) : Iteration \(clIterator)")
        }
    }
}

func cl<T>(_ msg: T = "Reached Line $line : Iterated $i times", type: String = "Quick Print", line: Int = #line, function: String = #function, file: String = #file){
    var m = String(describing: msg)
    if m == "Reached Line $line : Iterated $i times"{
        m = "Reached Line \(line)"
    }
    
    let filename = (file as NSString).lastPathComponent
    let className: String = "Self isnt Passed"
    
    weak var _ = logWallet.insert("t"+str_replace("-","",in: dbClock.getDate() ?? "1010-10-10"), [ "filename":filename,"classname":className,"function":function,"line":String(line),"logtype":type,"msg":m ]);
        
    if clPrevFileName != filename || clPrevClassName != className || clPrevFunction != function || clPrevType != type{
        clIterator = 0
        clPrevFileName = filename
        clPrevClassName = className
        clPrevFunction = function
        clPrevType = type
        clPrevLine = line
        print("\(type) : --------------------------")
        print("\(type) : \(filename) / \(className) / \(function)")
        print("\(type) : on Line \(line) : \(m)")
    }
    else{
        if clPrevLine != line{
            clIterator = 0
            clPrevLine = line
            print("\(type) : on Line \(line) : \(m)")
        }
        else{
            clIterator += 1
            print("\(type) : on Line \(line) : \(m) : Iteration \(clIterator)")
        }
    }
}
