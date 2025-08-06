//
//  NearbyCity.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//


import FoundationModels

@Generable
struct NearbyCity: Hashable {
    
    @Guide(description: "The name of the city.")
    let title: String
    
    @Guide(description: "Coordinates of the city matching it's center.")
    let coordinates: GeneratedCoordinate
    
    static let example: NearbyCity = .init(
        title: "Nogent-sur-Marne",
        coordinates: .init(latitude: 48.8375, longitude: 2.4833)
    )
}
