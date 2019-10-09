//
//  AutoProtocol.swift
//  autoSample
//
//  Created by Jesus Parada on 10/8/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation

protocol CarProtocol: class {
    var page: Int { get set}
    var pageSize: Int {get set}
    var type: [AutoDescriptionProtocol] {get set}
}

protocol AutoDescriptionProtocol: class {
    var id: String { get set}
    var name: String { get set }
}
