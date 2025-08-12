//
//  ActivityMapsObs.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 05/08/2025.
//

import OSLog
import FoundationModels
import SwiftUI

@MainActor
class ActivityMapsObs {
    
    var asyncLookUpPoints: AsyncStream<NearbyAddress>
    var continuationLookUpPoints: AsyncStream<NearbyAddress>.Continuation
    
    var asyncCities: AsyncStream<String>
    var continuationCities: AsyncStream<String>.Continuation
    
    var cityTask : Task<Void, Never>?
    
    init() {
        (asyncLookUpPoints, continuationLookUpPoints) = AsyncStream.makeStream(of: NearbyAddress.self)
        (asyncCities, continuationCities) = AsyncStream.makeStream(of: String.self)
    }
    
    func getCities(basedOn currentLatitude: Double, and currentLongitude: Double, and input: String) {
        cityTask?.cancel()
        let addressInstructions =
                    """
                    The input will be coordinates, and the prefix of the city's name.
                    Create a list of 5 possible answers.
                    A list must return element such as:
                    \(NearbyCity.example)
                    """
        
        let addressModelGenerator: ModelGenerator<[NearbyCity]> = .init(generationOptions: .init(), instructions: { addressInstructions })

        cityTask = Task {
            var setCities: Set<String> = .init()
            do {
                for try await snapshot in addressModelGenerator.stream where !snapshot.content.isEmpty {
                    let cities = snapshot.content
                    cities.compactMap(\.title).filter { !$0.isEmpty }.forEach { cityName in
                        let (isInserted, city) = setCities.insert(cityName)
                        if isInserted {
                            self.continuationCities.yield(city)
                        }
                    }
                }
                try await addressModelGenerator.responseStream(to: "Near coordinates such as latitude: \(currentLatitude), longitude: \(currentLongitude). With name starts by \(input)")
            } catch {
                ShiftBeeApp.logger.error("for addressModelGenerator.response() - error \(error)")
            }
        }
        
//        cityTask = Task {
//            var setCities: Set<String> = .init()
//            var sentCities: Set<String> = .init()
//            
//            do {
//                try await Task.sleep(for: .milliseconds(300))
//                guard !Task.isCancelled else { return }
//                
//                try await addressModelGenerator.response(
//                    to:  "Near coordinates such as latitude: \(currentLatitude), longitude: \(currentLongitude). With name starts by \(input)",
//                    { [weak self] generated  in
//                        let cities = generated
//                        cities.content.compactMap(\.title).filter { !$0.isEmpty }.forEach { cityName in
//                            setCities.insert(cityName)
//                        }
//                        print(setCities)
//                        let citySorted = Array(setCities).sorted()
//                        
//                        for city in citySorted {
//                            let (inserted, _) = sentCities.insert(city)
//                            if inserted {
//                                self?.continuationCities.yield(city)
//                            }
//                        }
//                    })
//            } catch {
//                ShiftBeeApp.logger.error("for addressModelGenerator.response() - error \(error)")
//            }
//        }
        
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
            do {
                try await addressModelGenerator.response(
                    to: "Near coordinates such as latitude: \(currentLatitude), longitude: \(currentLongitude)",
                    { [weak self] generated  in
                        let lookUpPoints = generated
                            .content
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
                            .sorted(by: { $0.title < $1.title })
                        
                        for address in lookUpPoints {
                            self?.continuationLookUpPoints.yield(address)
                        }
                    })
            } catch {
                ShiftBeeApp.logger.error("for addressModelGenerator.response() - error \(error)")
            }
        }
    }
    
    func getLookupPoints(basedOn currentLatitude: Double, and currentLongitude: Double) async -> [NearbyAddress] {
        let addressInstructions =
            """
            The input will be coordinates.
            Create a list of 5 answers.
            A list must return element such as:
                \(NearbyAddress.example)
            """
        
        let addressModelGenerator: ModelGenerator<[NearbyAddress]> = .init(generationOptions: .init(), instructions: { addressInstructions })
        do {
            return try await addressModelGenerator.response(to: "Near coordinates such as latitude: \(currentLatitude), longitude: \(currentLongitude)")
        } catch {
            ShiftBeeApp.logger.error("for addressModelGenerator.response() - error \(error)")
            return []
        }
    }
}

