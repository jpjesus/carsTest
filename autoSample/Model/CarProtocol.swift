//
//  AutoProtocol.swift
//  autoSample
//
//  Created by Jesus Parada on 10/8/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import RxDataSources

protocol CarProtocol: class {
    var page: Int { get set}
    var pageSize: Int {get set}
}

protocol AutoDescriptionProtocol: IdentifiableType, Equatable {
    associatedtype Identity
    var id: String { get set}
    var name: String { get set }
    var identity : Identity { get }
}

extension AutoDescriptionProtocol where Self: Car {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
