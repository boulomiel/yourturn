//
//  ModelGenerator.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//

import SwiftUI
import FoundationModels
import Playgrounds

struct ModelGenerator<Generated: Generable & Sendable> {
    
    private let generationOptions: GenerationOptions
    private let session: LanguageModelSession
    
    init(generationOptions: GenerationOptions, @InstructionsBuilder instructions: () -> Instructions) {
        self.generationOptions = generationOptions
        self.session = .init(instructions: instructions)
    }
    
    @concurrent
    func response(to prompt: String, _ result: sending @escaping (Generated.PartiallyGenerated) async -> Void) async {
        do {
            let response = session.streamResponse(to: prompt, generating: Generated.self, includeSchemaInPrompt: true, options: generationOptions)
            for try await answer in response {
                await result(answer)
            }
        } catch {
            ShiftBeeApp.logger.error("\(#function) - \(error)")
        }
    }
    
    @concurrent
    func response(to prompt: String) async -> [Generated] {
        do {
 //           let response = session.response
//            for try await answer in response {
//                await result(answer)
//            }
        } catch {
            ShiftBeeApp.logger.error("\(#function) - \(error)")
        }
        return []
    }
    
}


#Playground {
    
    let cityInstructions =
        """
        The input will be a city name only.
        Create a list of 5 answers.
        A list must return eleement such as:
            \(NearbyCity.example)
        """
    
    let generationOptions: GenerationOptions = .init(
        maximumResponseTokens: 800
    )
    
    let cityModelGenerator: ModelGenerator<[NearbyCity]> = .init(generationOptions: generationOptions, instructions: { cityInstructions })
    
    Task {
        await cityModelGenerator.response(to: "Near Paris", { generated  in
            _ = generated
        })
    }
    
    let addressInstructions =
        """
        The input will be coordinates.
        Create a list of 5 answers.
        A list must return element such as:
            \(NearbyAddress.example)
        """
    
    let addressModelGenerator: ModelGenerator<[NearbyAddress]> = .init(generationOptions: generationOptions, instructions: { addressInstructions })
    
    Task {
        await addressModelGenerator.response(to: "Near coordinates such as latitude: \(48.8606), longitude: \(2.2976)", { generated  in
            _ = generated
        })
    }
    
}
