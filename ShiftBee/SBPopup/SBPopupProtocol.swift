//
//  SBErrorProtocol.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

protocol SBPopupProtocol: Equatable {
    
    associatedtype Info: SBInfoPopupProtocol
    associatedtype Fail: SBErrorPopupProtocol
    
    static var idle: Self { get }
    static func info(info: Info) -> Self
    static func error(error: Fail) -> Self
    var description: String  { get }
}

protocol SBErrorPopupProtocol: Equatable {
    var localizedDescription: String { get }
}

protocol SBInfoPopupProtocol: Equatable {
    var localizedDescription: String { get }
}

enum SBPopupState<Info: SBInfoPopupProtocol, Fail: SBErrorPopupProtocol>: Equatable {
    
    case idle
    case info(info: Info)
    case error(error: Fail)
    
    var description: String {
        switch self {
        case .idle:
            ""
        case .error(let error):
            error.localizedDescription
        case .info(info: let info):
            info.localizedDescription
        }
    }
}

//
//enum SBErrorPopupState<Fail: SBErrorPopupProtocol> {
//    
//    case idle
//    case error(error: Fail)
//    
//    var description: String {
//        switch self {
//        case .idle:
//            ""
//        case .error(let error):
//            error.localizedDescription
//        }
//    }
//}
