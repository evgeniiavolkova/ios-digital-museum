//
//  PaintingsGridViewModel.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 21.01.2023.
//

import Foundation
import Combine
import SwiftUI


class PaintingsGridViewModel: ObservableObject {
    
    @Published var paintings: [Paiting] = []
    @Published var isLoading: Bool = false
    
    let repository = RemoteRepository()
    let cache = NSCache<NSString, UIImage>()
    
    init() {
        fetchPaintings()
    }
    
    func fetchPaintings() {
        print("Start data fetching 🤩")
        self.isLoading = true
        Task {
            let result = await repository.fetchAllPaintings()
            
            switch (result) {
            case let .success(data):
                DispatchQueue.main.async {
                    self.paintings = data
                    self.isLoading = false
                }
            case let .failure(error):
                print(error)
                self.isLoading = false
            }
        }
    }
}
    

