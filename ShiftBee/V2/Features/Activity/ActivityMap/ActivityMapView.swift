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
    @Namespace private var mapNameSpace

    @State private var userLocation: UserLocationState = .notFound
    @State private var addressField: String = ""
    @State var lookupPoints: [NearbyAddress] = []

    private let obs: ActivityMapsObs = .init()
    @State private var city: NearbyCity?
    @State private var cityField: String = ""
    @State private var cities: [NearbyCity] = []

    
    var body: some View {
        ScrollView {
            ActivityLocationMapView()
                .frame(height: 500)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 30 ,bottomTrailingRadius: 30, topTrailingRadius: 0))
                .matchedTransitionSource(id: "map", in: mapNameSpace)
            
            Text("Address")
                .font(.system(size: 25).bold().weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Section {
                ForEach(cities, id: \.self) { city in
                    Text(city.title)
                        .font(.system(size: 16).bold().weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } header: {
                VStack {
                    Text("City")
                        .font(.system(size: 20).bold().weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Input here", text:  $cityField)
                        .textFieldStyle(.roundedBorder)
                }
            }
            
        }
        .overlay(alignment: .bottom, content: {
            
            
        })
        .onChange(of: cityField, { oldValue, newValue in
            if oldValue.count < newValue.count {
                self.cities = []
            }
            guard !newValue.isEmpty,
                case let .found(location) = userLocation else { return }
                self.obs.getCities(basedOn: location.coordinate.latitude,
                                                     and: location.coordinate.longitude,
                                                     and: newValue)
            
        })
        .ignoresSafeArea(.keyboard, edges: .top)
        .simultaneousGesture(TapGesture(count: 2).onEnded({ _ in
            guard let userLocation = locationManager.userLocation else { return }
        //    router.presentSheet(.mapZoom(userLocation: userLocation,transitionId: "map", mapSpace: mapNameSpace))
        }))
        .task {
            for await city in obs.asyncCities {
                self.cities.append(.init(title: city, coordinates: .init(latitude: 0.0, longitude: 0.0)))
            }
        }
    }
}

struct ActivityLocationMapView: View {
    
    @Environment(ShiftBeeLocationManager.self) private var locationManager
    @Namespace private var mapNameSpace
    @State private var userLocation: ActivityMapView.UserLocationState = .notFound
    
    var body: some View {
        mapView
    }
    
    private var mapView: some View {
        Map(bounds: .init(minimumDistance: 500, maximumDistance: 1000), scope: mapNameSpace) {
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

//
//#Preview(traits: .modifier(ActivityPreviewModifier())) {
//    ActivityMapView()
//        .preferredColorScheme(.dark)
//
//}
