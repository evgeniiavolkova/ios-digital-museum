//
//  UrlImage.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 15.01.2023.
//

import SwiftUI


struct UrlImage: View {
    
    let urlStrign: String
    @State var data: Data?
    var width: CGFloat
    var heigh: CGFloat
    
    
    var body: some View{
        
        if let data = data, let uiimage = UIImage(data: data){
            Image(uiImage: uiimage)
                .resizable()
                .scaledToFill()
                .frame(width: self.width, height: self.heigh)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))
        } else {
            Image(systemName: "video")
                .frame(width: self.width, height: self.heigh)
                .scaledToFit()
                .background(Color.black)
                .onAppear{
                    fetchData()
                }
        }
    }
    
    private func fetchData(){
        guard let url = URL(string: urlStrign) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ data, _, _ in
            self.data = data
        }
        task.resume()
    }
}

struct UrlImage_Previews: PreviewProvider {
    static var previews: some View {
        UrlImage(urlStrign: "https://upload.wikimedia.org/wikipedia/commons/6/66/VanGogh-starry_night_ballance1.jpg", width: 180.5, heigh: 180.5)
    }
}

