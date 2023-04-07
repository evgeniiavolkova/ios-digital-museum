//
//  RemoteRepository.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 20.01.2023.
//

import Foundation


enum ApiError: Error {
    case buildUrl
    case jsonDecoder
}

class RemoteRepository{
    
    let BASE_URL = "https://us-central1-arts-205b0.cloudfunctions.net/app/"
    
    func fetchAllArtists()async -> Result<[Artist], ApiError>{
        
        let artists: [Artist]
        
        guard let url = URL(string: BASE_URL + "artists") else {
            return .failure(.buildUrl)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            artists = try JSONDecoder().decode([Artist].self, from: data)
        } catch {
            print(error)
            return .failure(.jsonDecoder)
        }
        
        return .success(artists)
    }
    
    func fetchAllPaintings()async -> Result<[Paiting], ApiError>{
        
        let paintings: [Paiting]
        
        guard let url = URL(string: BASE_URL + "paintings") else {
            return .failure(.buildUrl)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            paintings = try JSONDecoder().decode([Paiting].self, from: data)
        } catch {
            print(error)
            return .failure(.jsonDecoder)
        }
        
        return .success(paintings)
    }
    
    func fetchArtistById(artistId: String)async -> Result<Artist, ApiError>{
        
        let artist: Artist
        
        guard let url = URL(string: BASE_URL + "artist/\(artistId)") else {
            return .failure(.buildUrl)
        }
        print("😞\(artistId)")
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            artist = try JSONDecoder().decode(Artist.self, from: data)
        } catch {
            print(error)
            return .failure(.jsonDecoder)
        }
        
        return .success(artist)
    }
    
    func fetchPaintingById(paitingId: String)async -> Result<Paiting, ApiError>{
        
        let painting: Paiting
        
        guard let url = URL(string: BASE_URL + "painting/\(paitingId)") else {
            return .failure(.buildUrl)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            painting = try JSONDecoder().decode(Paiting.self, from: data)
        } catch {
            print(error)
            return .failure(.jsonDecoder)
        }
        
        return .success(painting)
    }
    
}
