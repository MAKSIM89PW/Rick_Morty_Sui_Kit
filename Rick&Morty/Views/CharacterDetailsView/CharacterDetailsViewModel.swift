//
//  CharacterDetailsViewModel.swift
//  Rick&Morty
//
//  Created by Максим Нурутдинов on 22.08.2023.
//

import Foundation
import SwiftUI

final class CharacterDetailsViewModel: ObservableObject {
    
    private var netService = NetworkService()
    @Published var isLoading = false
    
    @MainActor func getEpisodesInfo(episodes: [String]) async -> [EpisodeResult] {
        
        isLoading = true
        defer { isLoading = false }
        
        var result: [EpisodeResult] = []
        for episode in episodes {
            do {
                if let episode: EpisodeResult = try await netService.getJSON(url: episode) {
                    result.append(episode)
                }
            } catch {
                print(MyErrors.noData.localizedDescription)
            }
        }
        return result
    }
    
    func statusColor(for status: String) -> Color {
        switch status {
        case "Alive": return Color(UIColor.primaryColor )
        case "Dead": return .red
        case "unknown": return .orange
        default: return .gray
        }
    }
    
    func getNumberOfEpisode(episode: String) -> String {
        var lastTwo = String(episode.suffix(2))
        if lastTwo.hasPrefix("0") {
            lastTwo.removeFirst()
        }
        return lastTwo
    }
    
    func getNumberOfSeason(episode: String) -> String {
        let index2 = episode.index(episode.startIndex, offsetBy: 1)
        let index3 = episode.index(episode.startIndex, offsetBy: 2)
        var result = String(episode[index2...index3])
        if result.hasPrefix("0") {
            result.removeFirst()
        }
        return result
    }
}
