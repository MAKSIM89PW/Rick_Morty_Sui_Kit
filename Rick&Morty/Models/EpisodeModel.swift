//
//  EpisodeModel.swift
//  Rick&Morty
//
//  Created by Максим Нурутдинов on 22.08.2023.
//

import Foundation

struct Episode: Decodable, Hashable {
    let results: [EpisodeResult]
}

struct EpisodeResult: Decodable, Hashable {
    let name: String
    let episode: String
    let airDate: String
    let url: String
}
