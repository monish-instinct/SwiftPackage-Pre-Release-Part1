////
////  AccessDenied_iOS.swift
////  RD Vivaha Jewellers
////
////  Created by Raghul S on 17/03/24.
////
//
//import SwiftUI
//import UIKit
//import AVFoundation
//
//struct DeniedAccessAlertView: View {
//    @Binding var isPresented: Bool
//    var onContactTechTeam: () -> Void
//
//    // Starting offsets for the swords off-screen on the left and right
//    @State private var leftSwordOffset = CGSize(width: -UIScreen.main.bounds.width / 2, height: 0)
//    @State private var rightSwordOffset = CGSize(width: UIScreen.main.bounds.width / 2, height: 0)
//    @State private var audioPlayer: AVAudioPlayer?
//
//    var body: some View {
//        ZStack {
//            Color.brightRed.edgesIgnoringSafeArea(.all)
//            VStack(spacing: 16) {
//                VStack(spacing: 16) {
//                    Image("access")
//                        .resizable()// Use the exact name of your access image asset
//                        .scaledToFit()
//                        .frame(width: 500, height: 200)
//                }
//                // Swords that will cross each other
//                ZStack {
//                    // Left sword
//                    Image("sword")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 200, height: 200)
//                        .offset(leftSwordOffset)
//                        .rotationEffect(.degrees(0)) // Adjust as needed
//                    
//                    // Right sword
//                    Image("sword")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 200, height: 200)
//                        .scaleEffect(x: -1, y: 1) // Flip the right sword horizontally
//                        .offset(rightSwordOffset)
//                        .rotationEffect(.degrees(-0)) // Adjust as needed
//                }
//                .onAppear {
//                    // Trigger haptic feedback
//                    playSound()
//                    let generator = UIImpactFeedbackGenerator(style: .heavy)
//                    generator.prepare()
//                    withAnimation(.easeInOut(duration: 0.1)){
//                        // Move the swords to the center
//                        leftSwordOffset = CGSize(width: 0, height: 0)
//                        rightSwordOffset = CGSize(width: 0, height: 0)
//                    }
//                    generator.impactOccurred()
//                }
//                VStack{
//                    Button(action: onContactTechTeam) {
//                        Text("Contact Our Tech Team")
//                    }
//                    .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.bloodRed)
//                        .cornerRadius(10)
//                        .bold()
//                        .frame(width:300)
//                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                    Button(action: onContactTechTeam) {
//                        Text("Go Back")
//                    }   .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.bloodRed)
//                        .cornerRadius(10)
//                        .bold()
//                        .frame(width:300)
//                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                }
//            }
//        }
//        .padding()
//        .ignoresSafeArea()
//    }
//    
//    
//    
//    func playSound() {
//        print("Mohan")
//        guard let path = Bundle.main.path(forResource: "swordsoundeffect", ofType: "mp3") else {
//            print("Could not find the sound file.")
//            return
//        }
//        let url = URL(fileURLWithPath: path)
//        
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.play()
//        } catch {
//            print("Could not load the file: \(error)")
//        }
//    }
//
//
//}
//
//
