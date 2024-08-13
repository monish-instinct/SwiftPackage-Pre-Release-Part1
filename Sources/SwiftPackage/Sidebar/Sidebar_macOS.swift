//
//  Sidebar_macOS.swift
//  RD Vivaha Jewellers
//
//  Created by Raghul S on 31/12/23.
//

#if os(macOS) || os(visionOS)

import SwiftUI

struct ContentView: View {
    @State private var selectedItem: String? = "Billing and Quotation"
    @State private var columnVisiblity = NavigationSplitViewVisibility.all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisiblity){
            Sidebar(selectedItem: $selectedItem)
                .frame(minWidth: 270, idealWidth: 270, maxWidth: 270, maxHeight: .infinity)
            #if os(macOS)
                .background(VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow, isEmphasized: true))
            #endif
            
        }detail:{
            
        }
    }
}

struct Sidebar: View {
    @Binding var selectedItem: String?
    let sideBarFontSize: CGFloat = 16
    let spacingValue: CGFloat = 5

    var body: some View {
        List(selection: $selectedItem) {
            NavigationLink(destination: HomeView(), tag: "Home", selection: $selectedItem) {
                Label("Home", systemImage: "house")
                    .font(.system(size: sideBarFontSize))
                    .padding(.vertical, spacingValue)
            }
            NavigationLink(destination: AIView(), tag: "Artificial Intelligence", selection: $selectedItem) {
                Label("Artificial Intelligence", systemImage: "brain")
                    .font(.system(size: sideBarFontSize))
                    .padding(.vertical, spacingValue)
            }
            NavigationLink(destination: DesignerView(), tag: "Designer", selection: $selectedItem) {
                Label("Designer", systemImage: "paintbrush")
                    .font(.system(size: sideBarFontSize))
                    .padding(.vertical, spacingValue)
            }
            NavigationLink(destination: ProfileView(), tag: "My Profile", selection: $selectedItem) {
                Label("My Profile", systemImage: "person.crop.circle")
                    .font(.system(size: sideBarFontSize))
                    .padding(.vertical, spacingValue)
            }
            NavigationLink(destination: SearchView(), tag: "Smart Search", selection: $selectedItem) {
                Label("Smart Search", systemImage: "magnifyingglass")
                    .font(.system(size: sideBarFontSize))
                    .padding(.vertical, spacingValue)
            }
            Divider()
            NavigationLink(destination: Billing(), tag: "Billing and Quotation", selection: $selectedItem) {
                Label("Billing and Quotation", systemImage: "creditcard")
                    .font(.system(size: sideBarFontSize))
                    .padding(.vertical, spacingValue)
            }
        }
        .font(.system(size: 25)) // Adjust the font size as needed
        .listStyle(SidebarListStyle())
    }
}

#endif
