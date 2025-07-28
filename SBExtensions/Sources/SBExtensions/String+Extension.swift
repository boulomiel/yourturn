//
//  String+Extension.swift
//  ShiftBee
//
//  Created by Ruben Mimoun on 27/07/2025.
//

#if os(iOS)
import UIKit
public typealias PlatformFont = UIFont
#elseif os(macOS)
import AppKit
public typealias PlatformFont = NSFont
#endif


public extension String {
     
    func textWidth(with labelsAttributes: [NSAttributedString.Key: Any]? = [.font: PlatformFont.systemFont(ofSize: 14)]) -> CGFloat {
        (self as NSString).size(withAttributes: labelsAttributes).width
    }
}
