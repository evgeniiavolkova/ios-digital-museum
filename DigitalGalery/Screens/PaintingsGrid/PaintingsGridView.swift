//
//  PaintingsGridView.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 21.01.2023.
//

import SwiftUI
import URLImage

struct PaintingsGridView: View {
    @ObservedObject var viewModel = PaintingsGridViewModel()
    private var twoColumnGrid =  [GridItem(.flexible()), GridItem(.flexible())]
    @State private var search = ""
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                spriteKitView()
            } else {
                NavigationView{
                    ZStack{
                        Color.ui.backgroundColor.ignoresSafeArea()
                        ScrollView {
                            LazyVGrid(columns: twoColumnGrid, spacing: 8) {
                                ForEach(viewModel.paintings.filter {
                                    self.search.isEmpty ? true : $0.name.lowercased().contains(self.search.lowercased())
                                }, id: \.self){ painting in
                                    
                                    OnePaiting(paiting: painting)
                                }
                            }
                        }
                    }
                    .navigationBarTitle("Paintings")
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
}

struct OnePainting: View {
    var painting: Paiting
    @State private var image: UIImage?
    
    var body: some View {
        VStack(alignment: .leading){
            if let image = image{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 172, height: 163)
                    .clipped()
                    .padding(.bottom, 8)
            } else {
                URLImage(URL(string: painting.pictureUrl)!){image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 172, height: 163)
                        .clipped()
                }.padding(.bottom, 8)
                
            }
            HStack{
                Text(painting.name)
                    .font(.callout.bold())
                    .foregroundColor(Color.ui
                        .white)
                Spacer()
                NavigationLink(destination: PaintingsDetailsView(paintingId: painting.id)) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(Color.ui.white)
                }
            }
            .padding(.bottom, 16)
        }
        .frame(width: 172, height: 234)
    }
}

struct PaintingsGridView_Previews: PreviewProvider {
    static var previews: some View {
        PaintingsGridView()
    }
}
