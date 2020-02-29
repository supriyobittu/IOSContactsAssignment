//
//  ContactBuilder.swift
//  ContactsTests
//
//  Created by Supriyo Mondal on 29/02/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import UIKit
import Foundation
@testable import Contacts

class ContactBuilder {
    private var id: Int? = 123
    private var firstName: String?
    private var lastName: String?
    private var profilePic: String?
    private var favorite: Bool = false
    private var detailsUrl: String = "www.google.com"
    private var phoneNumber: String?
    private var email: String?
    private var profileImage: UIImage?
    
    func withId(id: Int?) -> ContactBuilder {
        self.id = id
        return self
    }
    
    func withFirstName(firstName: String) -> ContactBuilder {
        self.firstName = firstName
        return self
    }
    
    func withLastName(lastName: String) -> ContactBuilder {
        self.lastName = lastName
        return self
    }
    
    func withProfilePic(pic: String) -> ContactBuilder {
        self.profilePic = pic
        return self
    }
    
    func withFavorite(favorite: Bool) -> ContactBuilder {
        self.favorite = favorite
        return self
    }
    
    func withDetailsUrl(url: String) -> ContactBuilder {
        self.detailsUrl = url
        return self
    }
    
    func withPhoneNumber(phoneNumber: String) -> ContactBuilder {
        self.phoneNumber = phoneNumber
        return self
    }
    
    func withEmail(email: String) -> ContactBuilder {
        self.email = email
        return self
    }
    
    func withProfileImage(image: UIImage) -> ContactBuilder {
        self.profileImage = image
        return self
    }
    
    func build() -> Contact {
        return Contact(id: id, firstName: firstName, lastName: lastName, profilePic: profilePic, favorite: favorite, detailsUrl: detailsUrl, phoneNumber: phoneNumber, email: email, profileImage)
    }
}


