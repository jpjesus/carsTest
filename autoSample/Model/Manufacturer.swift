//
//  Manufacturer.swift
//  autoSample
//
//  Created by Jesus Alberto on 10/6/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation

struct Manufacturer: Decodable {
    
    var page: Int = 0
    var pageSize: Int = 0
    var brands: [Brand] = []
    
    enum CodingKeys: String, CodingKey {
        case page
        case pageSize
        case brands = "wkda"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 0
        pageSize = try container.decodeIfPresent(Int.self, forKey: .pageSize) ?? 0
        brands = try container.decodeIfPresent([Brand].self, forKey: .brands) ?? []
    }
}

struct Brand: Decodable {
    
    var id: String = ""
    var brandName: String =  ""
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        try container.allKeys.forEach({ key in
            switch key.stringValue {
            default:
                brandName = try container.decode(String.self, forKey: key)
                id = key.stringValue
            }
        })
    }
}
