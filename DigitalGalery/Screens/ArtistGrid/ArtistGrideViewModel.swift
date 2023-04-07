//
//  ArtistGrideViewModel.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 20.01.2023.
//

import Foundation
import SwiftUI
import Combine

class ArtistGridViewModel: ObservableObject{
    
    @Published var artists: [Artist] = []
    @Published var artistPhotos: [UIImage]? = nil
    
    var repository = RemoteRepository()
    
    init(){
        fetchArtists()
    }
    
    func fetchArtists(){
        print("Start data fetching 🤯🤯🤯")
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
    
}

