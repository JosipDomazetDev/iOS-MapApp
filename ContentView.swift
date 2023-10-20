import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI
import UserNotifications

struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.778259, longitude: -119.417931),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    @State private var currentLocation = CLLocationCoordinate2D(latitude: 36.778259, longitude: -119.417931)
    
    var annotations: [City] {
        [City(name: "Current Location", coordinate: currentLocation)]
    }
    
    
    
    var body: some View {
        ZStack {
            Color.clear
            Map(coordinateRegion: $region, annotationItems: annotations) {
                MapMarker(coordinate: $0.coordinate)
            }
            .ignoresSafeArea()
            
            // Current Location Overlay
            VStack {
                Text("Lat: \(currentLocation.latitude), Lon: \(currentLocation.longitude)")
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(10)
                
                Spacer()
                
                
                HStack {
                    LocationButton(.currentLocation) {
                        
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 40)
                    .cornerRadius(8)
                    .padding(5)
                    
                    Button(action: sendNotification) {
                        Image(systemName: "bell.fill")
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .cornerRadius(15)
                    .padding()
                }.padding(.bottom, 28)
            }
        }
        .onAppear(perform: setupLocation)
    }
    
    func setupLocation() {
        print("frgrgrgrgr")
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        if let location = manager.location {
            currentLocation = location.coordinate
        }
    }
    
    
    
    
    func sendNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Current Location"
                content.body = "Lat: \(currentLocation.latitude), Lon: \(currentLocation.longitude)"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request, withCompletionHandler: nil)
            } else {
                print("Permissions not granted")
            }
        }
    }
}
