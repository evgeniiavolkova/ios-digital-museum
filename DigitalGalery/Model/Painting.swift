//
//  Painting.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 15.01.2023.
//

import SwiftUI

struct Paiting: Codable, Hashable{
    let id: String
    let artistId: String
    let date: String
    let description: String
    let latitude: Double
    let longitude: Double
    let name: String
    let pictureUrl: String
}
