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
            
            
            // List - HStack
            List(regionsDatum) { aRegionData in
                
                HStack{
                    
                    VStack{
                            
                            Text("\(aRegionData.cityName)").modifier( TextBoxStyle() )
                            .frame(width: 70, height: 30, alignment: .center)
                            .font(Font.custom("Arial Rounded MT Bold", size: 14))
                            Text("\(aRegionData.dateUpdated)")
                                .font(Font.custom("Arial Rounded MT Bold", size: 8.5)).foregroundColor(Color.gray)
                            Text("업데이트")
                                .font(Font.custom("Arial Rounded MT Bold", size: 7)).foregroundColor(Color.gray)

                        }
                        Divider()
                        Text("\(aRegionData.confirmed)").modifier( TextBoxStyle() ) // 확진자
                        Divider()
                        Text("\(aRegionData.deaths)").modifier( TextBoxStyle() ) // 사망자
                        Divider()
                        Text("\(aRegionData.recovered)").modifier( TextBoxStyle() ) // 완치자
                    
                }
                .frame(height: 55, alignment: .leading)
                .padding(.leading, 15) // has additional padding
                .font(Font.custom("Arial Rounded MT Bold", size: 12))
                
            }// end of list
        
        }
            
        // setting body navigation title
        .navigationBarTitle("전국 지역별 코로나 현황")
        // api get posts
        .onAppear{
            ApiRegionsDatum().getRegionsDatum { (regionsDatum) in
            self.regionsDatum = regionsDatum
                }
            }
    }// end of body
}// end of NationwideStatus view

struct NationwideStatus_Previews: PreviewProvider {
    static var previews: some View {
        NationwideStatus()
    }
}
