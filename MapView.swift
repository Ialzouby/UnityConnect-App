import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var pins: [PlacePin] = []
    
    @State private var showingAddPinSheet = false // State variable to control sheet presentation
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: pins) { pin in
                MapAnnotation(coordinate: pin.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        
                        Text(pin.name)
                            .font(.caption)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                }
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingAddPinSheet.toggle() // Show AddPinView
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    .padding()
                    .sheet(isPresented: $showingAddPinSheet) {
                        AddPinView(isPresented: $showingAddPinSheet) { newPin in
                            pins.append(newPin)
                        }
                    }
                }
            }
        }
        .navigationTitle("Map")
    }
}
