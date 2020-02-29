//
//  ContactServiceTests.swift
//  ContactsTests
//
//  Created by Supriyo Mondal on 01/03/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactServiceTests: XCTestCase {
    var contactService: ContactService!

    override func tearDown() {
        contactService = nil
    }
    
    func testContactServiceReturns2ContactsWhenGetContactsApiIsCalled() {
        contactService = ContactService(networkClient: NetworkClientStub())
        let expectation = self.expectation(description: "ContactService should return contacts")
        
        contactService.request(serviceType: .getContacts, model: [Contact].self) { (contacts, response, error) in
            if contacts?.count == 2 {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testContactServiceReturns1ContactWhenGetContactWithIdIsCalled() {
        contactService = ContactService(networkClient: NetworkClientStub())
        let expectation = self.expectation(description: "ContactService should return contacts")
        
        contactService.request(serviceType: .getContact(id: 123), model: [Contact].self) { (contacts, response, error) in
            if contacts?.count == 1 {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testContactServiceSendContactDataWhenAddContactApiIsCalled() {
        contactService = ContactService(networkClient: NetworkClientStub())
        let expectation = self.expectation(description: "ContactService should sent contact")
        let contact = ContactBuilder().withId(id: 456).withFirstName(firstName: "Mahender").withLastName(lastName: "Reddy").build()

        contactService.request(serviceType: .addContact(contact: contact), model: [Contact].self) { (contacts, response, error)  in
            if response?.statusCode == 201 {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testContactServiceUpdateContactDataWhenUpdateContactApiIsCalled() {
        contactService = ContactService(networkClient: NetworkClientStub())
        let expectation = self.expectation(description: "ContactService should sent contact")
        let contact = ContactBuilder().withId(id: 456).withFirstName(firstName: "Mahender").withLastName(lastName: "Kumar").build()

        contactService.request(serviceType: .updateContact(id: 456, contact: contact), model: [Contact].self) { (contacts, response, error)  in
            if response?.statusCode == 200 {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testContactServiceReturnsErrorResponse() {
        contactService = ContactService(networkClient: ErrorNetworkClientStub())
        let expectation = self.expectation(description: "ContactService should return error")
        
        contactService.request(serviceType: .getContacts, model: [Contact].self) { (contacts, response, error) in
            if error != nil {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

// Stubs
class NetworkClientStub: NetworkClientProtocol {
    static let shared = NetworkClientStub()
    var executeMethodCalled = false
    var executeMethodCalledWithPost = false
    var executeMethodCalledWithPut = false

    func execute(urlRequest: URLRequest, completion: @escaping CompletionResult) {
        executeMethodCalled = true
        
        switch urlRequest.httpMethod! {
        case HTTPMethod.post.rawValue:
            executeMethodCalledWithPost = true
        case HTTPMethod.put.rawValue:
            executeMethodCalledWithPut = true
        default:
            executeMethodCalled = true
        }
        guard let urlString = urlRequest.url?.absoluteString else {
            completion(nil, nil, NSError(domain: "Contacts", code: 1003, userInfo: nil))
            return
        }
        
        var data: Data?
        var urlResponse: HTTPURLResponse?
        
        if urlString.contains("contacts.json") &&
            urlRequest.httpMethod == HTTPMethod.get.rawValue {
            
            let contact1 = ContactBuilder().withId(id: 456).withFirstName(firstName: "Mahender").withLastName(lastName: "Reddy").build()
            let contact2 = ContactBuilder().withId(id: 123).withFirstName(firstName: "Sarat").withLastName(lastName: "Kumar").build()
            data = try! JSONEncoder().encode([contact1, contact2])
            urlResponse = HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)
            
        } else if urlString.contains("contacts/123") &&
                   urlRequest.httpMethod == HTTPMethod.get.rawValue {
            let contact1 = ContactBuilder().withId(id: 123).withFirstName(firstName: "Sarat").withLastName(lastName: "Kumar").build()
            data = try! JSONEncoder().encode([contact1])
            urlResponse = HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)
            
        } else if urlRequest.httpMethod == HTTPMethod.post.rawValue {
            data = try! JSONEncoder().encode(Array<Contact>.init())
            urlResponse = HTTPURLResponse(url: urlRequest.url!, statusCode: 201, httpVersion: "2.0", headerFields: nil)
        } else {
            data = try! JSONEncoder().encode(Array<Contact>.init())
            urlResponse = HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)
        }
        
        completion(data, urlResponse, nil)
    }
}

class ErrorNetworkClientStub: NetworkClientProtocol {
    func execute(urlRequest: URLRequest, completion: @escaping CompletionResult) {
        completion(nil, nil, NSError(domain: "Contacts", code: 1003, userInfo: nil))
    }
}
