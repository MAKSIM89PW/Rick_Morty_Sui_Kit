//
//  CharacterDetailsView.swift
//  Rick&Morty
//
//  Created by Максим Нурутдинов on 22.08.2023.
//

import SwiftUI

struct CharacterDetailsView: View {
    
    @ObservedObject private var viewModel = CharacterDetailsViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var episodes: [EpisodeResult] = []
    var character: Result
    
    var body: some View {
        ZStack {
            Color(UIColor.backgroundColor).ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 26)
                .padding(.vertical, 20)
                
                ScrollView {
                    
                    AsyncImage(url: URL(string: character.image)) { image  in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(height: 148)
                    }
                    .frame(width: 148, height: 148)
                    .cornerRadius(16)
                    
                    Text(character.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    
                    Text(character.status)
                        .font(.system(size: 16))
                        .foregroundColor(viewModel.statusColor(for: character.status))
                    
                    HStack {
                        Text("Info")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .padding(.leading, 24)
                        
                        Spacer()
                        
                    }
                    .padding(.top, 15)
                    
                    VStack(spacing: 15) {
                        HStack {
                            Text("Species")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(character.species)
                                .foregroundColor(.white)
                        }
                        
                        HStack {
                            Text("Type")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(character.type.isEmpty ? "None" : character.type)
                                .foregroundColor(.white)
                        }
                        
                        HStack {
                            Text("Gender")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(character.gender)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(15)
                    .font(.system(size: 16))
                    .background(Color(uiColor: UIColor.cellbackgroundColor))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                    
                    HStack {
                        Text("Origin")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .padding(.leading, 24)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    HStack {
                        Image("planet")
                            .frame(width: 24, height: 24)
                            .padding(20)
                            .background(Color(UIColor.backgroundColor))
                            .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(character.origin.name)
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                            
                            
                            Text("Planet")
                                .font(.system(size: 13))
                                .foregroundColor(Color(UIColor.primaryColor))
                        }
                        .padding(.horizontal, 10)
                        
                        Spacer()
                    }
                    .padding(8)
                    .background(Color(uiColor: UIColor.cellbackgroundColor))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                    
                    HStack {
                        Text("Episodes")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .padding(.leading, 24)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(height: 100)
                    } else {
                        
                        VStack(spacing: 15) {
                            
                            ForEach(episodes, id: \.self) { episode in
                                
                                VStack(spacing: 15) {
                                    
                                    HStack {
                                        
                                        Text(episode.name)
                                            .font(.system(size: 17))
                                            .scaledToFit()
                                            .minimumScaleFactor(0.1)
                                            .lineLimit(1)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("Episode: \(viewModel.getNumberOfEpisode(episode: episode.episode)), Season: \(viewModel.getNumberOfSeason(episode: episode.episode))")
                                            .font(.system(size: 13))
                                            .foregroundColor(Color(UIColor.primaryColor))
                                        
                                        Spacer()
                                        
                                        Text(episode.airDate)
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(UIColor.seasonColor))
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(Color(uiColor: UIColor.cellbackgroundColor))
                                .cornerRadius(16)
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                }
            }
        }
        .task {
            episodes = await viewModel.getEpisodesInfo(episodes: character.episode)
        }
    }
}

struct CharacterDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailsView( character: .init(name: "Rick", status: "Alive", species: "None", gender: "Male", type: "Human", image: "some url", origin: .init(name: "Earth"), url: "some url", episode: ["ep1"]))
    }
}
