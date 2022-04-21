//
//  ServerModel.swift
//  GIPHY App - AN
//
//  Created by Alon Nasi on 18  2022.
//

import Foundation

struct SereverModel: Codable {
    var data: [GifData]
    let pagination: Pagination
}

struct GifData: Codable {
    let id: String
    let title: String
    let images: Images
}

struct Pagination: Codable {
    let total_count: Int
    let count: Int
    let offset: Int
}

struct Images: Codable {
    let fixed_width_small: FixedWidthSmall
    let fixed_width_downsampled: FixedWidthDownsampled
    let fixed_width: FixedWidth
}

struct FixedWidthSmall: Codable {
    let url: String
}

struct FixedWidthDownsampled: Codable {
    let url: String
}

struct FixedWidth: Codable {
    let url: String
}
