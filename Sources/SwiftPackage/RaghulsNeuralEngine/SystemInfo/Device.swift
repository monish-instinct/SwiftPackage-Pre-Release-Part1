//
//  Device.swift
//  SystemInfo
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 02/01/24.
//
#if os(visionOS) || os(iOS)
import UIKit

class Device {
    
    public init(){}
    
    static func getModelName() -> String {
        return UIDevice.current.name
    }

    static func getUserName() -> String {
        return UIDevice.current.localizedModel
    }

    static func getUniqueID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "Unavailable"
    }
    
    static func getBatteryLevel() -> String {
        return String(UIDevice.current.batteryLevel)
    }

    static func getFreeSpace() -> String {
            let freeSpace = getFileSystemAttribute(.systemFreeSize)
            return formatBytesAsGB(freeSpace) + " GB"
    }

    static func getStorageSize() -> String {
        let totalSpace = getFileSystemAttribute(.systemSize)
        return formatBytesAsGB(totalSpace) + " GB"
    }

    static func getUsedSpace() -> String {
        let totalSpace = getFileSystemAttribute(.systemSize)
        let freeSpace = getFileSystemAttribute(.systemFreeSize)
        let usedSpace = totalSpace - freeSpace
        return formatBytesAsGB(usedSpace) + " GB"
    }

    static func getDeviceAndUserDataForeignKey() -> String {
        return ""
    }

    static func getMac() -> String {
        return ""
    }

    private static func getFileSystemAttribute(_ attribute: FileAttributeKey) -> Int64 {
        let fileManager = FileManager.default
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
            return (attributes[attribute] as? NSNumber)?.int64Value ?? 0
        } catch {
            print("Error retrieving file system attribute: \(error)")
            return 0
        }
    }

    private static func formatBytesAsGB(_ bytes: Int64) -> String {
        let gigabytes = Double(bytes) / (1024 * 1024 * 1024)
        return String(format: "%.2f", gigabytes)
    }

    static func getOSName() -> String {
        return UIDevice.current.systemName
    }

    static func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }

    static func getModel() -> String {
        return UIDevice.current.model
    }

    static func getType() -> String {
        return String(UIDevice.current.userInterfaceIdiom.rawValue)
    }
    
    #if os(iOS)
    static func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }

    static func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }

    static func getScreenOrientation() -> String {
        return String(UIDevice.current.orientation.rawValue)
    }
    #endif
}
#endif

#if os(macOS)
import Foundation
import AppKit
import IOKit.ps

class Device {
    
    public init(){}
    
    static func getModelName() -> String {
        return Host.current().localizedName ?? "Unavailable"
    }
    
    static func getUserName() -> String {
        return NSUserName()
    }
    
    static func getUniqueID() -> String {
        return IOPlatformSerialNumber() ?? "Unavailable"
    }
    
    static func getFreeSpace() -> String {
        let freeSpace = getFileSystemAttribute(.systemFreeSize)
        return formatBytesAsGB(freeSpace) + " GB"
    }

    static func getStorageSize() -> String {
        let totalSpace = getFileSystemAttribute(.systemSize)
        return formatBytesAsGB(totalSpace) + " GB"
    }

    static func getUsedSpace() -> String {
        let totalSpace = getFileSystemAttribute(.systemSize)
        let freeSpace = getFileSystemAttribute(.systemFreeSize)
        let usedSpace = totalSpace - freeSpace
        return formatBytesAsGB(usedSpace) + " GB"
    }

    private static func getFileSystemAttribute(_ attribute: FileAttributeKey) -> Int64 {
        let fileManager = FileManager.default
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
            return (attributes[attribute] as? NSNumber)?.int64Value ?? 0
        } catch {
            cl("Error retrieving file system attribute: \(error)",type:"File Handling")
            return 0
        }
    }

    private static func formatBytesAsGB(_ bytes: Int64) -> String {
        let gigabytes = Double(bytes) / (1024 * 1024 * 1024)
        return String(format: "%.2f", gigabytes)
    }

    static func getOSVersion() -> String {
        return ProcessInfo.processInfo.operatingSystemVersionString
    }

    static func getOSName() -> String {
        return Sysctl.model
    }

    static func getScreenWidth() -> CGFloat {
        return NSScreen.main?.frame.width ?? 0
    }

    static func getScreenHeight() -> CGFloat {
        return NSScreen.main?.frame.height ?? 0
    }

    func getBatteryLevelAsString() -> String? {
        guard let blob = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources: NSArray = IOPSCopyPowerSourcesList(blob)?.takeRetainedValue() else {
            return nil
        }

        for ps in sources {
            guard let info = IOPSGetPowerSourceDescription(blob, ps as CFTypeRef)?.takeUnretainedValue() as? [String: Any] else { continue }
            
            if let type = info[kIOPSTypeKey] as? String, type == kIOPSInternalBatteryType,
               let currentCapacity = info[kIOPSCurrentCapacityKey] as? Int,
               let maxCapacity = info[kIOPSMaxCapacityKey] as? Int {
                let batteryLevel = Int((Double(currentCapacity) / Double(maxCapacity)) * 100)
                return "\(batteryLevel)%"
            }
        }
        
        return nil
    }
    
    private static func IOPlatformSerialNumber() -> String? {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        defer { IOObjectRelease(service) }
        
        guard service != 0 else {
            return nil
        }
        
        return IORegistryEntryCreateCFProperty(service, "IOPlatformSerialNumber" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? String
    }
}

struct Sysctl {
    static var model: String {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        return String(cString: model)
    }
}
#endif
