//
//  ManufacturerCell.swift
//  autoSample
//
//  Created by Jesus Alberto on 10/6/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import UIKit

class ManufacturerCarCellView: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func buildCell(for brand: Brand) {
        titleLabel.text = brand.name
        
    }
    
}
