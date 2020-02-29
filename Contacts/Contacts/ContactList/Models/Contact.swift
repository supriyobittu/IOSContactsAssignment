//
//  Contact.swift
//  Contacts
//
//  Created by Supriyo Mondal on 29/02/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import Foundation
import UIKit

enum CodingKeys: String, CodingKey {
    case id, favorite, email
    case firstName = "first_name"
    case lastName = "last_name"
    case profilePic = "profile_pic"
    case phoneNumber = "phone_number"
    case detailsUrl = "url"
}

class Contact: Codable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var profilePic: String?
    var favorite: Bool
    var detailsUrl: String?
    var email: String?
    var phoneNumber: String?
    var profileImage: UIImage?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.profilePic = try container.decodeIfPresent(String.self, forKey: .profilePic)
        self.favorite = try container.decodeIfPresent(Bool.self, forKey: .favorite) ?? false
        self.detailsUrl = try container.decodeIfPresent(String.self, forKey: .detailsUrl)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
    }

    init(id: Int?, firstName: String? = nil, lastName: String? = nil, profilePic: String? = nil, favorite: Bool = false, detailsUrl: String? = nil, phoneNumber: String? = nil, email: String? = nil,_ profileImage: UIImage? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
        self.favorite = favorite
        self.detailsUrl = detailsUrl
        self.phoneNumber = phoneNumber
        self.email = email
        self.profileImage = profileImage
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(profilePic, forKey: .profilePic)
        try container.encode(favorite, forKey: .favorite)
        try container.encode(detailsUrl, forKey: .detailsUrl)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(email, forKey: .email)
    }
}
