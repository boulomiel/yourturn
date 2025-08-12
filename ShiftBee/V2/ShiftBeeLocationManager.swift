//
//  ShiftBeeLocationManager.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//

import OSLog
import CoreLocation

@Observable
class ShiftBeeLocationManager: NSObject {
    
    enum Permission {
        case authorized, unauthorized, denied
    }
    
    var userLocation: CLLocation?
    var permission: Permission = .unauthorized
    
    private var didRequestLocation: Bool = false
    private let locationManager: CLLocationManager
    private var canRequestLocation: () -> Void = { }
    
    override init() {
        locationManager = .init()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    /// If the location permission has been given locationManager(didChangeAuthorization:) will request the current location
    func requestLocation() {
        didRequestLocation = true
        locationManager.requestWhenInUseAuthorization()
        if permission == .authorized {
            locationManager.requestLocation()
        }
    }
}

extension ShiftBeeLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        ShiftBeeApp.logger.info("\(#function)")
        guard didRequestLocation, let userLocation = locations.first else {
            return
        }
        self.userLocation = userLocation
        self.didRequestLocation = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        ShiftBeeApp.logger.error("\(#function) - \(error)")
    }
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            permission = .unauthorized
        case .denied:
            permission = .denied
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            fallthrough
        case .authorized:
            permission = .authorized
        @unknown default:
            fatalError("Unknown status detected for location authorization: \(status)")
        }
    }
}
