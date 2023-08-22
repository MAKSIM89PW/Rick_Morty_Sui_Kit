//
//  CharactersModel.swift
//  Rick&Morty
//
//  Created by Максим Нурутдинов on 22.08.2023.
//

import Foundation

struct Character: Decodable {
    let results: [Result]
    let info: Info
}

struct Result: Decodable {
    let name: String
    let status: String
    let species: String
    let gender: String
    let type: String
    let image: String
    let origin: Origin
    let url: String
    let episode: [String]
}

struct Info: Decodable {
    let count: Int
    let pages: Int
}

struct Origin: Decodable {
    let name: String
}
