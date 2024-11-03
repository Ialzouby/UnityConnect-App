import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Profile Header
            HStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text("Welcome,")
                        .font(.headline)
                        .foregroundColor(.gray)
                    if let profile = authViewModel.userProfile {
                        Text(profile.username)
                            .font(.title)
                            .fontWeight(.bold)
                    } else {
                        Text("Loading...")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Divider()
                .padding(.vertical, 10)
            
            // Profile Details
            if let profile = authViewModel.userProfile {
                VStack(spacing: 16) {
                    ProfileDetailRow(icon: "person.fill", title: "First Name", value: profile.firstName)
                    ProfileDetailRow(icon: "person.fill", title: "Last Name", value: profile.lastName)
                    ProfileDetailRow(icon: "envelope.fill", title: "Email", value: profile.email)
                    ProfileDetailRow(icon: "globe", title: "Preferred Language", value: profile.preferredLanguage)
                }
                .padding(.horizontal)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            } else {
                Text("Loading profile...")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Sign Out Button
            Button(action: {
                authViewModel.signOut()
            }) {
                Text("Sign Out")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// Custom view for each profile detail row
struct ProfileDetailRow: View {
    var icon: String
    var title: String
    var value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
