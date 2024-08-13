//
//  GPS.swift
//  SystemInfo
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 02/01/24.
//

import CoreLocation

class GPS: NSObject, CLLocationManagerDelegate {
    static let shared = GPS() // Singleton instance
    private let locationManager = CLLocationManager()
    private static var currentLocation: CLLocation?
    static var fullAddress: String = "Address not set"

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Call this method to start the location services process
    static func initializeLocationServices() {
        let status = GPS.getLocationPermissionStatus()
        if status == "Not Determined" {
            shared.locationManager.requestWhenInUseAuthorization() // Or requestAlwaysAuthorization()
        } else {
            shared.locationManager.startUpdatingLocation()
        }
    }
    
    static func getLatitude() -> Double {
        return currentLocation?.coordinate.latitude ?? 0.0
    }
    
    static func getLongitude() -> Double {
        return currentLocation?.coordinate.longitude ?? 0.0
    }
    
    static func getAltitude() -> Double {
        // Ensure altitude is valid
        if let altitude = currentLocation?.altitude, currentLocation?.verticalAccuracy ?? 0 > 0 {
            return altitude
        } else {
            return 0.0 // Or consider returning nil or an error if altitude data is expected to be valid
        }
    }
    
    static func setAddress(completion: (() -> Void)? = nil) {
        guard let location = currentLocation else {
            fullAddress = "Location not available"
            completion?()
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                fullAddress = "Error finding address: \(error?.localizedDescription ?? "Unknown error")"
                completion?()
                return
            }
            
            let addressArray = [placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.country].compactMap { $0 }
            fullAddress = addressArray.joined(separator: ", ")
            completion?()
        }
    }

    // New getAddress function to return the value of the fullAddress variable
    static func getAddress() -> String {
        return fullAddress
    }

    static func getLocationPermissionStatus() -> String {
        let manager = CLLocationManager()
        switch manager.authorizationStatus {
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Authorized Always"
        case .authorizedWhenInUse: return "Authorized When In Use"
        @unknown default: return "Unknown"
        }
    }
    
    static func getAccuracy() -> Double {
        guard let location = currentLocation else {
            // You might want to handle this differently, perhaps returning nil to indicate no location.
            return -1
        }
        return location.horizontalAccuracy
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        GPS.currentLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        clSync("Failed to find user's location: \(error.localizedDescription)")
    }
    
    #if os(iOS) || os(macOS)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            clSync("Location access denied or restricted")
        case .authorizedAlways, .authorizedWhenInUse:
            clSync("Location access granted")
            locationManager.startUpdatingLocation()
        default:
            clSync("Unhandled authorization status")
        }
    }
    #endif
}


class stateGPS: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var location: String = "Location not available"
    @Published var address: String = "Address not available" // Add this line to store the address
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = "Lat: \(location.coordinate.latitude), Lon: \(location.coordinate.longitude), Alt: \(location.altitude) meter"
            // Reverse Geocoding
            reverseGeocodeLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        clSync(error)
    }
    
    private func reverseGeocodeLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                self.address = "Error finding address: \(error.localizedDescription)"
                return
            }
            if let placemark = placemarks?.first {
                self.address = [placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.country].compactMap { $0 }.joined(separator: ", ")
                GPS.fullAddress = self.address
            }
        }
    }
}
