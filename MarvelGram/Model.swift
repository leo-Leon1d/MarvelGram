//
//  Model.swift
//  MarvelGram
//
//  Created by Леонид Исраелян on 13.04.2022.
//

import Foundation

struct Model: Codable {
    let id: Int
    let name: String
    let description: String
    let modified: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Codable {
    let path: String
    let `extension`: String
}
