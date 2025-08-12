//
//  HistoryPlugin.swift
//  HistoryActor
//
//  Created by Ruben Mimoun on 12/08/2025.
//


// HistoryPlugin/MakeHistoryManagerMacro.swift
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftDiagnostics
import SwiftCompilerPlugin
import SwiftSyntaxMacros
import Foundation

@main
struct HistoryPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    MakeHistoryManagerMacro.self
  ]
}

public struct MakeHistoryManagerMacro: DeclarationMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {

    // Parse args: MakeHistoryManager(Entity.self, domain: Domain.self, managerName: "CustomName")
    func typeName(from expr: ExprSyntax) -> String? {
      if let member = expr.as(MemberAccessExprSyntax.self),
         let base = member.base?.description.trimmingCharacters(in: .whitespacesAndNewlines),
         member.declName.baseName.text == "self" {
        return base
      }
      return nil
    }

    let args = node.arguments
    guard args.count >= 2,
          let entityExpr = args.first?.expression,
          let domainLabelArg = args.dropFirst().first(where: { $0.label?.text == "domain" })?.expression,
          let entityName = typeName(from: entityExpr),
          let domainName = typeName(from: domainLabelArg) else {
      return []
    }

    let overrideNameArg = args.first(where: { $0.label?.text == "managerName" })?.expression
    let managerName: String
    if let stringLit = overrideNameArg?.as(StringLiteralExprSyntax.self)?.segments.first?.description.replacingOccurrences(of: "\"", with: "") {
      managerName = stringLit
    } else {
      managerName = "\(entityName)HistoryManager"
    }

    // Generate actor code
    let decl = DeclSyntax(stringLiteral:
"""
@ModelActor
public actor \(managerName): Observable {

    public init() {}

    // MARK: Insert
    public func insert(_ domain: \(domainName)) throws where \(domainName).ID == UUID {
        modelContext.insert(domain.toEntity())
        postLastInserted(model: domain)
        try modelContext.save()
    }

    // MARK: Remove by Domain
    public func remove(_ domain: \(domainName)) throws where \(domainName).ID == UUID, \(domainName).SBHistoryEntity: PersistentModel {
        let domainId = domain.id
        try modelContext.delete(model: \(domainName).SBHistoryEntity.self, where: #Predicate { $0.domainId == domainId })
        try modelContext.save()
    }

    // MARK: Remove by id
    public func remove(by id: UUID) throws {
        try modelContext.delete(model: \(entityName).self, where: #Predicate { $0.id == id })
        try modelContext.save()
    }

    // MARK: Fetch (Domain) — prefer returning Sendable Domain over raw model
    public func fetch(
        predicate: Predicate<\(entityName)>? = nil,
        sort: [SortDescriptor<\(entityName)>]? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        propertiesToFetch: [PartialKeyPath<\(entityName)>] = []
    ) throws -> [\(domainName)] {
        var fd = FetchDescriptor(predicate: predicate, sortBy: sort ?? [])
        fd.fetchLimit = limit
        fd.fetchOffset = offset
        fd.propertiesToFetch = propertiesToFetch
        return try modelContext.fetch(fd).map { $0.toDomainData() }
    }

    // MARK: Fetch count
    public func fetchCount(
        _ predicate: Predicate<\(entityName)>? = nil,
        sort: [SortDescriptor<\(entityName)>] = []
    ) throws -> Int {
        let fd = FetchDescriptor<\(entityName)>(predicate: predicate, sortBy: sort)
        return try modelContext.fetchCount(fd)
    }

    // MARK: Save
    public func save() throws {
        try modelContext.save()
    }

    // MARK: Update
    public func update(_ body: () -> (any PersistentModel & SBDomainAccessProtocol)) throws {
        _ = body() // side-effects should mutate a model in the context
        try modelContext.save()
    }

    // MARK: Notification helper
    private func postLastInserted(model: \(domainName)) where \(domainName).ID == UUID {
        let lastMessage = LastInsertedMessage(type: \(domainName).self, id: model.id, lastItemTimestamp: model.timestamp)
        if #available(iOS 26.0, *), #available(macOS 26.0, *) {
            NotificationCenter.default.post(lastMessage, subject: self)
        }
    }

    public struct LastInsertedMessage<Domain>: NotificationCenter.AsyncMessage {
        public typealias Subject = \(managerName)

        public let type: Domain.Type
        public let id: UUID
        public let lastItemTimestamp: TimeInterval

        public static var name: Notification.Name {
            .init(rawValue: "SBHistory.LastInsertedMessage")
        }

        public static func makeNotification(_ message: \(managerName).LastInsertedMessage<Domain>) -> Notification {
            .init(name: name, object: self, userInfo: ["id": message.id, "type": message.type, "lastItemTimestamp": message.lastItemTimestamp])
        }

        public static func makeMessage(_ notification: Notification) -> \(managerName).LastInsertedMessage<Domain>? {
            guard let userInfo = notification.userInfo,
                  let id = userInfo["id"] as? UUID,
                  let type = userInfo["type"] as? Domain.Type,
                  let lastItemTimestamp = userInfo["lastItemTimestamp"] as? TimeInterval else {
                return nil
            }
            return .init(type: type, id: id, lastItemTimestamp: lastItemTimestamp)
        }
    }
}
""")

    return [decl]
  }
}
