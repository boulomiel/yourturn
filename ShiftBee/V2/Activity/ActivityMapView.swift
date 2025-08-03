//
//  ActivityMapView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//

import MapKit
import SwiftUI

struct ActivityMapView: View {
    
    enum UserLocationState {
        case found(location: CLLocation)
        case notFound
    }
    
    @Environment(ShiftBeeLocationManager.self) private var locationManager
    @Environment(NewActivityRouter.self) private var router

    @State private var userLocation: UserLocationState = .notFound
    
    var body: some View {
        Map {
            mapBuilder
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.userLocation) { oldValue, newValue in
            switch newValue {
            case .some(let location):
                self.userLocation = .found(location: location)
            case .none:
                self.userLocation = .notFound
            }
        }
    }
    
    @MapContentBuilder
    private var mapBuilder: some MapContent {
        switch userLocation {
        case .found(let location):
            Marker(coordinate: location.coordinate) {
                Image(systemName: "person")
            }
        case .notFound:
            Annotation(item: .forCurrentLocation()) {
                Text("Could not find user \nPlease check the app permissions")
                    .font(.title)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
}
