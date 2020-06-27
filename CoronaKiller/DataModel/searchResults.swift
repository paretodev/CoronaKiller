//
//  searchResults.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/05/17.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import MapKit

struct searchResult: Identifiable {

    let id = UUID()
    var title: String
    var coordinates: CLLocationCoordinate2D
    
}
