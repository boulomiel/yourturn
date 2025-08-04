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

    @State private var obs: ActivityMapsObs = .init()
    
    var body: some View {
        ScrollView {
            mapView
                .frame(height: 500)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 30 ,bottomTrailingRadius: 30, topTrailingRadius: 0))
                .matchedTransitionSource(id: "map", in: mapNameSpace)
            
            Text("Address")
                .font(.system(size: 25).bold().weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                
            }
            
        }
        .overlay(alignment: .bottom, content: {
            
            
        })
        .ignoresSafeArea(.all, edges: .top)
        .simultaneousGesture(TapGesture(count: 2).onEnded({ _ in
            guard let userLocation = locationManager.userLocation else { return }
            router.presentSheet(.mapZoom(userLocation: userLocation,transitionId: "map", mapSpace: mapNameSpace))
        }))
        .task {
            for await points in obs.asyncLookUpPoints {
                points.forEach {
                    if !lookupPoints.contains($0) {
                        self.lookupPoints.append($0)
                    }
                }
                print(lookupPoints)
            }
        }
    }
    
    private var mapView: some View {
        Map(bounds: .init(minimumDistance: 200, maximumDistance: 500), scope: mapNameSpace) {
            mapBuilder
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.userLocation) { oldValue, newValue in
            switch newValue {
            case .some(let location):
                self.userLocation = .found(location: location)
                self.obs.getLookupPoints(basedOn: location.coordinate.latitude, and: location.coordinate.longitude)
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
            ForEach(lookupPoints, id:\.title) { point in
                Marker(coordinate: .init(latitude: point.coordinates.latitude, longitude: point.coordinates.longitude)) {
                    Label(point.title, systemImage: "house")
                }
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

@Observable
class ActivityMapsObs {
    
    var asyncLookUpPoints: AsyncStream<[NearbyAddress]>
    var continuationLookUpPoints: AsyncStream<[NearbyAddress]>.Continuation
    
    init() {
        (asyncLookUpPoints, continuationLookUpPoints) = AsyncStream.makeStream(of: [NearbyAddress].self)
    }
    
    func getLookupPoints(basedOn currentLatitude: Double, and currentLongitude: Double) {
        let addressInstructions =
            """
            The input will be coordinates.
            Create a list of 5 answers.
            A list must return element such as:
                \(NearbyAddress.example)
            """
        
        let addressModelGenerator: ModelGenerator<[NearbyAddress]> = .init(generationOptions: .init(), instructions: { addressInstructions })
        Task {
            await addressModelGenerator.response(
                to: "Near coordinates such as latitude: \(currentLatitude), longitude: \(currentLongitude)",
                { [weak self] generated  in
                    let lookUpPoints = generated
                        .compactMap {
                            NearbyAddress(
                                title: $0.title ?? "",
                                street: $0.street ?? "",
                                streetNumber: $0.streetNumber ?? "",
                                city: $0.city ?? "",
                                coordinates: .init(
                                    latitude: $0.coordinates?.latitude ?? 0,
                                    longitude: $0.coordinates?.longitude ?? 0
                                )
                            )
                        }
                    
                    await self?.continuationLookUpPoints.yield(lookUpPoints)
                })
        }
    }
}


#Preview(traits: .modifier(ActivityPreviewModifier())) {
    ActivityMapView()
        .preferredColorScheme(.dark)

}
