
---

# UnityConnector

![Typing GIF](https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif)

UnityConnector is a comprehensive community-driven application that provides real-time translations, language exchange pairings, event management, and essential support features. Built using Swift and Xcode, the app integrates Firebase for user authentication and data management, while leveraging ChatGPT's API for real-time conversational support and a Node.js backend server.

Disclaimer: ChatGPT helped our team decide which open-AI API model was best to use. It also helped us with debugging and discovering issues with our code. It also helped us with audio processing in order to receive live responses. 

## Features

### 🔗 Real-Time Chat with AI (ChatGPT)
- **Description**: Engage in real-time conversations powered by the ChatGPT API through our Node.js server, providing users with language support, translation, and general assistance.
- **Technologies Used**: ChatGPT API, Node.js server for API handling.

### 🌐 Language Exchange Pairing
- **Description**: Connect with community members for language exchange and practice.
- **Functionality**: Users can pair with others based on preferred languages and availability.

### 🗺️ Map and Place Pins
- **Description**: Interactive maps feature allowing users to explore community resources and events.
- **Functionality**: Add pins for new locations and view essential resources nearby.

### 📅 Event Calendar
- **Description**: Schedule and view upcoming cultural and community events.
- **Functionality**: Users can add, view, and join events, integrating with Firebase for seamless data synchronization.

### 🛡️ Emergency & Legal Support
- **Description**: Quick access to emergency and legal support information, ensuring user safety and support.

### 🔒 Firebase Authentication
- **Description**: Secure and reliable user authentication using Firebase.
- **Functionality**: Sign-up, sign-in, and persistent user sessions are managed efficiently.

### 📂 Firebase Database & Hosting
- **Description**: All user data, chat history, and event details are stored securely using Firebase Firestore.
- **Hosting**: The app is hosted using Firebase Hosting for robust performance and reliability.

## Technologies Used
### 🛠️ Frontend
- **Xcode**: Developed with Swift and SwiftUI for a seamless user experience.
- **SwiftUI**: Elegant UI design and animations for smooth navigation.
- **MapKit**: Apple's native map API used for location-based features.

### 🗄️ Backend
- **Node.js**: Backend server handling real-time API requests for ChatGPT integration.
- **Firebase**: Comprehensive solution for authentication, database management, and hosting.

## Project Setup

### Prerequisites
1. **Xcode**: Ensure you have the latest version of Xcode installed on your macOS.
2. **Node.js**: Install Node.js for API handling and backend services.
3. **Firebase Account**: Set up a Firebase project for database and authentication.

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/UnityConnector.git
   cd UnityConnector
   ```

2. **Open in Xcode**
   - Open the `UnityConnector.xcodeproj` in Xcode.

3. **Configure Firebase**
   - Download your `GoogleService-Info.plist` file from the Firebase Console.
   - Add the `GoogleService-Info.plist` file to the `UnityConnector` project in Xcode.

4. **Install Dependencies**
   - Ensure you have CocoaPods installed.
   ```bash
   pod install
   ```
   - Open the `.xcworkspace` file to work with the project.

5. **Set Up Node.js Server**
   - Navigate to the `server` directory and install dependencies:
     ```bash
     cd server
     npm install
     ```
   - Start the server:
     ```bash
     node index.js
     ```

## Usage

1. **Run the App**: Press the run button in Xcode to launch UnityConnector on the simulator or a connected iOS device.
2. **Authentication**: Use the Firebase authentication flow to sign in or create a new account.
3. **Explore Features**:
   - **Maps**: Discover and add places.
   - **Events**: Join or organize community events.
   - **Chat**: Engage with ChatGPT for language translation and community support.

## Architecture

- **SwiftUI**: For building a responsive and intuitive user interface.
- **Firebase**: Manages authentication, database, and hosting.
- **Node.js**: Backend server facilitating real-time API requests and responses from ChatGPT.

## Screenshots
*Include screenshots of your app’s key features here.*

## Roadmap
- [ ] Implement push notifications for real-time updates.
- [ ] Enhance language pairing algorithm for more personalized matches.
- [ ] Add a profile customization feature.
- [ ] Expand map resources with additional filters and categories.

## Contributing
Contributions are welcome! Please read the [CONTRIBUTING.md](CONTRIBUTING.md) for details on the code of conduct and submission guidelines.

## License
This project is licensed under the MIT License - see the [LICENSE](./License) file for details.

## Contact
**Author**: Issam Alzouby 
**Email**: ialzouby@ - message me on LinkedIn :) 
**LinkedIn**: https://www.linkedin.com/in/ialzouby/

---

