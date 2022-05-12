//
//  ColorName.swift
//  MyKalla
//
//  Created by Hafshy Yazid Albisthami on 12/05/22.
//

import Foundation

// MARK: - ColorName
struct ColorName: Codable {
    let name: Name

    enum CodingKeys: String, CodingKey {
        case name
    }
}

// MARK: - Name
struct Name: Codable {
    let value, closestNamedHex: String
    let exactMatchName: Bool
    let distance: Int

    enum CodingKeys: String, CodingKey {
        case value
        case closestNamedHex = "closest_named_hex"
        case exactMatchName = "exact_match_name"
        case distance
    }
}


