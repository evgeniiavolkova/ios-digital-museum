//
//  PaintingsDetailsView.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 21.01.2023.
//

import SwiftUI
import SpriteKit
import ARKit
import URLImage

struct PaintingsDetailsView: View {
    @StateObject var viewModel: PaintingDetailsViewModel
    @State private var showARView: Bool = false
    @State private var isTapped = false
    @State private var path = [String]()
    //    let imageURL: URL
    
    init(paintingId: String) {
        self._viewModel = StateObject(wrappedValue: PaintingDetailsViewModel(paitingId: paintingId))
        
    }
    
    var body: some View {
        if(viewModel.isLoading == true){
            spriteKitView()
        } else {
            
            NavigationView {
                ZStack{
                    Color.ui.backgroundColor.ignoresSafeArea()
                    ScrollView(){
                        VStack{
                            UrlImage(urlStrign: viewModel.painting?.pictureUrl ?? viewModel.defImageValue, width: 393, heigh: 376)
                                .frame(width: 393, height: 376)
                                .overlay(
                                    ZStack {
                                        if isTapped {
                                            Rectangle()
                                                .fill(Color.black.opacity(0.5))
                                            NavigationLink(destination: ARView(imageURL: URL(string: viewModel.painting?.pictureUrl ?? viewModel.defImageValue)!)){
                                                Image(systemName: "arkit")
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                    .foregroundColor(.white)
                                            }
                                            
                                        }
                                    }
                                )
                                .onTapGesture {
                                    self.isTapped.toggle()
                                }
                            Spacer(minLength: 44)
                            Group{
                                VStack(alignment: .leading){
                                    HStack(){
                                        Text(viewModel.painting?.name ?? "")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundColor(Color.ui.white)
                                        Spacer()
                                        Text(viewModel.painting?.date ?? "")
                                            .font(.system(size: 24, weight: .regular))
                                            .foregroundColor(Color.ui.white)
                                    }
                                    
                                    Spacer()
                                    HStack(){
                                        Text(viewModel.artist?.name ?? "")
                                            .font(.system(size: 20, weight: .semibold)).foregroundColor(Color.ui.yellow)
                                        NavigationLink(destination: ArtistDetailsView(artistId: viewModel.artist?.id ?? "1")){
                                            Image(systemName: "arrow.right")
                                                .foregroundColor(Color.ui.yellow)
                                        }
                                    }
                                    Spacer()
                                    Text(viewModel.painting?.description ?? "")
                                        .font(.system(size: 16, weight: .regular)).foregroundColor(Color.ui.white)

                                }
                                .padding([.leading, .trailing], 24)
                            }
                        }
                    }
                }
            }
        }
    }
}


struct PaintingsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PaintingsDetailsView(paintingId: "7x1Nh1GXV6n5OPSq8E8i")
    }
}


//    VStack {
//        Text(viewModel.artist?.name ?? "Unknown artist")
//
//        let imageURL = URL(string: viewModel.painting?.pictureUrl ?? viewModel.defImageValue)
//        NavigationLink(destination: ARView(imageURL: imageURL!)) {
//            Text("Open AR View")
//        }
//    }
//}

/*
 
 var body: some View {
     if(viewModel.isLoading == true){
         spriteKitView()
     } else {
         
         NavigationStack(path: $path) {
             ZStack{
                 Color.ui.backgroundColor.ignoresSafeArea()
                 
                 UrlImage(urlStrign: viewModel.painting?.pictureUrl ?? viewModel.defImageValue, width: 393, heigh: 376)
                     .frame(width: 393, height: 376)
                     .overlay(
                         ZStack {
                             if isTapped {
                                 Rectangle()
                                     .fill(Color.black.opacity(0.5))
                                 Button{
                                     path.append("arNav")
                                 }label: {
                                     Image(systemName: "arkit")
                                         .resizable()
                                         .frame(width: 50, height: 50)
                                         .foregroundColor(.white)
                                 }

                             }
                         }
                     )
                     .onTapGesture {
                         self.isTapped.toggle()
                     }
             }
             .navigationDestination(for: String.self){ string in
                 switch(string) {
                 case "arNav": ARView(imageURL: URL(string: viewModel.painting?.pictureUrl ?? viewModel.defImageValue)!)
                 default: EmptyView()
                 }
             }
         }
     }
 }
 
 */
