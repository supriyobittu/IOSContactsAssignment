//
//  ContactDetailsViewModel.swift
//  Contacts
//
//  Created by Supriyo Mondal on 01/03/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import UIKit

protocol ContactDetailsViewModelProtocol {
    var profileImage: UIImage { get set }
    var firstName: String { get }
    var lastName: String { get }
    var fullName: String { get }
    var phoneNumber: String { get }
    var email: String { get }
    var isFavourite: Bool { get }

    var messageURL: URL? { get }
    var telURL: URL? { get }
    var mailURL: URL? { get }
    
    var numberOfRows: Int { get }
    var isInEditMode: Bool { get set }
    
    func makeContactFavourite()
    func isContactValid() -> Bool
    func updateContactDetails()
    func createContactDetails()
    
    func keyValuePairForContactDetailAtIndexPath(indexPath: IndexPath) -> (String, String, String)
    func saveForTitle(_ title: String, value: String)
}

class ContactDetailsViewModel : ContactDetailsViewModelProtocol {
    var contact: Contact!
    var isInEditMode: Bool
    var detailsArray: [(String, String, String)] = []
    
    private var contactService: ContactService

    init(contact: Contact?,_ networkClient: NetworkClientProtocol = NetworkClient.shared) {
        contactService = ContactService(networkClient: networkClient)
        self.contact = contact
        self.isInEditMode = false
        createDetailsDictionary()
    }
    
    func createDetailsDictionary() {
        detailsArray.removeAll()
        detailsArray.append((Constants.ContactDetailKeys.firstName, contact.firstName ?? "",
                             "Enter First Name"))
        detailsArray.append((Constants.ContactDetailKeys.lastName, contact.lastName ?? "",
                             "Enter Last Name"))
        detailsArray.append((Constants.ContactDetailKeys.mobile, contact.phoneNumber ?? "",
                             "Enter mobile number"))
        detailsArray.append((Constants.ContactDetailKeys.email, contact.email ?? "",
                             "Enter your email"))
    }

    var profileImage: UIImage {
        get {
            if self.contact?.profilePic?.isEmpty == false {
                return self.contact.profileImage ?? UIImage.init(named: "defaultPic")!
            }
            return UIImage.init(named: "defaultPic")!
        }
        
        set {
            contact.profileImage = newValue
        }
    }
    
    var firstName: String {
        return self.contact.firstName ?? ""
    }
    
    var lastName: String {
        return self.contact.lastName ?? ""
    }
    
    var fullName: String {
        return self.firstName + " " + self.lastName
    }
    
    var phoneNumber: String {
        return self.contact.phoneNumber ?? ""
    }
    
    var email: String {
        return self.contact.email ?? ""
    }
    
    var isFavourite: Bool {
        return self.contact.favorite
    }
    
    var messageURL: URL? {
        if let phone = contact.phoneNumber {
            return URL(string: String(format: "sms://%@", phone))
        }
        return nil
    }
    
    var telURL: URL? {
        if let phone = contact.phoneNumber {
            return URL(string: String(format: "tel://%@", phone))
        }
        return nil
    }
    
    var mailURL: URL? {
        if let email = contact.email {
            return URL(string: String(format: "mailto://%@", email))
        }
        return nil
    }
    
    var numberOfRows: Int {
        return isInEditMode ? 4 : 2
    }
    
    func keyValuePairForContactDetailAtIndexPath(indexPath: IndexPath) -> (String, String, String) {
        if isInEditMode {
            return detailsArray[indexPath.row]
        }
        return detailsArray[indexPath.row + 2]
    }
    
    func makeContactFavourite() {
        contact.favorite = !contact.favorite
        updateContactDetails()
    }
    
    func updateContactDetails() {
        contactService.request(serviceType: .updateContact(id: contact.id!, contact: contact), model: Contact.self) { (contact, response, error) in
            
        }
    }
    
    func createContactDetails() {
        contactService.request(serviceType: .addContact(contact: contact), model: Contact.self) {
            (contact, response, error) in
            
        }
    }
    
    func isContactValid() -> Bool {
        if isNilOrEmpty(contact.firstName) || isNilOrEmpty(contact.lastName) || isNilOrEmpty(contact.phoneNumber) ||
            isNilOrEmpty(contact.email) {
            return false
        }
        return true
    }
    
    private func isNilOrEmpty(_ text: String?) -> Bool {
        guard let content = text else {
            return true
        }
        if content.isEmpty {
            return true
        }
        return false
    }
    
    func saveForTitle(_ title: String, value: String) {
        switch title {
        case Constants.ContactDetailKeys.firstName:
            contact.firstName = value
        case Constants.ContactDetailKeys.lastName:
            contact.lastName = value
        case Constants.ContactDetailKeys.mobile:
            contact.phoneNumber = value
        case Constants.ContactDetailKeys.email:
            contact.email = value
        default: break
        }
        createDetailsDictionary()
    }
}

