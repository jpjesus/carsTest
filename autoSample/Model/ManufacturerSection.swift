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
    var items: [Brand]
}

extension ManufacturerSection: SectionModelType {

    init(original: ManufacturerSection, items: [Brand]) {
        self = original
        self.items = items
    }
}
