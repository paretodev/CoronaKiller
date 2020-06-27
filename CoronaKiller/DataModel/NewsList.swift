//
//  NewsList.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/04/30.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI

struct NewsList: View {
    
    @State var newses: [News] = []
    
    var body: some View {
        
        List(newses){ news in
            Text("\(news.title)")}
    .onAppear{
        API().getNewses{
            (newses) in self.newses = newses
        }
    }
        
    }
    }

struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsList()
    }
}
