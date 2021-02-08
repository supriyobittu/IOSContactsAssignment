//
//  ContactsListViewModel.swift
//  Contacts
//
//  Created by Supriyo Mondal on 29/02/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import Foundation

protocol ContactsListViewModelProtocol {
    var numberOfSections: Int { get }
    var sectionIndexTitles: [String] { get }
    var delegate: ContactViewDelegate? { get set }
    
    func titleForSection(index: Int) -> String
    func numberOfRowsInSection(index: Int) -> Int
    func contactForIndexPath(indexPath: IndexPath) -> Contact?
    func getContacts(completion: ((Error?) -> Void)?)
    func getContact(id: Int, completion: ((Contact?, Error?) -> Void)?)
}

class ContactsListViewModel: ContactsListViewModelProtocol {
     var indexedContacts: [String: [Contact]] = Dictionary<String, [Contact]>()
     private var contactService: ContactService
     var delegate: ContactViewDelegate?

     init(model: [Contact],_ networkClient: NetworkClientProtocol = NetworkClient.shared) {
         contactService = ContactService(networkClient: networkClient)
         arrangeContactsInGroups(contacts: model)
     }
     
     
     private func arrangeContactsInGroups(contacts: [Contact]) {
         contacts.forEach { (contact) in
             var index: String = "#"
             
             if let lastName = contact.lastName, lastName.count > 0, Int.init(String(lastName[lastName.startIndex])) == nil {
                 index = String(lastName[lastName.startIndex]).uppercased()
             } else if let firstName = contact.firstName, firstName.count > 0,
                 Int.init(String(firstName[firstName.startIndex])) == nil {
                 index = String(firstName[firstName.startIndex]).uppercased()
             }
             
             if indexedContacts[index] != nil {
                 var contactGroup = indexedContacts[index]
                 contactGroup?.append(contact)
                 indexedContacts[index] = contactGroup?.sorted {
                     $0.firstName!.compare($1.firstName!) == .orderedAscending
                 }
             } else {
                 indexedContacts[index] = [contact]
             }
         }
     }
     
     var sectionIndexTitles: [String] {
         var keys = indexedContacts.keys.sorted()
         let keysWithoutHash = keys.filter{ $0 == "#" }
         if keysWithoutHash.count == 1 {
             keys.removeFirst()
             keys.append("#")
         }
         return keys
     }
     
     var numberOfSections: Int {
         return sectionIndexTitles.count
     }
     
     func numberOfRowsInSection(index: Int) -> Int {
         let characterIndex = sectionIndexTitles[index]
         return indexedContacts[characterIndex]?.count ?? 0
     }
     
     func titleForSection(index: Int) -> String {
         return sectionIndexTitles[index]
     }
     
     func contactForIndexPath(indexPath: IndexPath) -> Contact? {
         let characterIndex = sectionIndexTitles[indexPath.section]
         guard let contactsForIndex = indexedContacts[characterIndex] else {
             return nil
         }
         return contactsForIndex[indexPath.row]
     }
    
    func getContacts(completion : ((Error?) -> Void)?) {
        contactService.request(serviceType: .getContacts, model: [Contact].self) { [unowned self]
            (newContacts, response, error) in
            if error == nil {
                self.indexedContacts.removeAll()
                self.arrangeContactsInGroups(contacts: newContacts ?? [])
                completion!(nil)
            }
            if response == nil {
                do {
                    self.indexedContacts.removeAll()
                    let contact = MockJsonFile.contacts.content
                    let contacts = try JSONDecoder().decode([Contact].self, from: contact ?? Data())
                    self.arrangeContactsInGroups(contacts: contacts)
                    completion!(nil)
                } catch let errorResponse {
                    completion!(errorResponse)
                } 
            }
        }
    }
    
    func getContact(id: Int, completion: ((Contact?, Error?) -> Void)?) {
        contactService.request(serviceType: .getContact(id: id), model: Contact.self) { (data, response, error) in
            if completion != nil {
                completion!(data, error)
            }
        }
    }
}
