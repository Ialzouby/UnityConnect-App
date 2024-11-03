//
//  MainTabView.swift
//  UnityConnector
//
//  Created by TechnoLab on 11/2/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            UnityHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ChatListView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chats")
                }
            
            EventsView() // New events view tab
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            

        }
    }
}
