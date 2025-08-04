//
//  ActivityMapZoomZelectionView.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//

import SwiftUI
import MapKit

struct ActivityMapZoomZelectionView: View {
    
    @Environment(ShiftBeeLocationManager.self) private var locationManager
    @Environment(NewActivityRouter.self) private var router
    @Namespace private var zoomMapNameSpace

    let userLocation: CLLocation
    
    var body: some View {
        Map(bounds: .init(minimumDistance: 200, maximumDistance: 500), scope: zoomMapNameSpace) {
            mapBuilder
        }
    }
    
    @MapContentBuilder
    private var mapBuilder: some MapContent {
        Marker(coordinate: userLocation.coordinate) {
            Image(systemName: "person")
        }
    }

}
