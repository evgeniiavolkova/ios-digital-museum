//
//  TopBarApp.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 15.01.2023.
//

import SwiftUI
extension View {
public func appBar(title: String, backButtonAction: @escaping() -> Void) -> some View {
    
    self
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            backButtonAction()
        }) {
            Image("ic-back") // set backbutton image here
                .renderingMode(.template)
                .foregroundColor(Color.white)
        })
    }
}
