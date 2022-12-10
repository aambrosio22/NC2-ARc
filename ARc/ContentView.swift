//
//  ContentView.swift
//  ARc
//
//  Created by Antonia Ambrosio on 07/12/22.
//

import SwiftUI
import RealityKit
import ARKit

/*struct MyDetent: CustomPresentationDetent {
    // 1
    static func height(in context: Context) -> CGFloat? {
        // 2
        return max(50, context.maxDetentValue * 0.1)
    }
}*/


struct ContentView: View {
    @State var presentSheet = true
    @State var trigger = false
    var body: some View {
        NavigationView {
            ZStack{
                //This calls our ARView In the User Interface
                ARViewContainer(trigger: self.$trigger)
                    //This ensures that our ARView occupies all the screen
                    .edgesIgnoringSafeArea(.all)
                    //This change the state of our trigger (You shot)
                    .onAppear{
                        trigger = true
                        presentSheet = true
                    }
            }
        }
        
            .sheet(isPresented: $presentSheet) {
                    Text("Detail")
                    //array di text con i paragrafi
                        //.presentationDetents([.custom(MyDetent.self)])
                    .presentationDetents([.medium, .large, .height(44)])
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled(true)
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
