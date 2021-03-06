//
//  SettingsView.swift
//  AniHyou
//
//  Created by Axel Lopez on 22/7/22.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showLogOutDialog = false
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        Form {
            Section {
                Link("AniList account settings", destination: URL(string: "https://anilist.co/settings/account")!)
            } footer: {
                Text("You may need to login again in your browser")
            }
            
            Button("Log out", role: .destructive) {
                showLogOutDialog = true
            }
            .confirmationDialog("Are you sure you want to log out?", isPresented: $showLogOutDialog) {
                Button("Log out", role: .destructive) {
                    viewModel.logOut()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
            
            Section {
                Link("GitHub repository", destination: URL(string: "https://github.com/axiel7/AniHyou")!)
                Text("Developed by axiel7")
            } header: {
                Text("Information")
            } footer: {
                Text("Version \(appVersion ?? "")")
            }
            
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
