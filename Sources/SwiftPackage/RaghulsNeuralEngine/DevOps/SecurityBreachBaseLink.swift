//
//  SecurityBreachBaseLink.swift
//  RD Vivaha Jewellers
//
//  Created by Raghul S on 17/03/24.
//

import Foundation

class SecurityBreach: SecurityBreachBase{
    var sqt6 = [SqlTracker]()
    
    override init(){
        super.init()
        //local date/time changed
        var ctq: String = "CREATE TABLE IF NOT EXISTS "
        ctq = ctq + "local_date_time_changed"
        ctq = ctq + " ("
        
        ctq = ctq + """
        `ip_address` TEXT,
        `device_name` TEXT,
        `device_unique_code` TEXT,
    
        `queue` TEXT,
        `name` TEXT,
        `prev_queues` TEXT,
        `prev_names` TEXT,
    
        `user_and_login_info_counti` TEXT,
        `ipaddresses_counti` INT,
        `internet_provider_details_counti` INT,
        `date_and_time_keeper_counti` INT,
        `changing_details_like_battery_proximity_and_storage_counti`    INT,
        `gps_details_counti` INT,
    
        `local_time` TIME,
        `local_date` DATE,
        `min_time` TIME,
        `min_date` DATE,
        `db_time` TIME,
        `db_date` DATE,
        `last_page_visited` TEXT,
    
        `area` TEXT NOT NULL DEFAULT '',
        `counti` INTEGER PRIMARY KEY,
        `ipmac` TEXT NOT NULL DEFAULT '',
        `deviceanduserainfo` TEXT NOT NULL DEFAULT 'NONE',
        `basesite` TEXT NOT NULL DEFAULT 'NONE',
        `owncomcode` TEXT NOT NULL DEFAULT 'NONE',
        `testeridentity` TEXT NOT NULL DEFAULT '',
        `testcontrol` TEXT NOT NULL DEFAULT '',
        `adderpid` TEXT NOT NULL DEFAULT '',
        `addername` TEXT NOT NULL DEFAULT '',
        `adder` TEXT NOT NULL DEFAULT '',
        `doe` DATE,
        `toe` TIME
    """
        ctq = ctq + ")"
        
        var _ = executeQuery(ctq)
        
        //visited access denied page
        ctq = "CREATE TABLE IF NOT EXISTS "
        ctq = ctq + "visited_access_denied_page"
        ctq = ctq + " ("
        
        ctq = ctq + """
        `ip_address` TEXT,
        `device_name` TEXT,
        `device_unique_code` TEXT,
    
        `user_and_login_info_counti` TEXT,
        `ipaddresses_counti` INT,
        `internet_provider_details_counti` INT,
        `date_and_time_keeper_counti` INT,
        `changing_details_like_battery_proximity_and_storage_counti`    INT,
        `gps_details_counti` INT,
    
        `queue` TEXT,
        `name` TEXT,
        `prev_queues` TEXT,
        `prev_names` TEXT,
    
        `queue_rights` TEXT,
        `last_page_visited` TEXT,
        `last_page_visited_rights` TEXT,
        `previous_page_visited` TEXT,
    
        `area` TEXT NOT NULL DEFAULT '',
        `counti` INTEGER PRIMARY KEY,
        `ipmac` TEXT NOT NULL DEFAULT '',
        `deviceanduserainfo` TEXT NOT NULL DEFAULT 'NONE',
        `basesite` TEXT NOT NULL DEFAULT 'NONE',
        `owncomcode` TEXT NOT NULL DEFAULT 'NONE',
        `testeridentity` TEXT NOT NULL DEFAULT '',
        `testcontrol` TEXT NOT NULL DEFAULT '',
        `adderpid` TEXT NOT NULL DEFAULT '',
        `addername` TEXT NOT NULL DEFAULT '',
        `adder` TEXT NOT NULL DEFAULT '',
        `doe` DATE,
        `toe` TIME
    """
        ctq = ctq + ")"
        
        var _ = executeQuery(ctq)
        
        //wrong login attempts
        
        ctq = "CREATE TABLE IF NOT EXISTS "
        ctq = ctq + "wrong_login_attempts"
        ctq = ctq + " ("
        
        ctq = ctq + """
        `ip_address` TEXT,
        `device_name` TEXT,
        `device_unique_code` TEXT,
    
        `prev_queue` TEXT,
        `prev_name` TEXT,
        `prev_queues` TEXT,
        `prev_names` TEXT,
    
        `user_and_login_info_counti` TEXT,
        `ipaddresses_counti` INT,
        `internet_provider_details_counti` INT,
        `date_and_time_keeper_counti` INT,
        `changing_details_like_battery_proximity_and_storage_counti`    INT,
        `gps_details_counti` INT,
    
        `user_name` TEXT,
        `password` TEXT,
        `last_page_visited` TEXT,
        `attempts_count` TEXT,
    
        `area` TEXT NOT NULL DEFAULT '',
        `counti` INTEGER PRIMARY KEY,
        `ipmac` TEXT NOT NULL DEFAULT '',
        `deviceanduserainfo` TEXT NOT NULL DEFAULT 'NONE',
        `basesite` TEXT NOT NULL DEFAULT 'NONE',
        `owncomcode` TEXT NOT NULL DEFAULT 'NONE',
        `testeridentity` TEXT NOT NULL DEFAULT '',
        `testcontrol` TEXT NOT NULL DEFAULT '',
        `adderpid` TEXT NOT NULL DEFAULT '',
        `addername` TEXT NOT NULL DEFAULT '',
        `adder` TEXT NOT NULL DEFAULT '',
        `doe` DATE,
        `toe` TIME
    """
        ctq = ctq + ")"
        
        var _ = executeQuery(ctq)
        
        //wrorng sms otp attempts
        
        ctq = "CREATE TABLE IF NOT EXISTS "
        ctq = ctq + "wrong_sms_otp_attempts"
        ctq = ctq + " ("
        
        ctq = ctq + """
        `ip_address` TEXT,
        `device_name` TEXT,
        `device_unique_code` TEXT,
    
        `queue` TEXT,
        `name` TEXT,
        `prev_queues` TEXT,
        `prev_names` TEXT,
    
        `user_and_login_info_counti` TEXT,
        `ipaddresses_counti` INT,
        `internet_provider_details_counti` INT,
        `date_and_time_keeper_counti` INT,
        `changing_details_like_battery_proximity_and_storage_counti`    INT,
        `gps_details_counti` INT,
    
        `phone_number` TEXT,
        `given_otp` INT,
        `actual_otp` INT,
        `network_status` TEXT,
        `last_page_visited` TEXT,
        `attempts_count` TEXT,
    
        `area` TEXT NOT NULL DEFAULT '',
        `counti` INTEGER PRIMARY KEY,
        `ipmac` TEXT NOT NULL DEFAULT '',
        `deviceanduserainfo` TEXT NOT NULL DEFAULT 'NONE',
        `basesite` TEXT NOT NULL DEFAULT 'NONE',
        `owncomcode` TEXT NOT NULL DEFAULT 'NONE',
        `testeridentity` TEXT NOT NULL DEFAULT '',
        `testcontrol` TEXT NOT NULL DEFAULT '',
        `adderpid` TEXT NOT NULL DEFAULT '',
        `addername` TEXT NOT NULL DEFAULT '',
        `adder` TEXT NOT NULL DEFAULT '',
        `doe` DATE,
        `toe` TIME
    """
        ctq = ctq + ")"
        
        var _ = executeQuery(ctq)
        
       
        
        //wrong mail otp attempts
        
        ctq = "CREATE TABLE IF NOT EXISTS "
        ctq = ctq + "wrong_mail_otp_attempts"
        ctq = ctq + " ("
        
        ctq = ctq + """
        `ip_address` TEXT,
        `device_name` TEXT,
        `device_unique_code` TEXT,
    
        `queue` TEXT,
        `name` TEXT,
        `prev_queues` TEXT,
        `prev_names` TEXT,
    
        `user_and_login_info_counti` TEXT,
        `ipaddresses_counti` INT,
        `internet_provider_details_counti` INT,
        `date_and_time_keeper_counti` INT,
        `changing_details_like_battery_proximity_and_storage_counti`    INT,
        `gps_details_counti` INT,

        `email_id` TEXT,
        `given_otp` INT,
        `actual_otp` INT,
        `network_status` TEXT,
        `last_page_visited` TEXT,
        `attempts_count` TEXT,
    
        `area` TEXT NOT NULL DEFAULT '',
        `counti` INTEGER PRIMARY KEY,
        `ipmac` TEXT NOT NULL DEFAULT '',
        `deviceanduserainfo` TEXT NOT NULL DEFAULT 'NONE',
        `basesite` TEXT NOT NULL DEFAULT 'NONE',
        `owncomcode` TEXT NOT NULL DEFAULT 'NONE',
        `testeridentity` TEXT NOT NULL DEFAULT '',
        `testcontrol` TEXT NOT NULL DEFAULT '',
        `adderpid` TEXT NOT NULL DEFAULT '',
        `addername` TEXT NOT NULL DEFAULT '',
        `adder` TEXT NOT NULL DEFAULT '',
        `doe` DATE,
        `toe` TIME
    """
        ctq = ctq + ")"
        
        var _ = executeQuery(ctq)
        
        
        //huge data synchronization left
        
        ctq = "CREATE TABLE IF NOT EXISTS "
        ctq = ctq + "wrong_mail_otp_attempts"
        ctq = ctq + " ("
        
        ctq = ctq + """
        `ip_address` TEXT,
        `device_name` TEXT,
        `device_unique_code` TEXT,
    
        `queue` TEXT,
        `name` TEXT,
        `prev_queues` TEXT,
        `prev_names` TEXT,
    
        `user_and_login_info_counti` TEXT,
        `ipaddresses_counti` INT,
        `internet_provider_details_counti` INT,
        `date_and_time_keeper_counti` INT,
        `changing_details_like_battery_proximity_and_storage_counti`    INT,
        `gps_details_counti` INT,
    
        `area` TEXT NOT NULL DEFAULT '',
        `counti` INTEGER PRIMARY KEY,
        `ipmac` TEXT NOT NULL DEFAULT '',
        `deviceanduserainfo` TEXT NOT NULL DEFAULT 'NONE',
        `basesite` TEXT NOT NULL DEFAULT 'NONE',
        `owncomcode` TEXT NOT NULL DEFAULT 'NONE',
        `testeridentity` TEXT NOT NULL DEFAULT '',
        `testcontrol` TEXT NOT NULL DEFAULT '',
        `adderpid` TEXT NOT NULL DEFAULT '',
        `addername` TEXT NOT NULL DEFAULT '',
        `adder` TEXT NOT NULL DEFAULT '',
        `doe` DATE,
        `toe` TIME
    """
        ctq = ctq + ")"
        
        var _ = executeQuery(ctq)
        
        
    }
    
    
    func insert(_ tableName: String, _ kvp: [String:String], fileName: String = #file) -> (counti:Int,success:Bool,query:String){
        return (-1, false, "")
    }
    
    
}
