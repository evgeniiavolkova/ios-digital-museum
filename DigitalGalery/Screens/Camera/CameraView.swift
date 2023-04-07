//
//  CameraView.swift
//  DigitalGalery
//
//  Created by Евгения Волкова on 19.01.2023.
//

import SwiftUI
import CoreML


struct CameraView: View {
    
    @State private var isSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    let imagePredictor = ImagePredictor()
    let predictionsToShow = 5
    
    @State private var image: UIImage?
    @State private var analyzedOutputText: String? = nil
    @State private var showPredictionsSheet = false
    @State private var predictions: [ImagePredictor.Prediction]?
    
    var body: some View {
        NavigationView{
            ZStack{
                Color
                    .ui.backgroundColor
                    .ignoresSafeArea()
                VStack{
                    
                    if image != nil{
                        Image(uiImage: image!)
                            .resizable()
                            .frame(width: 300, height: 300)
                            .background(Color.ui.yellow)
                            .cornerRadius(16)
                            .padding()
                    } else {
                        Image(systemName: "camera")
                            .frame(width: 300, height: 300)
                            .background(Color.ui.yellow)
                            .cornerRadius(16)
                            .padding()
                    }
                    
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            if self.image != nil {
                                self.classifyImage(image!)
                            }
                        }, label: {
                            Label("Analyze", systemImage: "magnifyingglass")
                                .frame(width: 150, height: 32)
                                .padding()
                                .background(Color.ui.yellow)
                                .foregroundColor(Color.ui.backgroundColor)
                                .fontWeight(Font.Weight.bold)
                                .clipShape(Capsule())
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            self.isSheet = true
                        }, label: {
                            Label("Photo", systemImage: "photo")
                                .frame(width: 150, height: 32)
                                .padding()
                                .background(Color.ui.yellow)
                                .foregroundColor(Color.ui.backgroundColor)
                                .fontWeight(Font.Weight.bold)
                                .clipShape(Capsule())
                        })
                        Spacer()
                        
                    }
                    if analyzedOutputText != nil{
                        VStack(alignment: .center){
                            Spacer()
                            Text(analyzedOutputText ?? "")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(Color.ui.white)
                            Spacer()
                        }
                    }
                    Spacer()
                        .frame(height: 220)
                    
                    .actionSheet(isPresented: $isSheet){
                        ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
                            .default(Text("Photo Library")) {
                                self.showImagePicker = true
                                self.sourceType = .photoLibrary
                                
                            },
                            .default(Text("Camera")) {
                                self.showImagePicker = true
                                self.sourceType = .camera
                            },
                            .cancel()
                        ])
                    }
                }

            }
            .sheet(isPresented: $showImagePicker){
                ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            }
        }
    }
    
    private func classifyImage(_ image: UIImage) {
        do {
            try self.imagePredictor.makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }
    
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            print("No predictions. (Check console log.)")
            return
        }

        let formattedPredictions = formatPredictions(predictions)

        let predictionString = formattedPredictions.joined(separator: "\n")
        print(predictionString)
        analyzedOutputText = predictionString
        
    }
    
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification
            name = prediction.classification.replacingOccurrences(of: "_", with: " ")

            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name) - \(prediction.confidencePercentage)%"
        }

        return topPredictions
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
