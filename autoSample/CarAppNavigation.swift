//
//  CarAppNavigation.swift
//  autoSample
//
//  Created by Jesus Parada on 10/8/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import Moya

final class CarAppNavigation {
    
    let provider = MoyaProvider<AutoAPI>()
    var navigationController: UINavigationController?
    
    init(with window: UIWindow) {
        let viewModel = ManufacturerViewModel(with: provider)
        let vc = ManufacturerViewController(with: viewModel)
        navigationController = UINavigationController(rootViewController: vc)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
    
}
