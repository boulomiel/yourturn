import HistoryActor
import SwiftData
import Foundation

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")


// Your pair:
@Model
final class VisitEntity: SBDomainAccessProtocol {
    var id: UUID
    var domainId: UUID
    var timestamp: TimeInterval

    init(id: UUID, domainId: UUID, timestamp: TimeInterval) {
        self.id = id
        self.domainId = domainId
        self.timestamp = timestamp
    }
 
    nonisolated func toDomainData() -> Visit { Visit(id: domainId, timestamp: timestamp) }
}

struct Visit: SBDomainProtocol {
    let id: UUID
    let timestamp: TimeInterval
    nonisolated func toEntity() -> VisitEntity { .init(id: UUID(), domainId: id, timestamp: timestamp) }
}

// Generates: actor VisitHistoryManager: Observable { ... }
#MakeHistoryManager(VisitEntity.self, domain: Visit.self)

// Then use it:
let history = VisitHistoryManager(modelContainer: container)
try await history.insert(Visit(id: UUID(), timestamp: Date().timeIntervalSince1970))
let visits = try await history.fetch()
