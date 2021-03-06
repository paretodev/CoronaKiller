//
//  News.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/04/30.
//  Copyright © 2020 suckyDuke. All rights reserved.
//
import Foundation


// MARK: - AnArticle

struct AnArticle: Codable, Identifiable {
    var id = UUID()
    let title, reference: String
    let url: String
    let date_created: String
}

class API {
    
    func getNewses( completion: @escaping( [AnArticle] ) -> () ){ // return values is possible
        
        guard let url = URL(string: "https://fy0810k9v5.execute-api.ap-northeast-2.amazonaws.com/dev/covid19/articles.json/") else {return}
       
        //
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
                
                let newses = try! JSONDecoder().decode([AnArticle] .self, from: data!)
                    DispatchQueue.main.async {
                        completion(newses)
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

/*
DistpatchQueue.main.async : means this will happen on a background thread and update the main thread when it is finished
 */
