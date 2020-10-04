//
//  ConfirmerAppearance.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/14.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation

// MARK: - Confirmer
struct Confirmer: Codable {
    let type: String
    let features: [Feature]
}

// MARK: - Feature
struct Feature: Codable {
    let type: FeatureType
    let geometry: Geometry
    let properties: Properties
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: GeometryType
    let coordinates: [Double] // 여기 좌표
}

enum GeometryType: String, Codable {
    case point = "Point"
}

// MARK: - Properties
struct Properties: Codable {
    let text, pollution: String // "코로나19 부평구보건소 선별진료소","pollution":"2" 
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}

class API_Confirmer {
    func getConfirmers(completion: @escaping(Confirmer) -> () ){ // return values is possible
        guard let url = URL(string: "https://fy0810k9v5.execute-api.ap-northeast-2.amazonaws.com/dev/covid19/confirmers.json/") else {return}
        
        //API call
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
            
            // 3). 서버에서 공급받은 게,올바른 파일 포맷인지 확인하고, 맞다면 => 데이터 로드
            if let mimeType = httpResponse.mimeType, mimeType == "application/json" {
                
                let confirmersInfoSet = try! JSONDecoder().decode(Confirmer.self, from: data!)
                    DispatchQueue.main.async {
                        completion( confirmersInfoSet )
                    }
                
            }
            // 3). 2. 올바른 파일 받지 못했을 때 핸들
            else {
                print("서버가 적절한 포맷의 데이터를 제공하고 있지 않음.")
            }
    
        }
    
        //
        task.resume()
    
    }
}
