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
            
            // make shared task instance
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("트랜스포트 에러 발생.")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, // server response - succeeded
                        (200...299).contains(httpResponse.statusCode)
                        else {
                

                        print("데이터를 정상적으로 불러올 수 없습니다.")
                        return
            }
            

            if let mimeType = httpResponse.mimeType, mimeType == "application/json" {
                
                let storeInfos = try! JSONDecoder().decode(storesStore.self, from: data!)
                    DispatchQueue.main.async {
                        completion(storeInfos)
                    }
                
            }

            else {
                print("서버가 적절한 포맷의 데이터를 제공하고 있지 않음.")
            }
    
        }
    
        //
        task.resume()
        
    }
}
