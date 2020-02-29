//
//  ContactService.swift
//  Contacts
//
//  Created by Supriyo Mondal on 01/03/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import UIKit
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum ContactsAPI {
    case getContacts
    case getContact(id: Int)
    case addContact(contact: Contact)
    case updateContact(id: Int, contact: Contact)
    case getImage(path: String)
    
    var baseURL: URL {
        guard let url = URL(string: Constants.Service.baseURL) else {
            fatalError("BaseURL not configured.")
        }
        return url
    }
    
    var resourcePath: String {
        switch self {
        case .getContacts, .addContact:
            return "contacts.json"
        case .getContact(let id), .updateContact(let id, _):
            return "contacts/\(String(describing: id)).json"
        case .getImage(let path):
            return path
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getContacts, .getContact, .getImage :
            return .get
        case .addContact:
            return .post
        case .updateContact:
            return .put
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .addContact(let contact), .updateContact(_, let contact):
            do {
                return try JSONEncoder().encode(contact)
            } catch {
                print("Unable to encode Contact")
            }
        default:
            return nil
        }
        return nil
    }
    
    var contentType: String {
        switch self {
        case .getImage:
            return ""
        default:
            return "application/json"
        }
    }
}

class ContactService {
    var networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func request<T: Codable>(serviceType: ContactsAPI, model: T.Type,
                             completionHandler: @escaping (T?, HTTPURLResponse?, Error?) -> Void) {
        
        let url = serviceType.baseURL.appendingPathComponent(serviceType.resourcePath)
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: Constants.Service.timeout)
        urlRequest.httpMethod = serviceType.httpMethod.rawValue
        urlRequest.httpBody = serviceType.httpBody
        urlRequest.addValue(serviceType.contentType, forHTTPHeaderField: "Content-Type")
        
        networkClient.execute(urlRequest: urlRequest) { (data, response, error) in
            do {
                switch serviceType {
                case .getImage:
                        completionHandler((data as? T), response, nil)
                    default:
                        let result = try JSONDecoder().decode(T.self, from: data ?? Data())
                        completionHandler(result, response, nil)
                }
            } catch let error {
                completionHandler(nil, response, error)
            }
        }
    }
}

