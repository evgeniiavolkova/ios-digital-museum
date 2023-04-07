//
//  ContentView.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 15.01.2023.
//

import SwiftUI
import URLImage

struct ArtHubView: View {
    @StateObject var viewModel = ArtHubViewModel()
    @State private var path = [String]()
    @State var randomPainting = Paiting(id: "", artistId: "", date: "", description: "", latitude: 0.0, longitude: 0.0, name: "🤩", pictureUrl: "")
    @State var showSplash = true
    
    var body: some View {
        Group{
            if self.showSplash{
                SplashScreen()
            } else {
                ZStack{
                    Color
                        .ui.backgroundColor
                        .ignoresSafeArea()
                    if (viewModel.isLoading == true){
                        spriteKitView()
                    } else{
                        NavigationStack(path: $path){
                            ZStack{
                                Color
                                    .ui.backgroundColor
                                    .ignoresSafeArea()
                                ScrollView(){
                                    VStack{
                                        Text("Explore a world of arts and culture")
                                            .font(.system(size: 34, weight: .bold)).foregroundColor(Color.yellow).tracking(0.37)
                                        Spacer()
                                        ZStack{
                                            if (viewModel.randomPaintig.pictureUrl != ""){
                                                URLImage(URL(string: viewModel.randomPaintig.pictureUrl)!){image in
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 393, height: 398)
                                                        .clipped()
                                                        .overlay(
                                                            Color.black.opacity(0.3)
                                                        )
                                                }
                                            }
                                            VStack{
                                                Spacer().frame(height: 180)
                                                HStack{
                                                    VStack(alignment: .leading){
                                                        Text("featured")
                                                            .font(.system(size: 18, weight: .semibold))
                                                            .foregroundColor(Color.ui.white)
                                                            .padding(.bottom, 8)
                                                        Text(viewModel.randomPaintig.name).padding(.bottom, 24)
                                                        NavigationLink(destination: PaintingsDetailsView(paintingId: viewModel.randomPaintig.id)) {
                                                            HStack {
                                                                Text("Learn more")
                                                                    .font(.system(size: 18, weight: .semibold))
                                                                    .foregroundColor(Color.ui.white)
                                                                Image(systemName: "arrow.right")
                                                                    .foregroundColor(Color.ui.white)
                                                            }
                                                        }
                                                    }
                                                    Spacer().frame(width: 200)
                                                }
                                            }
                                        }
                                        Spacer().frame(height: 44)
                                        VStack(){
                                            Spacer()
                                            Text("Use the camera to find the art right now")
                                                .foregroundColor(Color.ui.white)
                                                .padding(.bottom, 8)
                                            CameraButton(action: {
                                                path.append("cameraViewNav")
                                            })
                                            Spacer()
                                                .frame(height: 22)
                                                .background(Color.clear)
                                        }.frame(width: 393, height: 120)
                                            .background(Image("DavidCustomFrame"))
                                        Spacer().frame(height: 24)
                                        VStack {
                                            HStack() {
                                                Text("Paintings")
                                                    .foregroundColor(Color.ui.white)
                                                    .font(.headline)
                                                    .padding(.leading, 24)
                                                Spacer()
                                                CustomNavigateButton(title: "see more", clicked: {
                                                    path.append("paintingsGridNav")
                                                })
                                            }
                                            ScrollView(.horizontal) {
                                                HStack(spacing: 16) {
                                                    ForEach(viewModel.paintings, id: \.self) { painting in
                                                        VStack(alignment: .leading) {
                                                            URLImage(URL(string: painting.pictureUrl)!){ it in
                                                                it.resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .frame(width: 180, height: 180)
                                                                    .cornerRadius(6)
                                                                    .clipped()
                                                            }
                                                            Text(painting.name)
                                                                .foregroundColor(Color.ui.white)
                                                                .lineLimit(1)
                                                                .truncationMode(.middle)
                                                        }.frame(width: 181, height: 181)
                                                    }
                                                }
                                                .padding()
                                            }
                                        }
                                        Spacer().frame(height: 44)
                                        VStack {
                                            HStack() {
                                                Text("Artists")
                                                    .foregroundColor(Color.ui.white)
                                                    .font(.headline)
                                                    .padding(.leading, 24)
                                                Spacer()
                                                CustomNavigateButton(title: "see more", clicked: {
                                                    path.append("artistGridNav")
                                                })
                                            }
                                            ScrollView(.horizontal) {
                                                HStack(spacing: 16) {
                                                    ForEach(viewModel.artists, id: \.self) { artist in
                                                        VStack(alignment: .leading) {
                                                            URLImage(URL(string: artist.photo)!){ it in
                                                                it.resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .frame(width: 180, height: 180)
                                                                    .cornerRadius(6)
                                                                    .clipped()
                                                            }
                                                            Text(artist.name)
                                                                .foregroundColor(Color.ui.white)
                                                                .lineLimit(1)
                                                                .truncationMode(.middle)
                                                        }.frame(width: 181, height: 181)
                                                    }
                                                }
                                                .padding()
                                            }
                                        }
                                    }
                                }
                                
                                .toolbar{
                                    ToolbarItem(placement: .navigationBarTrailing){
                                        Button{
                                            path.append("cameraViewNav")
                                        } label: {
                                            Label("Camera", systemImage: "camera.fill")
                                                .foregroundColor(Color.yellow)
                                        }
                                    }
                                }
                                .navigationDestination(for: String.self){ string in
                                    switch(string) {
                                    case "cameraViewNav": CameraView()
                                    case "artistGridNav": ArtistGridView()
                                    case "paintingsGridNav":PaintingsGridView()
                                    default:
                                        EmptyView()
                                    }
                                }
                            }
                            
                            
                        }
                        
                    }
                }
            }
            
        }.onAppear{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showSplash = false
               
            }
            
        }
        
    }
}
struct CameraButton: View {
    var action: () -> Void

    var body: some View {
        
        Button(action: action) {
            HStack {
                Image(systemName: "camera")
                Text("Use camera")
            }
        }
        .frame(width: 318, height: 56)
        .foregroundColor(.white)
        .font(.system(size: 20))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.white, lineWidth: 1))
    }
}


struct CustomNavigateButton: View{
    var title: String? = nil
    var clicked: (() -> Void)
    var body: some View{
        Button(action: clicked){
            
            Text(title ?? "").font(.system(size: 17, weight: .regular)).foregroundColor(Color.ui.white)
                .padding(.trailing, 8)
            Image(systemName: "arrow.right")
                .foregroundColor(Color.ui.white)
        }.frame(width: 115, height: 22)
    }
}

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack{
                Image("splashScreen")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("Make people curious again")
                    .font(.system(size: 44, weight: .black))
                    .foregroundColor(Color.ui.yellow)
            }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArtHubView()
    }
}
