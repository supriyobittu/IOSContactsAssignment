//
//  NetworkClient.swift
//  Contacts
//
//  Created by Supriyo Mondal on 01/03/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import Foundation

typealias CompletionResult = (Data?, HTTPURLResponse?, Error?) -> Void

protocol NetworkClientProtocol {
    func execute(urlRequest: URLRequest, completion: @escaping CompletionResult)
}

class NetworkClient: NetworkClientProtocol {
    static let shared = NetworkClient(session: URLSession.shared)
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }
    
    func execute(urlRequest: URLRequest, completion: @escaping CompletionResult) {
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.sync {
                completion(data, response as? HTTPURLResponse, error)
            }
        }
        task.resume()
    }
}
