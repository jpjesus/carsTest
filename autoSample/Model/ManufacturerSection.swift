//
//  ManufacturerSection.swift
//  autoSample
//
//  Created by Jesus Alberto on 10/6/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import RxDataSources

struct ManufacturerSection {
    var header: String
    var items: [Item]
}
extension ManufacturerSection: AnimatableSectionModelType {

    typealias Item = Brand
    typealias Identity = String
    
    var identity: Identity {
        return header
    }
    
    init(original: ManufacturerSection, items: [Item]) {
        self = original
        self.items = items
    }
}
