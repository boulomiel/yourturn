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
    
    public typealias Snapshot = LanguageModelSession.ResponseStream<Generated>.Snapshot
    private let generationOptions: GenerationOptions
    nonisolated private let session: LanguageModelSession
    let stream: AsyncStream<Snapshot>
    nonisolated let continuation: AsyncStream<Snapshot>.Continuation
    
    init(generationOptions: GenerationOptions, @InstructionsBuilder instructions: () -> Instructions) {
        self.generationOptions = generationOptions
        self.session = .init(instructions: instructions)
        self.session.prewarm()
        (stream, continuation) = AsyncStream.makeStream(of: Snapshot.self)
    }
    
    @concurrent
    func response(to prompt: String, _ result: @escaping @MainActor (sending Snapshot) -> Void) async throws {
        let response = session.streamResponse(to: prompt, generating: Generated.self, includeSchemaInPrompt: true, options: generationOptions)
        guard !Task.isCancelled else { return }
        for try await answer in response {
            await result(answer)
        }
    }
    
    @concurrent
    func responseStream(to prompt: String) async throws {
        let response = session.streamResponse(to: prompt, generating: Generated.self, includeSchemaInPrompt: true, options: generationOptions)
        for try await answer in response {
            continuation.yield(answer)
        }
    }
    
    @concurrent
    func response(to prompt: String) async throws -> Generated {
        let response = try await session.respond(to: prompt, generating: Generated.self, includeSchemaInPrompt: true, options: generationOptions)
        return response.content
    }
}

extension LanguageModelSession.ResponseStream.Snapshot: @retroactive @unchecked Sendable {
    
}

//#Playground {
//    
//    let cityInstructions =
//        """
//        The input will be a city name only.
//        Create a list of 5 answers.
//        A list must return eleement such as:
//            \(NearbyCity.example)
//        """
//    
//    let generationOptions: GenerationOptions = .init(
//        maximumResponseTokens: 800
//    )
//    
////    let cityModelGenerator: ModelGenerator<[NearbyCity]> = .init(generationOptions: generationOptions, instructions: { cityInstructions })
////    
////    Task {
////        try await cityModelGenerator.response(to: "Near Paris", { generated  in
////        })
////    }
//    
//    let addressInstructions =
//        """
//        The input will be coordinates.
//        Create a list of 5 answers.
//        A list must return element such as:
//            \(NearbyAddress.example)
//        """
//    
//    let addressModelGenerator: ModelGenerator<[NearbyAddress]> = .init(generationOptions: generationOptions, instructions: { addressInstructions })
//    
////    Task {
////        try await addressModelGenerator.response(to: "Near coordinates such as latitude: \(48.8606), longitude: \(2.2976)", { generated  in
////            _ = generated
////            generated.compactMap(\.city)
////        })
////    }
//    
//    Task {
//      //  let stream = try await addressModelGenerator.responseStream(to: "Near coordinates such as latitude: \(48.8606), longitude: \(2.2976)")
//    }
//    
//}

