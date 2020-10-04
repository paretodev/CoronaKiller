//
//  RegionPatient.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/04/30.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import Foundation
import SwiftUI


struct ARegionData: Codable, Identifiable {
    
    let id =  UUID()
    let cityName: String
    let confirmed, deaths, recovered: Int
    let dateUpdated: String

    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case confirmed, deaths, recovered
        case dateUpdated = "date_updated"
    
    }
}

class ApiRegionsDatum {
    func getRegionsDatum(completion: @escaping([ARegionData]) -> () ) {

        guard let url = URL(string: "https://fy0810k9v5.execute-api.ap-northeast-2.amazonaws.com/dev/covid19/dashboard.json/") else {return}
        
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
                
                let regionsDatum = try! JSONDecoder().decode([ARegionData].self, from: data!)
                    DispatchQueue.main.async {
                        completion( regionsDatum )
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

struct RegionPatient_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
