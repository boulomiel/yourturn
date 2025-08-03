//
//  ActivityFormHeaders.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 03/08/2025.
//

import SwiftUI

enum ActivityFormHeaders {
    case title
    case description
    case dateAndTime
    case location
    
    var title: String {
        switch self {
        case .title:
            "Title"
        case .description:
            "Description"
        case .dateAndTime:
            "Date & Time"
        case .location:
            "Location"
        }
    }
    
    var subtitle: String {
        switch self {
        case .title:
            "Something short and clear"
        case .description:
            "Useful additional informations or tips"
        case .dateAndTime:
            "When should it happen ?"
        case .location:
            "Where is it happening ?"
        }
    }
    
    var view: some View {
        Header(title, subtitle: subtitle)
    }
    
    func Header(_ title: String, subtitle: String) -> some View {
        VStack {
            TitleView(title)
            SubTitleView(subtitle)
        }
    }
    
    func TitleView(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 20).bold().weight(.heavy))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func SubTitleView(_ subTitle: String) -> some View {
        Text(subTitle)
            .font(.system(size: 16).bold().weight(.regular))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


