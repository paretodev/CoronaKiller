//
//  MaskSales.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/14.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation

// MARK: - MasksSale
struct MasksSale: Codable, Identifiable {
    var id = UUID()
    let title: String
    let price: Int
    let url: String
}


class MaskSalesAPI {
    
    func getSalesInfos(completion: @escaping([MasksSale]) -> () ){ // return values is possible
        
        guard let url = URL(string: "https://fy0810k9v5.execute-api.ap-northeast-2.amazonaws.com/dev/covid19/stores.json/") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { ( data, response, error ) in
            
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
                
                let salesinfos = try! JSONDecoder().decode([MasksSale].self, from: data!)
                    DispatchQueue.main.async {
                        completion( salesinfos )
                    }
                
            }
            
            else {
                print("서버가 적절한 포맷의 데이터를 제공하고 있지 않음.")
            }
    
        }
    
        task.resume()
        
    }
}
