//
//  UserAndOrganisation.swift
//  SystemInfo
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 02/02/24.
//

import Foundation

class User{
    
    public init(){}
    
    private static var db: String = "test"
    private static var ownComCode: Int = 7
    private static var queue: String? = nil
    private static var name: String? = nil
    
    public static func login(username: String, password: String) -> (Bool,Int){
        return (true, 0)
    }
    
    public static func getQueue() -> String? {
        return self.queue
    }
    
    public static func getName() -> String? {
        return self.name
    }
    
    public static func login(mavirxhash: String) -> (Bool,Int){
        return (true, 0)
    }
    
    public static func getDB() -> String{
        return self.db
    }
    
    public static func getOwnComCode() -> Int{
        return self.ownComCode
    }
}

class Organization{
    
    public init(){}
    
    private static var db: String = "rdvj"
    private static var ownComCode: Int = 7
    
    public static func getDB() -> String{
        return self.db
    }
    
    public static func getOwnComCode() -> Int{
        return self.ownComCode
    }
}
