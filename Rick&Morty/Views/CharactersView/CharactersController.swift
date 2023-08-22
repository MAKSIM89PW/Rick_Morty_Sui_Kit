//
//  CharactersController.swift
//  Rick&Morty
//
//  Created by Максим Нурутдинов on 22.08.2023.
//

import Foundation

protocol CharactersControllerProtocol {
    func getCharacters(for pages: Int) async
    func getImageData(url: String) async -> Data?
    var characters: [Result] { get set }
}

final class CharactersController: CharactersControllerProtocol {
    
    private weak var view: CharactersViewProtocol?
    private var netService = NetworkService()
    
    var characters: [Result] = []
    
    private var urlRequest: String = "https://rickandmortyapi.com/api/character"
    private var charactersPageURL = "https://rickandmortyapi.com/api/character?page="
    
    init(view: CharactersViewProtocol?) {
        self.view = view
        
        DispatchQueue.main.async {
            view?.spinner.startAnimating()
        }
        
        Task {
            if let charactersFromJson: Character = try await netService.getJSON(url: urlRequest) {
                characters.append(contentsOf: charactersFromJson.results)
                await getCharacters(for: charactersFromJson.info.pages)
                
                DispatchQueue.main.async {
                    view?.spinner.stopAnimating()
                    view?.reloadCollection()
                }
            }
        }
    }
    
    func getCharacters(for pages: Int) async {
        for number in 2...pages {
            do {
                if let charactersFromJson: Character = try await netService.getJSON(url: "\(charactersPageURL)\(number)") {
                    self.characters.append(contentsOf: charactersFromJson.results)
                }
            } catch {
                print(MyErrors.noData.localizedDescription)
            }
        }
    }
    
    @MainActor func getImageData(url: String) async -> Data? {
        do {
            return try await netService.getImage(url: url)
        } catch {
            return nil
        }
    }
}
