//
//  PaintingDetailsViewModel.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 21.01.2023.
//

import Foundation
import SwiftUI
import Combine

class PaintingDetailsViewModel: ObservableObject{
    @Published var paitingId: String? = ""
    @Published var artist: Artist? = nil
    @Published var painting: Paiting? = nil
    
    @Published var isLoading: Bool = false
    
    //let imageURL = URL(string: viewModel.painting?.pictureUrl ?? viewModel.defImageValue)
    
    let defImageValue = "https://www.boredpanda.com/blog/wp-content/uploads/2021/12/famous-paintings-3-61c96e3c17c72__700.jpg"
    
    var repository = RemoteRepository()
    
    init(paitingId: String){
        self.paitingId = paitingId
        fetchPaitingById()
    }
    
    func fetchPaitingById(){
       self.isLoading = true
        print("🥶 paitingDetails fetching is start")
        Task{
            let result = await repository.fetchPaintingById(paitingId: self.paitingId!)
            switch (result) {
            case let .success(data):
                DispatchQueue.main.async {
                    self.painting = data
                    self.fetchArtist()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func fetchArtist(){
        Task{
            let result = await repository.fetchArtistById(artistId: painting!.artistId)
            
            switch (result) {
            case let .success(data):
                DispatchQueue.main.async {
                    self.artist = data
                    self.isLoading = false
                }
            case let .failure(error):
                self.isLoading = false
                print(error)
            }
        }
    }
}
