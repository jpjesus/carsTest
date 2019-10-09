//
//  CarCellView.swift
//  autoSample
//
//  Created by Jesus Parada on 10/8/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import UIKit

class CarCellView: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func buildCell(for car: Car) {
        titleLabel.text = car.name
        
    }
    
}

