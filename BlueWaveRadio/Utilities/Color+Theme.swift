//
//  Color+Theme.swift
//  Blue Wave Radio Roatan
//
//  Theme color extensions
//

import SwiftUI

extension Color {
    // Primary theme colors
    static let primaryBlue = Color(red: 0/255, green: 51/255, blue: 102/255) // #003366
    static let accentTurquoise = Color(red: 0/255, green: 191/255, blue: 255/255) // #00BFFF
    static let neutralSand = Color(red: 245/255, green: 245/255, blue: 220/255) // #F5F5DC

    // Semantic colors
    static let stationPrimary = primaryBlue
    static let stationAccent = accentTurquoise
    static let stationBackground = neutralSand
}

extension UIColor {
    // Primary theme colors for UIKit components
    static let primaryBlue = UIColor(red: 0/255, green: 51/255, blue: 102/255, alpha: 1.0)
    static let accentTurquoise = UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1.0)
}
