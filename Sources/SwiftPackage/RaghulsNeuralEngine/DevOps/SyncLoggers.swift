//
//  SmartLogs.swift
//  DevOps
//  Raghul'S Neural Engine
//
//  Created by Raghul Rd on 28/01/24.
//

import Foundation
//import RaghulsNeuralEngine

var clSyncIterator: Int = 0
var clSyncPrevMsg: String = ""
var clSyncPrevType: String = ""
var clSyncPrevLine: Int = -1
var clSyncPrevFunction: String = ""
var clSyncPrevClassName: String = ""
var clSyncPrevFileName: String = ""

func clSync<T>(_ object: Any? = nil, _ msg: T = "Reached Line $line : Iterated $i times", type: String = "Sync", line: Int = #line, function: String = #function, file: String = #file){
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
    
    weak var _ = logSyncWallet.insert("s"+str_replace("-","",in: dbClock.getDate() ?? "1010-10-10"), [ "filename":filename,"ClassName":className,"function":function,"line":String(line),"logtype":type,"msg":m ]);
        
    if clSyncPrevFileName != filename || clSyncPrevClassName != className || clSyncPrevFunction != function || clSyncPrevType != type{
        clSyncIterator = 0
        clSyncPrevFileName = filename
        clSyncPrevClassName = className
        clSyncPrevFunction = function
        clSyncPrevType = type
        clSyncPrevLine = line
        print("\(type) : --------------------------")
        print("\(type) : \(filename) / \(className) / \(function)")
        print("\(type) : on Line \(line) : \(m)")
    }
    else{
        if clSyncPrevLine != line{
            clSyncIterator = 0
            clSyncPrevLine = line
            print("\(type) : on Line \(line) : \(m)")
        }
        else{
            clSyncIterator += 1
            print("\(type) : on Line \(line) : \(m) : Iteration \(clSyncIterator)")
        }
    }
}

func clSync<T>(_ msg: T = "Reached Line $line : Iterated $i times", type: String = "Sync", line: Int = #line, function: String = #function, file: String = #file){
    var m = String(describing: msg)
    if m == "Reached Line $line : Iterated $i times"{
        m = "Reached Line \(line)"
    }
    
    let filename = (file as NSString).lastPathComponent
    let className: String = "Self isnt Passed"
    
    let _ = logSyncWallet.insert("s"+str_replace("-","",in: dbClock.getDate() ?? "1010-10-10"), [ "filename":filename,"ClassName":className,"function":function,"line":String(line),"logtype":type,"msg":m ]);
        
    if clSyncPrevFileName != filename || clSyncPrevClassName != className || clSyncPrevFunction != function || clSyncPrevType != type{
        clSyncIterator = 0
        clSyncPrevFileName = filename
        clSyncPrevClassName = className
        clSyncPrevFunction = function
        clSyncPrevType = type
        clSyncPrevLine = line
        print("\(type) : --------------------------")
        print("\(type) : \(filename) / \(className) / \(function)")
        print("\(type) : on Line \(line) : \(m)")
    }
    else{
        if clSyncPrevLine != line{
            clSyncIterator = 0
            clSyncPrevLine = line
            print("\(type) : on Line \(line) : \(m)")
        }
        else{
            clSyncIterator += 1
            print("\(type) : on Line \(line) : \(m) : Iteration \(clSyncIterator)")
        }
    }
}
