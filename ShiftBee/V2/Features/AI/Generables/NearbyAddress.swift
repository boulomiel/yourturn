//
//  NearbyAddress.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//

import FoundationModels

@Generable
struct NearbyAddress: Hashable {
    
    @Guide(description: "A title that fits the place, it's name")
    let title: String
    let street: String
    let streetNumber: String
    let city: String
    let coordinates: GeneratedCoordinate
    
    static let example = NearbyAddress(
        title: "Eiffel Tower",
        street: "Champ de Mars",
        streetNumber: "5",
        city: "Paris",
        coordinates: GeneratedCoordinate(
            latitude: 48.8584,
            longitude: 2.2945
        )
    )    
}


//extension NearbyAddress.PartiallyGenerated: Hashable {
//    
//}
