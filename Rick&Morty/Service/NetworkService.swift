//
//  NetworkService.swift
//  Rick&Morty
//
//  Created by Максим Нурутдинов on 22.08.2023.
//

import Foundation

final class NetworkService {
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func getJSON<T: Decodable>(url: String) async throws -> T? {
        guard let url = URL(string: url) else {
            throw MyErrors.badUrl
        }
        let response = try await URLSession.shared.data(from: url)
        let character = try decoder.decode(T.self, from: response.0)
        return character
    }
    
    func getImage(url: String) async throws -> Data? {
        guard let url = URL(string: url) else {
            throw MyErrors.badUrl
        }
        let response = try await URLSession.shared.data(from: url)
        let data = response.0
        return data
    }
}

enum MyErrors: Error {
    case badUrl
    case noData
}
