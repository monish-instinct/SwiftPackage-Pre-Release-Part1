//
//  RD_Vivaha_JewellersApp.swift
//  RD Vivaha Jewellers
//
//  Created by Raghul S on 01/01/24.
//

import SwiftUI

@main
struct RD_Vivaha_JewellersApp: App {
    @State private var name: String = ""
    @State private var email: String = ""
    @StateObject var syncController = SynchronizationController()
    @StateObject var rneStarter = RaghulsNeuralEngineStarter()
    @StateObject var appStarter = Initializer()
    @ObservedObject var locationManager = stateGPS()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(syncController)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        HStack {
                            Text(syncController.centerText)
                            Spacer()
                            Button(syncController.prgoressText){
                                
                            }
                            .padding(20)
                            .fixedSize()
                            ProgressView(value: syncController.prgoress)
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1)
                        }
                    }
                }
                .onAppear {
                    let databaseSynchronizer = DatabaseSynchronizer(syncController: syncController)
                    databaseSynchronizer.startSynchronization()
                }
            #if os(macOS)
            .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow, isEmphasized: true))
            .frame(minWidth: 1200, minHeight: 600)
            #endif
        }
    }
}
