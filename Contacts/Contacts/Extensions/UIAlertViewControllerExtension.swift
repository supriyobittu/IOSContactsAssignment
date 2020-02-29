//
//  UIAlertViewControllerExtension.swift
//  Contacts
//
//  Created by Supriyo Mondal on 01/03/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func show(_ message: String, from viewController: UIViewController, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "Contacts", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: Constants.AletButtonTitle.OK, style: .cancel, handler: completion))
        viewController.present(alert, animated: true, completion: nil)
    }
}
