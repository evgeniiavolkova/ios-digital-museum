//
//  Artist.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 15.01.2023.
//

import SwiftUI

struct Artist: Codable, Hashable{
    let id: String
    let biography: String
    let birthday: String
    let name: String
    let photo: String
    let wikiUrl: String
}

