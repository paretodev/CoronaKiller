//
//  MapPracView.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/05/17.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI
import MapKit

struct MapPracView: UIViewRepresentable {
    
    var map = MKMapView()
    var locationManager: CLLocationManager!
    
    init(){
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        map.mapType = .standard
        map.showsUserLocation = true
        map.userLocation.title = "You are here"
        return map
    
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) { }
    
    func showHome(){
        
        let location = map.userLocation
        let region = MKCoordinateRegion(center )
        
    }
    
    
}











struct MapPracView_Previews: PreviewProvider {
    static var previews: some View {
        MapPracView()
    }
}
