//
//  YTErrorProtocol.swift
//  YourTurn
//
//  Created by Ruben Mimoun on 05/05/2025.
//

protocol YTPopupProtocol: Equatable {
    
    associatedtype Info: YTInfoPopupProtocol
    associatedtype Fail: YTErrorPopupProtocol
    
    static var idle: Self { get }
    static func info(info: Info) -> Self
    static func error(error: Fail) -> Self
    var description: String  { get }
}

protocol YTErrorPopupProtocol: Equatable {
    var localizedDescription: String { get }
}

protocol YTInfoPopupProtocol: Equatable {
    var localizedDescription: String { get }
}

enum YTPopupState<Info: YTInfoPopupProtocol, Fail: YTErrorPopupProtocol>: Equatable {
    
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
//enum YTErrorPopupState<Fail: YTErrorPopupProtocol> {
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
