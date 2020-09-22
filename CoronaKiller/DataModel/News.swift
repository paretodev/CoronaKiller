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
    let id = UUID()
    let title, reference: String
    let url: String
    let date_created: String
}

class API {
    
    func getNewses( completion: @escaping( [AnArticle] ) -> () ){ // return values is possible
        
        guard let url = URL(string: "https://fy0810k9v5.execute-api.ap-northeast-2.amazonaws.com/dev/covid19/articles.json/") else {return}
        //API call
        URLSession.shared.dataTask(with: url) { (data, _, _) in
        let newses = try! JSONDecoder().decode([AnArticle].self, from: data!)
            
            DispatchQueue.main.async {
                completion(newses)
            }
            
        }
        .resume()
    }
    
}

/*
DistpatchQueue.main.async : means this will happen on a background thread and update the main thread when it is finished
 */
