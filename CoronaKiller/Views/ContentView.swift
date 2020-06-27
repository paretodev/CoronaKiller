//
//  ContentView.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/04/30.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //instance var
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .font(Font.custom("Arial Rounded MT Bold", size: 25))
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack{
                Image("2019-ncov").padding(.bottom, 10).padding(.top, 20)
                
                //Nav Link1
                NavigationLink(destination: NewsRoom()) {
                    Text("코로나 뉴스룸").modifier(LabelStyle())
                }
                
                Spacer()
                
                //Nav Link2
                NavigationLink(destination: RealMapView()) {
                        Text("내 주변 마스크 재고").modifier(LabelStyle())
                }
                Spacer()
                
                //Nav Link3
                NavigationLink(destination: PatientsPathView()) {
                        Text("내 주변 확진자 동선").modifier(LabelStyle())
                }
                Spacer()
 
                //Nav Link4
                NavigationLink(destination: NationwideStatus()) {
                    Text("지역별 코로나 발생 현황").modifier(LabelStyle())
                }
                
                Spacer()
                
                //Nav Link5
                Group{
                    NavigationLink(destination: MasksSalesView()) {
                        Text("마스크 온라인 쇼핑").modifier(LabelStyle())
                    }
                    Spacer()
                }
            
            }.foregroundColor(Color.red)
    
            .navigationBarTitle("코로나 All in One").multilineTextAlignment(.center)
        }.background(Color(red: 252, green: 237, blue: 238))
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

}

