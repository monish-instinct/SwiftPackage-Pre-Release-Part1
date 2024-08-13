//
//  EngineStarter.swift
//  DevOps
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 01/03/24.
//

import Foundation

class RaghulsNeuralEngineStarter: ObservableObject {
    private var updateTimer: Timer?

    init() {
        _ = GPS.shared
        GPS.setAddress()
        Network.updatePublicIP()
        Network.updateAdress()
        Security.generateDeviceSpecificSecretHash()
        ServerSecurity.generateServerSpecificSecretHash()
        deviceDetails.createBasicTables()
        deviceDetails.executeRandomNetworkAPIFunction(condition: "false")
        
        // Start the timer to call functions every 5 minutes
        startPeriodicUpdates()
    }

    private func startPeriodicUpdates() {
        // Immediately call the functions once during initialization
        performPeriodicUpdates()
        
        // Schedule the timer for every 5 minutes (300 seconds)
        updateTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(performPeriodicUpdates), userInfo: nil, repeats: true)
    }

    private func stopPeriodicUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }

    @objc private func performPeriodicUpdates() {
                
                clSync("IP data updated successfully at \(Clock.get(format: "yyyy-MM-dd HH:mm:ss"))")
        GPS.setAddress()
        Network.updatePublicIP()
        Network.updateAdress()
    }

    deinit {
        stopPeriodicUpdates()
    }
}
