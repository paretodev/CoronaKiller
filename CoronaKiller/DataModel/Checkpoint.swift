//
//  Checkpoint.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/05/09.
//  Copyright © 2020 suckyDuke. All rights reserved.
//
import MapKit

final class Checkpoint: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D){
            
        self.title = title
        self.coordinate = coordinate
        
    }
}
