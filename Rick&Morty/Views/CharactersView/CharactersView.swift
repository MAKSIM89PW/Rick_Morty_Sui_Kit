//
//  CharactersView.swift
//  Rick&Morty
//
//  Created by Максим Нурутдинов on 22.08.2023.
//

import UIKit
import SwiftUI

protocol CharactersViewProtocol: AnyObject {
    func setController(_ controller: CharactersControllerProtocol)
    func reloadCollection()
    var spinner: UIActivityIndicatorView { get }
}

class CharactersView: UIViewController {
    
    private var controller: CharactersControllerProtocol?
    
    private let titleLabel = UILabel()
    let spinner = UIActivityIndicatorView()
    
    private lazy var charactersView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        let itemSize: CGFloat = ((view.frame.size.width - 55) / 2)
        layout.itemSize = CGSize(width: itemSize, height: itemSize * 1.3)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        setUpLabel()
        setUpCollectionView()
        setUpSpinner()
    }
}

extension CharactersView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller?.characters.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        
        let character = controller?.characters[indexPath.row]
        cell.characterName.text = character?.name
        
        if let url = character?.image {
            Task { @MainActor in
                if let imageData = await controller?.getImageData(url: url) {
                    cell.characterImage.image = UIImage(data: imageData)
                }
            }
        }
        cell.characterImage.clipsToBounds = true
        cell.characterImage.layer.cornerRadius = 12
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let character = controller?.characters[indexPath.row] else { return }
        let vc = CharacterDetailsView(character: character)
        let hostingController = UIHostingController(rootView: vc)
        hostingController.modalTransitionStyle = .flipHorizontal
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
}

extension CharactersView: CharactersViewProtocol {
    func setController(_ controller: CharactersControllerProtocol) {
        self.controller = controller
    }
    
    func reloadCollection() {
        charactersView.reloadData()
    }
}


extension CharactersView {
    private func setUpLabel() {
        titleLabel.text = "Characters"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func  setUpSpinner() {
        spinner.style = .large
        spinner.color = UIColor.white
        spinner.hidesWhenStopped = true
        charactersView.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.topAnchor.constraint(equalTo: charactersView.topAnchor, constant: 200),
            spinner.widthAnchor.constraint(equalToConstant: 300),
            spinner.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setUpCollectionView() {
        charactersView.delegate = self
        charactersView.dataSource = self
        charactersView.register(CharacterCell.self, forCellWithReuseIdentifier: "CharacterCell")
        charactersView.backgroundColor = UIColor.backgroundColor
        charactersView.showsVerticalScrollIndicator = false
        view.addSubview(charactersView)
        
        charactersView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            charactersView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            charactersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            charactersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            charactersView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
