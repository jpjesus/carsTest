//
//  CartCellView.swift
//  autoSample
//
//  Created by Jesus Parada on 10/8/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import UIKit

class CartCellView: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func buildCell(for brand: Brand) {
        titleLabel.text = brand.name
        
    }
    
}

