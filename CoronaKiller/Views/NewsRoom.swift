//
//  NewsRoom.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/04/30.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI

struct NewsRoom: View {
    
    @State var newses: [AnArticle] = []
    @State var modalisPresented = false
    @State var nowUrl: String = "https://url.kr/miCjhx" // 디폴트 url
    
    var body: some View {
        
        List(newses){ anArticle in
            
            VStack(alignment: .leading){
                HStack{
                    Text("\(String(anArticle.reference.dropLast(6)))") // api company name
                    Text("\(anArticle.date_created)").font(Font.custom("Dohyeon-Regular", size: 12)).padding(.leading, 10).foregroundColor(Color.gray)
                }
                
                HStack{
                    
                    Text(anArticle.title).frame(width: 235, alignment: .leading).lineLimit(1)
                    
                    Divider()
                    
                    Button(action: {
                        
                        self.nowUrl = anArticle.url
                        self.modalisPresented = true
                        
                    }) {
                        Text("기사 읽기>>").foregroundColor(Color.gray)
                    }

                    
                    }
        
            }
        }
        // in the moment the List appears the
        // state var newses are filled up
        .onAppear{
            
            API().getNewses{
                (newses) in self.newses = newses // completion handler <- assign downloaded data to state variable of this view model.
                }
            
        }
            
        .sheet(isPresented: $modalisPresented) {
            WebView(urlString: self.nowUrl)
        }
        
        .navigationBarTitle("실시간 코로나 뉴스룸")
        
        }
    }




