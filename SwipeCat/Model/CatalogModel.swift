//
//  Catalog.swift
//  SwipeCat
//
//  Created by Anubhav Singh on 10/03/24.
//

import Foundation

struct CatalogModel: Codable, Hashable {
    var image: String?
    var price: Float
    var product_name: String
    var product_type: String
    var tax: Float
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
