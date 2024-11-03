import SwiftUI
import MapKit

struct MapPinView: View {
    var pin: PlacePin

    var body: some View {
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
}
