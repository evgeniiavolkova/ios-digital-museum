//
//  ArtistDetailViewModel.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 20.01.2023.
//

import Foundation
import SwiftUI
import Combine

class ArtistDetailsViewModel: ObservableObject{
    
    @Published var artist = Artist(id: "", biography: "", birthday: "", name: "", photo: "", wikiUrl: "")
    @Published var artistPhoto: UIImage? = nil
    @Published var paitings: [Paiting]? = nil
    
    @Published var artistId: String = ""
    var repository = RemoteRepository()
    
    init(artistId: String) {
        self.artistId = artistId
        fetchArtist()
    }
    
    func fetchArtist(){
        Task{
            let result = await repository.fetchArtistById(artistId: artistId)
            
            switch (result) {
            case let .success(data):
                DispatchQueue.main.async {
                    self.artist = data
                    self.loadImage()
                    self.fetchPaintings()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func fetchPaintings(){
        Task{
            let result = await repository.fetchAllPaintings()

            switch (result) {
            case let .success(data):
                DispatchQueue.main.async {
                    self.paitings = data.filter { $0.artistId == self.artist.id }
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func loadImage() {
        guard let url = URL(string: artist.photo) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.artistPhoto = image
                }
            } else {
            }
        }

        task.resume()
    }
}
