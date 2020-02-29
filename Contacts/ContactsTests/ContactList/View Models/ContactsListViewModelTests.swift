//
//  ContactsListViewModelTests.swift
//  ContactsTests
//
//  Created by Supriyo Mondal on 29/02/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactsListViewModelTests: XCTestCase {
    var contactsListViewModel: ContactsListViewModelProtocol!
    
    override func tearDown() {
        contactsListViewModel = nil
    }
    
    func testArrangeContactsInGroupsCreates1GroupWithIndexG() {
        let contact1 = ContactBuilder().withId(id: 123).withFirstName(firstName: "Mahender").withLastName(lastName: "Gaddam").build()
        let contacts = [contact1]
        contactsListViewModel = ContactsListViewModel(model: contacts)
        
        let actual = contactsListViewModel.titleForSection(index: 0)
        let expected = "G"
        
        XCTAssertEqual(actual, expected)
    }
    
    func testArrangeContactsInGroupsCreates1GroupWithIndexM() {
        let contact1 = ContactBuilder().withId(id: 123).withFirstName(firstName: "Mahender").withLastName(lastName: "").build()
        let contacts = [contact1]
        contactsListViewModel = ContactsListViewModel(model: contacts)
        
        let actual = contactsListViewModel.titleForSection(index: 0)
        let expected = "M"
        
        XCTAssertEqual(actual, expected)
    }
    
    func testArrangeContactsInGroupsCreates1GroupWithIndexHash() {
        let contact1 = ContactBuilder().withId(id: 123).withFirstName(firstName: "").withLastName(lastName: "").build()
        let contacts = [contact1]
        contactsListViewModel = ContactsListViewModel(model: contacts)
        
        let actual = contactsListViewModel.titleForSection(index: 0)
        let expected = "#"
        
        XCTAssertEqual(actual, expected)
    }
    
    func testNumberOfSectionsReturns2WhenLastNameIsDifferent() {
        let contact1 = ContactBuilder().withId(id: 123).withFirstName(firstName: "Mahender").withLastName(lastName: "Gaddam").build()
        let contact2 = ContactBuilder().withId(id: 456).withFirstName(firstName: "Sarat").withLastName(lastName: "Kumar").build()
        let contacts = [contact1, contact2]
        contactsListViewModel = ContactsListViewModel(model: contacts)
        
        let actual = contactsListViewModel.numberOfSections
        let expected = 2
        
        XCTAssertEqual(actual, expected)
    }
    
    func testNumberOfSectionsReturns1WhenLastNameStartsWithSameCharacter() {
        let contact1 = ContactBuilder().withId(id: 123).withFirstName(firstName: "Mahender").withLastName(lastName: "Kumar").build()
        let contact2 = ContactBuilder().withId(id: 456).withFirstName(firstName: "Sarat").withLastName(lastName: "Kumar").build()
        let contacts = [contact1, contact2]
        contactsListViewModel = ContactsListViewModel(model: contacts)
        
        let actual = contactsListViewModel.numberOfSections
        let expected = 1
        
        XCTAssertEqual(actual, expected)
    }
    
    func testNumberOfRowsInSectionReturns1WhenSectionContainsOnlyOneContact() {
        let contact1 = ContactBuilder().withId(id: 123).withFirstName(firstName: "Mahender").withLastName(lastName: "Reddy").build()
        let contacts = [contact1]
        contactsListViewModel = ContactsListViewModel(model: contacts)
        
        let actual = contactsListViewModel.numberOfRowsInSection(index: 0)
        let expected = 1
        
        XCTAssertEqual(actual, expected)
    }
    
    func testContactsForIndexPathReturnsCorrectValues() {
        let contact1 = ContactBuilder().withId(id: 123).withFirstName(firstName: "Mahender").withLastName(lastName: "Reddy").build()
        let contact2 = ContactBuilder().withId(id: 456).withFirstName(firstName: "Sarat").withLastName(lastName: "Kumar").build()
        
        let contacts = [contact1, contact2]
        contactsListViewModel = ContactsListViewModel(model: contacts)
        let indexPath = IndexPath(row: 0, section: 1)
        
        let actual = contactsListViewModel.contactForIndexPath(indexPath: indexPath)
        let expected = contact1
        
        XCTAssertEqual(actual?.firstName, expected.firstName)
    }
    
    func testGetContactsCallsFetchRequestOnContactService() {
        contactsListViewModel = ContactsListViewModel(model: [], NetworkClientStub.shared)
        
        contactsListViewModel.getContacts(completion: nil)
        
        XCTAssertTrue(NetworkClientStub.shared.executeMethodCalled)
    }
    
    func testGetContactWithIdCallsFetchRequestOnContactService() {
        contactsListViewModel = ContactsListViewModel(model: [], NetworkClientStub.shared)
        
        contactsListViewModel.getContact(id: 123, completion: nil)
        
        XCTAssertTrue(NetworkClientStub.shared.executeMethodCalled)
    }
}
