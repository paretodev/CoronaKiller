//
//  PublicMaskQuestion.swift
//  CoronaKiller
//
//  Created by 한석희 on 2020/06/01.
//  Copyright © 2020 suckyDuke. All rights reserved.
//

import SwiftUI

struct PublicMaskQuestion: View {
    
    @State var yearBorn: Int = 1985
    @State var answer: String = "공적마스크 구매 가능 요일을 조회해 보세요. \n주말엔, 주중에 구매한 이력이 없는 사람에 한해, \n모든 년생이 구매 가능합니다."
    let dayOfWeek = Calendar.current.component(.weekday, from: Date())
    let dayOfWeekDict = [1: "일", 2: "월", 3: "화", 4: "수", 5: "목", 6: "금", 7: "토"]
    // 라벨 스타일러
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .font(Font.custom("DoHyeon-Regular", size: 21))
        }
    }
    

    var body: some View {
        
        VStack {
            
            Text("출생년도를 선택해주세요.").modifier(LabelStyle()).foregroundColor(.blue)
    
            Picker(selection: self.$yearBorn, label: EmptyView()){
                
                ForEach(1940 ..< 2021) {
                    Text("\($0)")
                }
                
            }.labelsHidden()

            Button(action: {
                
                let endDigit = self.yearBorn % 10 // 나머지
                                
                let whichDay: String = self.dayOfWeekDict[self.dayOfWeek]!
                
                switch endDigit {
                    
                case 1,6 :
                    
                    self.answer = """
                        공적마스크 구매 가능 요일은 매주 월요일입니다.
                    """
                    
                    if self.dayOfWeek == 1 {
                        self.answer = "오늘 공적마스트 구매가 가능하십니다.\n" + self.answer
                    }
                
                case 2,7 :
                    
                    self.answer = """
                        공적마스크 구매 가능 요일은 매주 화요일입니다.
                    """
                    
                    if self.dayOfWeek == 2 {
                        self.answer = "오늘 공적마스트 구매가 가능하십니다.\n" + self.answer
                    }
                    
                case 3,8 :
                    
                    self.answer = """
                        공적마스크 구매 가능 요일은 매주 수요일입니다.
                    """
                    if self.dayOfWeek == 3 {
                        self.answer = "오늘 공적마스트 구매가 가능하십니다.\n" + self.answer
                    }
                    
                case 4,9 :
                    
                    self.answer = """
                        공적마스크 구매 가능 요일은 매주 목요일입니다.
                    """
                    
                    if self.dayOfWeek == 4 {
                        self.answer = "오늘 공적마스트 구매가 가능하십니다.\n" + self.answer
                    }
                    
                case 5,0 :
                    
                    self.answer = """
                        공적마스크 구매 가능 요일은 매주 금요일입니다.
                    """
                    
                    if self.dayOfWeek == 5 {
                        self.answer = "오늘 공적마스트 구매가 가능하십니다.\n" + self.answer
                    }
                    
                default :
                    print()
            
                }
                // 오늘 요일 알려주기
                self.answer = "오늘은 \(whichDay)요일 입니다.\n" + self.answer
                
            }) {
                Text("조회").modifier(LabelStyle())
            }
            
            Text(verbatim: self.answer).padding(.top, 30)
                .multilineTextAlignment(.center).modifier(LabelStyle())

        }
        
    }
}

struct PublicMaskQuestion_Previews: PreviewProvider {
    static var previews: some View {
        PublicMaskQuestion()
    }
}
