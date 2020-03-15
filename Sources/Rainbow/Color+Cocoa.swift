//
//  File.swift
//  
//
//  Created by jinxiangqiu on 15/3/2020.
//

#if canImport(AppKit)
import AppKit

public extension Color {
    
    func toNSColor() -> NSColor {
        return NSColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }
    
    static func fromNSColor(_ ns: NSColor) -> Color {
        return Color(r: Double(ns.redComponent), g: Double(ns.greenComponent), b: Double(ns.blueComponent), a: Double(ns.alphaComponent))
    }
}

#endif

#if canImport(UIKit)
import UIKit

public extension Color {
    
    func toUIColor() -> UIColor {
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }
    
    static func fromUIColor(_ ui: UIColor) -> Color {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        return Color(r: Double(r), g: Double(g), b: Double(b), a: Double(a))
    }
}
#endif
