//
//  NetworkManager.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func fetchData(numberOfPage: Int, count: Int, arguments: [Arguments]) async throws -> Data
}

final class NetworkManager: NetworkManagerProtocol {
    func fetchData(numberOfPage: Int, count: Int, arguments: [Arguments]) async throws -> Data {
        var queries = [String]()
        for argument in arguments {
            queries.append(argument.rawValue)
        }
        let argString = queries.joined(separator: ",")
        let urlString = "https://randomuser.me/api/?page=\(numberOfPage)&results=\(count)&inc=\(argString)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.notConnectedToInternet)
        }
        
        guard response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}

enum Arguments: String {
    case gender
    case name
    case location
    case email
    case login
    case registered
    case dob
    case phone
    case cell
    case id
    case picture
    case nat
}
