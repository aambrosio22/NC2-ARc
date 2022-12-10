//
//  ARViewContainer.swift
//  ARc
//
//  Created by Antonia Ambrosio on 07/12/22.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    
    //It's our trigger again, cause we need to check and modify it
    @Binding var trigger: Bool
    
    //This function creates the ARView
    func makeUIView(context: Context) -> ARView {
        //Declare our ARView
        //The frame does not matter at UIView creation time (ie. in makeUIView), because constructed view will
        //be resized according to final layout in container view and resulting frame will be passed in UIView.draw
        let arView = ARView(frame: .zero)
        
        //This is the configuration of the AR world
        let config = ARWorldTrackingConfiguration()
        //And with this we declare what planes do we want to detect
        config.planeDetection = [.horizontal, .vertical]
        
        //This makes sure the textures are illuminated
        config.environmentTexturing = .automatic
        
        //ARKit provides a polygonal mesh that estimates the shape of the physical environment
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        //And we run the session with the applied configuration
        arView.session.run(config)
        
        //This calls the addCoaching function for the AR Coach
        //In case the app is not runned in the simulator ONLYs
        #if !targetEnvironment(simulator)
        //Add Coaching
        arView.addCoaching()
        #endif
        
        //It is mandatory to return the scene
        return arView
    }
    
    //This function updates the ARView
    func updateUIView(_ ourView: ARView, context: Context) {
        //Scale the object we are going to put according to this value
        let scalingFactor: Float = 0.007
        
        //If the trigger turns on
        if self.trigger == true {
            //With this we declare the model we want to put in the ARView, try? is to give an optional
            //value in case something doesn't load from the name (named: "") provided in the code
            let modelWeWantToPlace = try? ModelEntity.loadModel(named: "Monkey.usdz")
            //Scale the model according to *scalingFactor*, proportional[X, Y, Z]
            modelWeWantToPlace?.scale = [scalingFactor, scalingFactor, scalingFactor]
            //Creates an anchor related to the horizontal planes
            let anchorOfTheView = AnchorEntity(plane:.horizontal)
            //Connect the model to the Anchor
            anchorOfTheView.addChild(modelWeWantToPlace!)
            //Place the anchor in the scene
            ourView.scene.addAnchor(anchorOfTheView)
            
            //And then with an async function we are gonna turn the trigger back to false
            //Ready for another shot
            DispatchQueue.main.async {
                self.trigger = false
            }
        }
    }
    
}

//This is an extension of the ARView variable
extension ARView: ARCoachingOverlayViewDelegate {
    //This is the function that will be called when we need to coach the user
    //This means when the phone doesn't perceive anymore a space/plane
    func addCoaching() {
        //ARKit related View
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        //In case the app is not in the simulator
        #if !targetEnvironment(simulator)
        coachingOverlay.session = self.session
        #endif
        //Resizing mask
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //To switch plane (Vertical, Horizontal)
        coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
    }
    
    //Deactivation of the coaching
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("did deactivate")
    }
}


