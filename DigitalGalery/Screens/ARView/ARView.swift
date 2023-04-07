//
//  ARView.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 21.01.2023.
//

import ARKit
import SwiftUI

struct ARView: UIViewRepresentable {
    var imageURL: URL
    
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        let scene = SCNScene()
        arView.scene = scene
        arView.automaticallyUpdatesLighting = true
        arView.session.delegate = context.coordinator
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if error != nil {
                print("😫😫😫 Error loading image: \(error!)")
            }
            print("🤩 Image OK ")
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    let material = SCNMaterial()
                    material.diffuse.contents = image
                    let canvasNode = SCNNode()
                    canvasNode.geometry = SCNPlane(width: 0.53, height: 0.7)
                    canvasNode.geometry?.materials = [material]
                    canvasNode.position = SCNVector3(0, 0, -0.5)
                    uiView.scene.rootNode.addChildNode(canvasNode)
                }
            }
        }.resume()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARView
        
        init(_ parent: ARView) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            // handle error
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            // handle interruption
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            // resume session
        }
    }
}

