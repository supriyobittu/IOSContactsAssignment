//
//  ContactDetailsViewModelTests.swift
//  ContactsTests
//
//  Created by Supriyo Mondal on 01/03/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactDetailsViewModelTests: XCTestCase {
    var contact: Contact!
    var contactDetailsViewModel: ContactDetailsViewModelProtocol!

    override func tearDown() {
        contact = nil
        contactDetailsViewModel = nil
    }
    
    func testCorrectImageIsrenderedIfImageUrlIsPresent() {
        contact = ContactBuilder().withProfilePic(pic: "/images/missing.png").withProfileImage(image: UIImage.init(named: "missing")!).build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.profileImage
        let expected = UIImage.init(named: "missing")
        
        XCTAssertEqual(actual, expected)
    }
    
    func testDefaultImageIsRenderedIfImageUrlIsNotPresent() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.profileImage
        let expected = UIImage.init(named: "defaultPic")
        
        XCTAssertEqual(actual, expected)
    }
    
    func testProfileImageSetsProfileImageOnContact() {
        contact = ContactBuilder().withProfilePic(pic: "/images/missing.png").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = UIImage()
        contactDetailsViewModel.profileImage = actual
        let expected = contactDetailsViewModel.profileImage
        
        XCTAssertEqual(actual, expected)
    }
    
    func testFirstNameReturnMahender() {
        contact = ContactBuilder().withFirstName(firstName: "Mahender").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.firstName
        let expected = "Mahender"
        
        XCTAssertEqual(actual, expected)
    }
    
    func testFirstNameReturnEmptyWhenNoFirstName() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.firstName
        let expected = ""
        
        XCTAssertEqual(actual, expected)
    }
    
    func testLastNameReturnGaddam() {
        contact = ContactBuilder().withLastName(lastName: "Gaddam").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.lastName
        let expected = "Gaddam"
        
        XCTAssertEqual(actual, expected)
    }
    
    func testLastNameReturnEmptyWhenNoLastTime() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.lastName
        let expected = ""
        
        XCTAssertEqual(actual, expected)
    }

    func testPhoneNumberReturn8977535135() {
        contact = ContactBuilder().withPhoneNumber(phoneNumber: "8977535135").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.phoneNumber
        let expected = "8977535135"
        
        XCTAssertEqual(actual, expected)
    }
    
    func testPhoneNumberReturnEmptyWhenNoPhoneNumber() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.phoneNumber
        let expected = ""
        
        XCTAssertEqual(actual, expected)
    }
    
    func testEmailReturnmahendergaddamgmailcom() {
        contact = ContactBuilder().withEmail(email: "mahender.gaddam15@gmail.com").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.email
        let expected = "mahender.gaddam15@gmail.com"
        
        XCTAssertEqual(actual, expected)
    }
    
    func testEmailReturnEmptyWhenNoEmail() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.email
        let expected = ""
        
        XCTAssertEqual(actual, expected)
    }
    
    func testFullNameReturnsMahenderGaddam() {
        contact = ContactBuilder().withFirstName(firstName: "Mahender").withLastName(lastName: "Gaddam").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.fullName
        let expected = "Mahender Gaddam"
        
        XCTAssertEqual(actual, expected)
    }
    
    func testIsFavouriteReturnsTrueWhenContactIsFavourite() {
        contact = ContactBuilder().withFavorite(favorite: true).build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
                 
        XCTAssertTrue(contactDetailsViewModel.isFavourite)
    }
    
    func testMessageURLReturnsValidUrlWhenPhoneNumberIsPresent() {
        contact = ContactBuilder().withPhoneNumber(phoneNumber: "8977535135").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.messageURL
        let expected = URL(string: "sms://8977535135")
        
        XCTAssertEqual(actual, expected)
    }
    
    func testMessageURLReturnsNilWhenPhoneNumberIsNotPresent() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        XCTAssertNil(contactDetailsViewModel.messageURL)
    }
    
    func testTelURLReturnsValidUrlWhenPhoneNumberIsPresent() {
        contact = ContactBuilder().withPhoneNumber(phoneNumber: "8977535135").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.telURL
        let expected = URL(string: "tel://8977535135")
        
        XCTAssertEqual(actual, expected)
    }
    
    func testTelURLReturnsNilWhenPhoneNumberIsNotPresent() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        XCTAssertNil(contactDetailsViewModel.telURL)
    }
        
    func testMailURLReturnsValidUrlWhenMailIDIsPresent() {
        contact = ContactBuilder().withEmail(email: "mahender.gaddam@gmail.com").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        let actual = contactDetailsViewModel.mailURL
        let expected = URL(string: "mailto://mahender.gaddam@gmail.com")
        
        XCTAssertEqual(actual, expected)
    }
    
    func testMailURLReturnsNilWhenMailIDIsNotPresent() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
         
        XCTAssertNil(contactDetailsViewModel.mailURL)
    }
    
    func testNumberOfRowsReturns4WhenDetailsScreenIsInEditMode() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        
        contactDetailsViewModel.isInEditMode = true
        
        let actual = contactDetailsViewModel.numberOfRows
        let expected = 4
        
        XCTAssertEqual(actual, expected)
    }
    
    func testNumberOfRowsReturns2WhenDetailsScreenIsNotInEditMode() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        
        contactDetailsViewModel.isInEditMode = false
        
        let actual = contactDetailsViewModel.numberOfRows
        let expected = 2
        
        XCTAssertEqual(actual, expected)
    }
    
    func testkeyValuePairForContactDetailAtIndexPathReturnsFirstNameWhenIsInEditMode() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        
        contactDetailsViewModel.isInEditMode = true
        let indexPath = IndexPath(row: 0, section: 0)
        let actual = contactDetailsViewModel.keyValuePairForContactDetailAtIndexPath(indexPath: indexPath).0
        let expected = Constants.ContactDetailKeys.firstName
        
        XCTAssertEqual(actual, expected)
    }
    
    func testkeyValuePairForContactDetailAtIndexPathReturnsMobileWhenIsNotInEditMode() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        
        contactDetailsViewModel.isInEditMode = false
        let indexPath = IndexPath(row: 0, section: 0)
        
        let actual = contactDetailsViewModel.keyValuePairForContactDetailAtIndexPath(indexPath: indexPath).0
        let expected = Constants.ContactDetailKeys.mobile
        
        XCTAssertEqual(actual, expected)
    }
    
    func testMakeContactFavouriteSetsContactAsFavourite() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        
        contactDetailsViewModel.makeContactFavourite()
        
        XCTAssertTrue(contactDetailsViewModel.isFavourite)
    }
    
    func testIsContactValidReturnsTrueWhenAllMandatoryFieldsInContactAreFilled() {
        contact = ContactBuilder().withFirstName(firstName: "Mahender").withLastName(lastName: "Reddy").withPhoneNumber(phoneNumber: "8977535135").withEmail(email: "mahender@gmail.com").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        
        XCTAssertTrue(contactDetailsViewModel.isContactValid())
    }
    
    func testIsContactValidReturnsFalseWhenMandatoryFieldsAreMissed() {
        contact = ContactBuilder().withFirstName(firstName: "").withLastName(lastName: "Reddy").withEmail(email: "mahender@gmail.com").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        
        XCTAssertFalse(contactDetailsViewModel.isContactValid())
    }
    
    func testIsContactValidReturnsFalseWhenMandatoryFieldsIsNil() {
        contact = ContactBuilder().withLastName(lastName: "Reddy").withEmail(email: "mahender@gmail.com").build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        
        XCTAssertFalse(contactDetailsViewModel.isContactValid())
    }
    
    func testSaveForTitleSavesFirstNameToContactFirstName() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        contactDetailsViewModel.saveForTitle(Constants.ContactDetailKeys.firstName, value: "Mahender")
        
        let actual = "Mahender"
        let expected = contactDetailsViewModel.firstName
        
        XCTAssertEqual(actual, expected)
    }
    
    func testSaveForTitleSavesLastNameToContactLastName() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        contactDetailsViewModel.saveForTitle(Constants.ContactDetailKeys.lastName, value: "Reddy")
        
        let actual = "Reddy"
        let expected = contactDetailsViewModel.lastName
        
        XCTAssertEqual(actual, expected)
    }
    
    func testSaveForTitleSavesMobileNumberToContactMobileNumber() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        contactDetailsViewModel.saveForTitle(Constants.ContactDetailKeys.mobile, value: "897546772")
        
        let actual = "897546772"
        let expected = contactDetailsViewModel.phoneNumber
        
        XCTAssertEqual(actual, expected)
    }
    
    func testSaveForTitleSavesEmailToContactEmail() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact)
        contactDetailsViewModel.saveForTitle(Constants.ContactDetailKeys.email, value: "mahender@gmail.com")
        
        let actual = "mahender@gmail.com"
        let expected = contactDetailsViewModel.email
        
        XCTAssertEqual(actual, expected)
    }
    
    func testCreateContactDetailsCallsContactServiceWithServiceTypeUpdate() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact, NetworkClientStub.shared)
        
        contactDetailsViewModel.updateContactDetails()
        
        XCTAssertTrue(NetworkClientStub.shared.executeMethodCalledWithPut)
    }
    
    func testCreateContactDetailsCallsContactServiceWithServiceTypeAdd() {
        contact = ContactBuilder().build()
        contactDetailsViewModel = ContactDetailsViewModel(contact: contact, NetworkClientStub.shared)
        
        contactDetailsViewModel.createContactDetails()
        
        XCTAssertTrue(NetworkClientStub.shared.executeMethodCalledWithPost)
    }
}
