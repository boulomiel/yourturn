//
//  DragAndDropModifier.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 11/05/2025.
//

import SwiftUI

protocol DraggableItemProtocol: NSItemProviderWriting, NSItemProviderReading {
    var dragID: UUID { get }
    static var dragIdentifier: String { get }
}

extension View {
    func draggable<T: DraggableItemProtocol>(_ data: T) -> some View {
        modifier(DragAndDropModifier(data: data))
    }
}

struct DragAndDropModifier<Dragged: DraggableItemProtocol>: ViewModifier {
    
    let data: Dragged
    @State private var focusID: UUID?
    
    func body(content: Content) -> some View {
        content
            .onDrag {
                NSItemProvider(object: data)
            }
            .onDrop(of: [Dragged.dragIdentifier], delegate: DragAndDropDelegate<Dragged>(focusId: $focusID))
    }
}

struct DragAndDropDelegate<Item: DraggableItemProtocol>: DropDelegate {
    
    @Binding var focusId: UUID?
    
    func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: [Item.dragIdentifier]) else {
            print("false")
            return false
        }
        
        let itemProviders = info.itemProviders(for: [Item.dragIdentifier])
        guard let itemProvider = itemProviders.first else {
            print("itemProvider","false")
            return false
        }
        itemProvider.loadObject(ofClass: Item.self) { dragItem, _ in
            let dragItem = dragItem as? Item
            let id = dragItem?.dragID
            Task { @MainActor in
                self.focusId = id
            }
        }
        return true
    }
}

fileprivate class TodoItem: NSObject, Codable, DraggableItemProtocol {
    var dragID: UUID = .init()
    
    static let dragIdentifier: String = "com.preview.todoitem"
    
    nonisolated(unsafe) static var writableTypeIdentifiersForItemProvider: [String] = [dragIdentifier]
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, (any Error)?) -> Void) -> Progress? {
        do {
            let encoded = try JSONEncoder().encode(self)
            completionHandler(encoded, nil)
        } catch {
            completionHandler(nil, error)
        }
        return nil
    }
    
    nonisolated(unsafe) static var readableTypeIdentifiersForItemProvider: [String] = [dragIdentifier]
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

#Preview(body: {
    @Previewable @State var items: [TodoItem] = [
        .init(name: "Buy milk"),
        .init(name: "Learn Swift"),
        .init(name: "Go for a walk")
    ]
    
    List(items, id: \.dragID) { item in
        Text(item.name)
            .draggable(item)
        
    }
})
