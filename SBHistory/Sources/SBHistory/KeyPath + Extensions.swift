//
//  KeyPath + Extensions.swift
//  SBHistory
//
//  Created by Ruben Mimoun on 01/08/2025.
//

import Foundation
import SwiftData

extension ReferenceWritableKeyPath: @unchecked @retroactive Sendable where Root : SBDomainAccessProtocol & PersistentModel, Value == Date {}


extension PartialKeyPath: @unchecked @retroactive Sendable where Root : SBDomainAccessProtocol & PersistentModel {}

extension PartialKeyPath: @unchecked @retroactive Sendable where Root : PersistentModel {}

