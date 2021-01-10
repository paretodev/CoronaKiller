//
//  NationwideStatus.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/04/30.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI

struct NationwideStatus: View {
    
    @State var regionsDatum : [ARegionData] = []
    
    // Customize each table cell here
    struct TextBoxStyle: ViewModifier { // receive view => style it up =>  return styled view
        func body(content: Content) -> some View {
            return content
            .frame(width: 70, height: 40, alignment: .center)
            .font(Font.custom("DoHyeon-Regular", size: 12))
        }
    }
    
    // Body View
    var body: some View {
        
        // UI views
        VStack(alignment: .leading){
            
            //Hstack1
            HStack{
                    Text("지역").modifier( TextBoxStyle() )
                    Divider()
                    Text("확진자").modifier( TextBoxStyle() )
                    Divider()
                    Text("사망자").modifier( TextBoxStyle() )
                    Divider()
                    Text("완치자").modifier( TextBoxStyle() )
            }.padding(.leading, 30)
            .frame(height: 70, alignment: .leading)
            .foregroundColor(Color.blue)
            
            
            // List - Table of each region's data
            List(regionsDatum) { aRegionData in
                
                HStack{
                    
                    VStack{
                            
                            Text("\(aRegionData.cityName)").modifier( TextBoxStyle() )
                            .frame(width: 70, height: 30, alignment: .center)
                            .font(Font.custom("DoHyeon-Regular", size: 14))
                        
                            Text("\(aRegionData.dateUpdated)")
                                .font(Font.custom("DoHyeon-Regular", size: 8.5)).foregroundColor(Color.gray)
                        
                            Text("업데이트")
                                .font(Font.custom("DoHyeon-Regular", size: 7)).foregroundColor(Color.gray)

                        }
                    Divider()
                    
                    Text("\(aRegionData.confirmed)").modifier( TextBoxStyle() ) // 확진자
                    Divider()
                    
                    Text("\(aRegionData.deaths)").modifier( TextBoxStyle() ) // 사망자
                    Divider()
                    
                    Text("\(aRegionData.recovered)").modifier( TextBoxStyle() ) // 완치자
                    
                }
                .frame(height: 50, alignment: .leading)
                .padding(.leading, 15) // has additional padding
                .font(Font.custom("DoHyeon-Regular", size: 12))
                
            }// end of list
        
        }
        .onAppear{
            ApiRegionsDatum().getRegionsDatum { (regionsDatum) in
            self.regionsDatum = regionsDatum
                }
        }
        .navigationBarTitle("지역별 실시간 코로나 현황")
        
    }// end of body
}// end of NationwideStatus view

