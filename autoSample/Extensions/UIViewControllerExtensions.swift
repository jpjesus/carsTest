//
//  UIViewControllerExtensions.swift
//  autoSample
//
//  Created by Jesus Parada on 10/8/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import UIKit
import Foundation

extension UINavigationController {
    
    func pushFadeAnimation(viewController: UIViewController) {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
        view.layer.removeAllAnimations()
    }
    
    func popFadeAnimation() {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.layer.add(transition, forKey: nil)
        popViewController(animated: false)
        view.layer.removeAllAnimations()
    }
    
    static func showOfflineAlert(with navigation: UINavigationController?) {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("You are offline", comment: "You are offline"), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(action)
        if let navigation = navigation?.visibleViewController {
            if !(navigation.isKind(of: UIAlertController.self)) {
                OperationQueue.main.addOperation {
                    navigation.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    static func showCartInfo(with navigation: UINavigationController?, brandName: String, carModel: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Car Selection", comment: "Car Selection"), message: NSLocalizedString("The car you choose is \(brandName): \(carModel)", comment: "The car you choose is \(brandName): \(carModel)"), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(action)
        if let navigation = navigation?.visibleViewController {
            if !(navigation.isKind(of: UIAlertController.self)) {
                OperationQueue.main.addOperation {
                    navigation.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
