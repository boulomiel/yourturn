//
//  GeneratedAnimal.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 05/08/2025.
//


import SwiftUI
import Playgrounds
import FoundationModels

@Generable
nonisolated struct GeneratedAnimal: Hashable, Sendable {
    
    @Guide(description: "The name of the animal")
    let animal: String
}

@Generable
nonisolated struct GeneratedCity: Hashable {
    
    @Guide(description: "The name of the city")
    let cityName: String
}



struct ActivityAutoFillSelectionField: View {
    
    @State private var text: String = ""
    @State private var generated: [GeneratedCity] = []
    @State private var selectedCity: GeneratedCity?
    let autofill: AutofillField<GeneratedCity> = .init(instructions: """
            Returns a list of 10 elements in alphabetical order.
            The list should be related to the current country : France
        """,
                                                       threshold: 50.0)
    @State var id: UUID = .init()
    
    var body: some View {
        VStack {
            Text("City")
                .font(.system(size: 20).bold().weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Input here", text:  $text)
                .textFieldStyle(.roundedBorder)
            
            VStack {
                ForEach(generated, id: \.self) { generated in
                    let prefix = text
                    let cityName = generated.cityName
                    if !prefix.isEmpty, cityName.lowercased().hasPrefix(prefix.lowercased()) {
                        let start = cityName.startIndex
                        let end = cityName.index(start, offsetBy: prefix.count)
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
                }
            }
            
        }
        .onChange(of: text, { oldValue, newValue in
            if newValue.count < oldValue.count {
                generated = []
            }
            autofill.getAutoFillData(prompt: "Prefix must be \(newValue)") { partialCities in
                partialCities.compactMap { partial in
                    guard let cityName = partial.cityName, cityName.count > 2  else {
                        return nil
                    }
                    return GeneratedCity(cityName: cityName)
                }
                .sorted(by: { $0.cityName.count < $1.cityName.count && $0.cityName < $1.cityName })
            }
            print(generated)
        })
        .task {
            for await value in autofill.asyncValues {
                if generated.count == 10 {
                    generated.removeFirst()
                }
                withAnimation {
                    generated.append(value)
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
    
    let instructions: String
    let threshHold: Double
    var asyncValues: AsyncStream<Generated>
    private var continuation: AsyncStream<Generated>.Continuation
    private var task : Task<Void, Never>?
    
    init(instructions: String, threshold: Double) {
        self.instructions = instructions
        self.threshHold = threshold
        (asyncValues, continuation) = AsyncStream.makeStream(of: Generated.self)
    }
    
    func getAutoFillData(prompt: String,
                         toResult: @escaping ([Generated.PartiallyGenerated]) -> [Generated]) {
        task?.cancel()
        
        let model: ModelGenerator<[Generated]> = .init(generationOptions: .init(), instructions: { instructions })
        task = Task {
            
            var sendSet: Set<Generated> = .init()
            
            do {
                try await Task.sleep(for: .milliseconds(threshHold))
                guard !Task.isCancelled else { return }
                
                try await model.response(
                    to:  prompt,
                    { [weak self] answer  in
                        let toBeSend = toResult(answer)
                        for element in toBeSend {
                            let (inserted, _) = sendSet.insert(element)
                            if inserted {
                                await self?.continuation.yield(element)
                            }
                        }
                    })
            } catch {
                ShiftBeeApp.logger.error("\(#function) - error \(error)")
            }
        }
        
    }
}


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


