//
//  SpriteKitView.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 23.01.2023.
//

import Foundation
import SwiftUI
import SpriteKit

struct spriteKitView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        
        let scene = SKScene(size: CGSize(width: 80, height: 80))
        scene.scaleMode = .aspectFill

        let sprite = SKSpriteNode(imageNamed: "loading")
        sprite.size = CGSize(width: 12, height: 12)
        sprite.position = CGPoint(x: 40, y: 40)
        
        let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 2)

        let rotateForever = SKAction.repeatForever(rotate)

        sprite.run(rotateForever)

        scene.addChild(sprite)

        view.presentScene(scene)
        return view

    }
    func updateUIView(_ uiView: SKView, context: Context) {
        
        }
}
