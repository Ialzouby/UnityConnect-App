import SwiftUI

struct UnityHomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Header Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("UnityConnect")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.primary)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(Text("UnityConnect").font(.system(size: 40, weight: .bold)))
                        )
                    
                    Text("Your Bridge To Community And Belonging")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Features Section
                VStack(spacing: 15) {
                    FeatureCard(iconName: "globe", title: "Language Exchange Pairing")
                    FeatureCard(iconName: "exclamationmark.triangle.fill", title: "Emergency and Legal Support Information")
                    FeatureCard(iconName: "person.2.fill", title: "Support Chat with Volunteer Mentors")
                    FeatureCard(iconName: "calendar", title: "Cultural and Community Events")
                    FeatureCard(iconName: "map.fill", title: "Resource Directory with Maps")
                    FeatureCard(iconName: "text.bubble", title: "Real-Time Translation for Conversations")
                }
                .padding(.horizontal)
                
                // Call to Action
                Button(action: {
                    // Action for "Get in Touch"
                }) {
                    Text("Get in Touch")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
            }
            .padding(.vertical)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// FeatureCard component
struct FeatureCard: View {
    var iconName: String
    var title: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 50, height: 50)
                
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 4)
    }
}
