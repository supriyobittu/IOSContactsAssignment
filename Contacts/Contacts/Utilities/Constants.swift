//
//  Constants.swift
//  Contacts
//
//  Created by Supriyo Mondal on 01/03/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Service {
        static let baseURL = "https://gojek-contacts-app.herokuapp.com/"
        static let timeout: TimeInterval = 60
    }
    
    struct AletButtonTitle {
        static let OK = "OK"
    }
    
    struct AlertMessages {
        static let serviceError = "Sorry! Try again later."
        static let validationError = "Please fill all the mandatory fields."
    }
    
    struct BarButtonTitle {
           static let EDIT = "Edit"
           static let DONE = "Done"
           static let CANCEL = "Cancel"
       }
       
       struct ContactDetailKeys {
           static let firstName = "First Name"
           static let lastName = "Last Name"
           static let mobile = "mobile"
           static let email = "email"
       }
    
    struct Color {
        static let navBarColor = UIColor(red: 80/255.0, green: 227/255.0, blue: 194/255.0, alpha: 1)
    }
}
