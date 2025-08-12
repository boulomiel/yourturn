//
//  GeneratedAnimal.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 05/08/2025.
//

import OSLog
import SwiftUI
import Playgrounds
import FoundationModels

@Generable
nonisolated struct GeneratedCity: Hashable {
    
    @Guide(description: "The name of the city")
    let cityName: String
}



struct ActivityAutoFillSelectionField: View {
    
    @State private var text: String = ""
    @State private var generated: [GeneratedCity] = []
    @State private var selectedCity: GeneratedCity?
    let autofill: AutofillField<GeneratedCity> = .init(
        instructions: """
            Returns a list of 5 elements in alphabetical order.
            The list should be related to the current country: France
        """,
        threshold: 200.0
    )
    @State var id: UUID = .init()
    
    var body: some View {
        Section(content: {
                VStack {
                    ForEach(generated, id: \.cityName) { generated in
                        let prefix = text
                        let cityName = generated.cityName
                        if !prefix.isEmpty, cityName.lowercased().hasPrefix(prefix.lowercased()) {
                            let start = cityName.startIndex
                            let end = cityName.index(start, offsetBy: prefix.count)
                            if start < end {
                                let boldPart = String(cityName[start..<end])
                                let rest = String(cityName[end...])
                                let markdown: LocalizedStringKey = "**\(boldPart)**\(rest)"
                                
                                Text(markdown)
                                    .font(.body)
                                    .frame(maxWidth: .infinity, maxHeight: 20, alignment: .leading)
                            } else {
                                Text(cityName)
                                    .font(.body)
                                    .frame(maxWidth: .infinity, maxHeight: 20, alignment: .leading)
                            }
                            
                        } else {
                            Text(cityName)
                                .font(.body)
                                .frame(maxWidth: .infinity, maxHeight: 20, alignment: .leading)
                        }
                    }
                }
                
            
        }, header: {
            Text("City")
                .font(.system(size: 20).bold().weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Input here", text:  $text)
                .textFieldStyle(.roundedBorder)
        })
        .onChange(of: text) { oldValue, newValue in
            if newValue.isEmpty {
                generated = []
                autofill.clean()
                return
            }
            autofill.getAutoFillData(input: newValue) { partialCities in
                 let mapped = partialCities.content.compactMap { partial -> GeneratedCity? in
                    guard let cityName = partial.cityName, cityName.count > 2  else {
                        return nil
                    }
                    return GeneratedCity(cityName: cityName)
                }
                .filter { $0.cityName.localizedCaseInsensitiveContains(newValue) && $0.cityName.hasPrefix(newValue) }
                .filter { $0.generatedContent.isComplete }
                
                return Array(Set(mapped)).sorted(by: { $0.cityName < $1.cityName })
            }
        }
        .task(id: text) {
            for await value in autofill.asyncValues {
                withAnimation {
                    switch value {
                    case .success(let success):
                        generated.append(success)
                    case .failure:
                        generated = []
                    }
                }
            }
        }
    }
}


#Preview {
    ActivityAutoFillSelectionField()
        .preferredColorScheme(.dark)
}

class AutofillField<Generated: Hashable & Generable & Sendable> {
    
    enum AutofillFieldError: LocalizedError {
        case cancel
        case empty
    }
    
    let instructions: String
    let threshHold: Double
    let model: ModelGenerator<[Generated]>
    let maxElement: Int
    var asyncValues: AsyncStream<Result<Generated, AutofillFieldError>>
    private var continuation: AsyncStream<Result<Generated, AutofillFieldError>>.Continuation
    private var task : Task<Void, Never>?
    
    init(instructions: String, threshold: Double, maxElement: Int = 10) {
        self.instructions = instructions
        self.threshHold = threshold
        (asyncValues, continuation) = AsyncStream.makeStream(of: Result<Generated, AutofillFieldError>.self)
        self.model = .init(generationOptions: .init(), instructions: { instructions })
        self.maxElement = maxElement
    }
    
    var currentInput = ""

    func getAutoFillData(input: String,
                         toResult: @escaping (ModelGenerator<[Generated]>.Snapshot) -> [Generated]) {
        
        let prompt = "Prefix must be \(input) and the results list must ordered."
        clean()
        task = Task {
            currentInput = input
            var sendSet: Set<Generated> = .init()
            sendSet.reserveCapacity(maxElement)
            
            do {
                try await Task.sleep(for: .milliseconds(threshHold))
                try Task.checkCancellation()
                try await model.response(
                    to:  prompt,
                    { [weak self] answer  in
                        let toBeSend = toResult(answer)
                        for element in toBeSend {
                            let (inserted, e) = sendSet.insert(element)
                            if inserted {
                                self?.continuation.yield(.success(e))
                            }
                        }
                    })
            } catch {
                sendSet = .init(minimumCapacity: maxElement)
                ShiftBeeApp.logger.error("\(#function) - error \(error)")
                continuation.yield(.failure(.cancel))
            }
        }
    }
    
    func clean() {
        task?.cancel()
//        continuation.yield(.failure(.cancel))
    }
}


//@Generable
//nonisolated struct GeneratedAnimal: Hashable, Sendable {
//    
//    @Guide(description: "The name of the animal")
//    let animal: String
//}

//#Playground {
//
//    let autofilled: AutofillField<[GeneratedAnimal]> = .init(instructions: "Create a list", threshold: 100.0)
//    autofilled.getAutoFillData(prompt: "5 different animals, which names starts by the letter A") { result in
//        result.compactMap(\.animal).map {
//            GeneratedAnimal(animal: $0)
//        }
//    }
//
//    Task {
//        for await value in autofilled.asyncValues {
//            print(value)
//        }
//    }
//}

///PartiallyGenerated(
///id: FoundationModels.GenerationID(value: "4BCBC48C-BAF5-4DF4-9013-547FFFFE0839[4]"),
///name: Optional("Albatross")
///)


