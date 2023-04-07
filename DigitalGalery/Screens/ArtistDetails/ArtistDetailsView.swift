//
//  ArtistDetailsView.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 20.01.2023.
//

import SwiftUI

struct ArtistDetailsView: View {
    @State private var nav = NavigationPath()
    @StateObject var viewModel: ArtistDetailsViewModel
    
    init(artistId: String) {
        self._viewModel = StateObject(wrappedValue: ArtistDetailsViewModel(artistId: artistId))
    }
   
    var body: some View {
        ZStack{
            Color.ui.backgroundColor.ignoresSafeArea()
            if (viewModel.artistPhoto == nil){
                Loading
            } else {
                ScrollView(){
                    DataLoaded
                    if viewModel.paitings?.isEmpty ?? true {
                                Text("While in our gallery there are no works of this artist")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .padding()
                    } else {
                        VStack {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                ForEach(viewModel.paitings ?? [], id: \.id) { painting in
                                    OnePaiting(paiting: painting)
                                }
                            }
                        }
                    }
                }
               
                
            }
        }

    }
}
extension ArtistDetailsView{
    var DataLoaded: some View{
        ZStack(alignment: .top) {
            Image(uiImage: viewModel.artistPhoto ?? UIImage(imageLiteralResourceName: "PlaceHolder"))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 393)
                .blur(radius: 10)
                .overlay(
                    VStack(alignment: .center, spacing: 8) {
                        VStack{
                            Text(viewModel.artist.name)
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Text(viewModel.artist.birthday)
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding(.bottom, 64)
                            Text(viewModel.artist.biography)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .italic()
                        }.frame(width: 342)
                            .padding(16)
                        HStack {
                            Text("Best from this Artist")
                                .foregroundColor(.white)
                                .font(.subheadline)
                            Image(systemName: "arrow.down")
                                .foregroundColor(.white)
                        }
                    }
                )
        }
    }
}

extension ArtistDetailsView{
    var Loading: some View{
        ZStack{
            Color
                .ui.backgroundColor
                .ignoresSafeArea()
            ProgressView("").progressViewStyle(CircularProgressViewStyle(tint: Color.ui.yellow))
        }
       
    }
}

struct OnePaiting: View {
    var paiting: Paiting
    @State private var path = [String]()
    
    var body: some View {
        VStack(alignment: .leading){
            UrlImage(urlStrign: paiting.pictureUrl, width: 172, heigh: 163)
                .padding(.bottom, 8)
            HStack{
                Text(paiting.name)
                    .font(.callout.bold())
                    .foregroundColor(Color.ui
                        .white)
                Spacer()
                NavigationLink(destination: PaintingsDetailsView(paintingId: paiting.id)) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(Color.ui.white)
                }
            }
            .padding(.bottom, 16)
        }
        .frame(width: 172, height: 234)
    }
}

struct ArtistDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailsView(artistId: "6")
    }
}
