import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isLoggedIn {
            MainTabView() // Show the main app view if logged in
        } else {
            LoginView() // Show login/signup view if not logged in
        }
    }
}

