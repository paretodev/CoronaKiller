//  MaskStockStores.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/07/13.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import Combine
import MapKit


// MARK: - MasksSales
struct storesStore: Codable {
    let count: Int
    let stores: [Store]
}

// MARK: - Store
struct Store: Codable {
    
    let name, type: String
    let addr, code : String
    let lat, lng: Double
    
    let created_at: String?
    let stock_at : String?
    let remain_stat: String?

}

class MaskStockStoresAPI {
    
    // initialize
    let coordi: CLLocationCoordinate2D
    init(coordi: CLLocationCoordinate2D) {
        self.coordi = coordi
    }
    
    // 현재 정부에서, 공적마스크 공급 중단으로 인해, API 서버를 닫은 상태입니다 !!
    func fetchStores(completion: @escaping(storesStore) -> () ){ // return values is possible
        guard let url = URL(string: "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByGeo/json?lat=\(coordi.latitude)&lng=\(coordi.longitude)&m=5000") else {return}
            //API call
            URLSession.shared.dataTask(with: url) { (data, _, _) in
            let storeInfos = try! JSONDecoder().decode(storesStore.self, from: data!) // decoded json format
            //test print newses
                // interact with the app while at same time doing api call
                DispatchQueue.main.async {
                    completion(storeInfos)
                }
            }
            .resume()
        }
    
}

