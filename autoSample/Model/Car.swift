//
//  Car.swift
//  autoSample
//
//  Created by Jesus Alberto on 10/6/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import RxDataSources

class CarType: Decodable, CarProtocol {
    var page: Int = 0
    var pageSize: Int = 0
    var type: [Car] = []
    
    enum CodingKeys: String, CodingKey {
        case page
        case pageSize
        case types = "wkda"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 0
        pageSize = try container.decodeIfPresent(Int.self, forKey: .pageSize) ?? 0
        let subContainer = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .types)
        for key in subContainer.allKeys {
            let auto = Car(id: key.stringValue, autoName: try subContainer.decode(String.self, forKey: key))
            type.append(auto)
        }
    }
    
    init() {}
}

class Car: AutoDescriptionProtocol, IdentifiableType, Equatable {
    
    var id: String
    var name: String
    typealias Identity = String
    
    init(id: String, autoName: String) {
        self.id = id
        self.name = autoName
    }
    
    
    var identity: Identity {
        return name
    }
    
    static func == (lhs: Car, rhs: Car) -> Bool {
        return lhs.id == rhs.id
    }
}
