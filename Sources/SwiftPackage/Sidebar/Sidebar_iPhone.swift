//
//  Sidebar_iPhone.swift
//  RD Vivaha Jewellers
//
//  Created by Raghul S on 31/12/23.
//

import SwiftUI

#if os(iOS)

struct ContentView: View {
    @State private var selectedItem: String? = "Billing and Quotation"
    @State private var isShowingSidebar = false

    var body: some View {
        NavigationView{
            List{
                Section{
                    topSidebar(selectedItem: $selectedItem)
                }
                Section{
                    bottomSidebar(selectedItem: $selectedItem)
                }
            }
            .navigationBarTitle("Auruvie")
            .navigationBarItems(leading: Button(action: {
                self.isShowingSidebar.toggle()
            }) {
                Image(systemName: "line.horizontal.3")
            })
        }
    }
}

struct topSidebar: View {
    @Binding var selectedItem: String?
    let sideBarFontSize: CGFloat = 16
    let spacingValue: CGFloat = 5
    
    var body: some View {
            NavigationLink(destination: HomeView(), tag: "Home", selection: $selectedItem) {
                Label("Home", systemImage: "house")
            }
            NavigationLink(destination: AIView(), tag: "Artificial Intelligence", selection: $selectedItem) {
                Label("Artificial Intelligence", systemImage: "brain")
            }
            NavigationLink(destination: DesignerView(), tag: "Designer", selection: $selectedItem) {
                Label("Designer", systemImage: "paintbrush")
            }
            NavigationLink(destination: ProfileView(), tag: "My Profile", selection: $selectedItem) {
                Label("My Profile", systemImage: "person.crop.circle")
            }
            NavigationLink(destination: SearchView(), tag: "Smart Search", selection: $selectedItem) {
                Label("Smart Search", systemImage: "magnifyingglass")
            }
        }
}


struct bottomSidebar: View {
    @Binding var selectedItem: String?
    let sideBarFontSize: CGFloat = 16
    let spacingValue: CGFloat = 5
    
    var body: some View {
        NavigationLink(destination: Billing(), tag: "Billing and Quotation", selection: $selectedItem) {
            Label("Billing and Quotation", systemImage: "creditcard")
        }
    }
}


#endif

struct HomeView: View { var body: some View { Text("Home View Content") } }
struct AIView: View { var body: some View { Text("AI View Content") } }
struct DesignerView: View { var body: some View { Text("Designer View Content") } }
struct ProfileView: View { var body: some View { Text("Profile View Content") } }
struct SearchView: View { var body: some View { Text("Search View Content") } }
