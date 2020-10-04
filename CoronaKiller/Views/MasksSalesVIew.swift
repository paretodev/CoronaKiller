import SwiftUI

struct MasksSalesView: View {
    
    @State var maskSales: [MasksSale] = []
    @State var modalisPresented = false
    @State var nowUrl: String = "https://www.google.com" // 기본 url
    // 라벨 스타일러
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .font(Font.custom("DoHyeon-Regular", size: 14))
        }
    }
    
    var body: some View {
        
        List(self.$maskSales.wrappedValue){ aDeal in
            
            VStack(alignment: .leading){
                HStack{
                    Text("\(aDeal.price)원").foregroundColor(Color.blue)
                        .modifier(LabelStyle())
                }
                HStack{
                    Text(aDeal.title).frame(width: 240, alignment: .leading)
                        .modifier(LabelStyle()).lineLimit(1)
                    
                    Divider()
                    
                    Button(action: {
                        self.nowUrl = aDeal.url
                        self.modalisPresented = true
                    }) {
                        Text("스토어 방문>>").foregroundColor(.green).multilineTextAlignment(.center)
                            .modifier(LabelStyle())
                    }
                    
                    }
        
            }
        }
        // in the moment the List appears the
        // state var newses are filled up
        .onAppear{
            
            MaskSalesAPI().getSalesInfos {
                (salesInfos) in self.$maskSales.wrappedValue = salesInfos
                }
            
        }
            
        .sheet(isPresented: self.$modalisPresented) {
            WebView(urlString: self.nowUrl)
        }
        
        .navigationBarTitle("온라인 마스크 구매")
        }
    }

