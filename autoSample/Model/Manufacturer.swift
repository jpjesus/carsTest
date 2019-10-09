//
//  Manufacturer.swift
//  autoSample
//
//  Created by Jesus Alberto on 10/6/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import RxDataSources

class Manufacturer: CarProtocol, Decodable {

    var page: Int = 0
    var pageSize: Int = 0
    var type: [Brand] = []
    
    enum CodingKeys: String, CodingKey {
        case page
        case pageSize
        case brands = "wkda"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 0
        pageSize = try container.decodeIfPresent(Int.self, forKey: .pageSize) ?? 0
        let subContainer = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .brands)
        for key in subContainer.allKeys {
            let brand = Brand(id: key.stringValue, brandName: try subContainer.decode(String.self, forKey: key))
            type.append(brand)
        }
    }
    
    init() {}
}

class Brand: AutoDescriptionProtocol, IdentifiableType, Equatable {
    
    var id: String
    var name: String
    typealias Identity = String
    
    init(id: String, brandName: String) {
        self.id = id
        self.name = brandName
    }
    
    var identity: Identity {
        return name
    }
    
    static func == (lhs: Brand, rhs: Brand) -> Bool {
        return lhs.id == rhs.id
    }
}
