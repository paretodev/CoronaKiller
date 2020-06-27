//
//  searchResultsStore.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/05/17.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import Combine
import MapKit

class searchResultsStore: ObservableObject {
    @Published var searchResultsPool: [searchResult] = []
}

// observable object 로 searchResulsPool open
