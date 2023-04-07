//
//  ArtistGridView.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 20.01.2023.
//

import SwiftUI
import URLImage

struct ArtistGridView: View {
    @StateObject var viewModel = ArtistGridViewModel()
    private var twoColumnGrid =  [GridItem(.flexible()), GridItem(.flexible())]
    @State private var path = [String]()
    @State private var search = ""
    
    var body: some View {
        if (viewModel.artists.isEmpty){
            spriteKitView()
        } else {
            NavigationView{
                ZStack{
                    Color.ui.backgroundColor.ignoresSafeArea()
                    ScrollView {
                        LazyVGrid(columns: twoColumnGrid, spacing: 8) {
                            ForEach(viewModel.artists.filter {
                                self.search.isEmpty ? true : $0.name.lowercased().contains(self.search.lowercased())
                            }, id: \.self){ artist in
                                OneArtist(artist: artist)
                            }
                        }
                    }
                }
                .navigationBarTitle("Artists")
                .accentColor(Color.ui.white)
                .navigationBarItems(leading:
                                        HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $search)
                        .foregroundColor(.primary)
                }
                )
            }
            
        }
    }
}


extension ArtistGridView{
    var Loading: some View{
        ZStack{
            Color
                .ui.backgroundColor
                .ignoresSafeArea()
            ProgressView("").progressViewStyle(CircularProgressViewStyle(tint: Color.ui.yellow))
        }
       
    }
}


struct OneArtist: View {
    var artist: Artist
    @State private var path = [String]()
    
    var body: some View {
        VStack(alignment: .leading){
            UrlImage(urlStrign: artist.photo, width: 172, heigh: 163)
                .padding(.bottom, 8)
            HStack{
                Text(artist.name)
                    .font(.callout.bold())
                    .foregroundColor(Color.ui
                        .white)
                Spacer()
                NavigationLink(destination: ArtistDetailsView(artistId: artist.id)) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(Color.ui.white)
                }
            }
            .padding(.bottom, 16)
        }
        .frame(width: 172, height: 234)
    }
}


struct ArtistGridView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistGridView()
    }
}
