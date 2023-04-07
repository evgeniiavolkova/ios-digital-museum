//
//  ArtHubViewModel.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 15.01.2023.
//

import SwiftUI

class ArtHubViewModel: ObservableObject{
    
    @Published var artists: [Artist] = []
    @Published var paintings: [Paiting] = []
    @Published var image: UIImage? = nil
    
    @Published var isLoading: Bool = false
    
    @Published var randomPaintig: Paiting = Paiting(id: "", artistId: "", date: "", description: "", latitude: 0.0, longitude: 0.0, name: "", pictureUrl: "")
    
    var repository = RemoteRepository()
    
    init(){
        fetchPainitng()
    }
    
    func fetchPainitng(){
        print("Start fetching data in ArtHubViewModel")
        self.isLoading = true
            Task{
                let result = await repository.fetchAllPaintings()
                
                switch (result) {
                case let .success(data):
                    DispatchQueue.main.async {
                        self.paintings = data
                        self.randomPaintig = self.paintings.randomElement() ?? Paiting(id: "", artistId: "", date: "", description: "", latitude: 0.0, longitude: 0.0, name: "", pictureUrl: "")
                        self.fetchArtist()
                        self.loadImage()
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
    
    
    func fetchArtist(){
        Task{
            let result = await repository.fetchAllArtists()
            
            switch (result) {
            case let .success(data):
                DispatchQueue.main.async {
                    self.artists = data
                    
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func loadImage() {
        guard let url = URL(string: randomPaintig.pictureUrl) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    self.isLoading = false
                }
            } else {
                print("Error image loading is ArtHubView")
                self.isLoading = false
            }
        }
        
        task.resume()
    }
}

