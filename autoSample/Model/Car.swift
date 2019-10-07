//
//  Car.swift
//  autoSample
//
//  Created by Jesus Alberto on 10/6/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation

struct Car: Decodable {
    var page: Int = 0
    var pageSize: Int = 0
    var types: [String: String] = [:]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pageSize
        case types = "wkda"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 0
        pageSize = try container.decodeIfPresent(Int.self, forKey: .pageSize) ?? 0
        types = try container.decodeIfPresent([String: String].self, forKey: .types) ?? [:]
    }
}
