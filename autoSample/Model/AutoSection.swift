//
//  AutoSection.swift
//  autoSample
//
//  Created by Jesus Parada on 10/8/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import RxDataSources

struct CarSection {
    var header: String
    var items: [Car]
}

extension CarSection: AnimatableSectionModelType {
    typealias Identity = String
    
    var identity: Identity {
        return header
    }
    
    init(original: CarSection, items: [Car]) {
        self = original
        self.items = items
    }
}
