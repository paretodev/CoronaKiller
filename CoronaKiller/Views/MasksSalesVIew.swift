import SwiftUI

struct MasksSalesView: View {
    
    @State var maskSales: [MasksSale] = []
    @State var modalisPresented = false
    @State var nowUrl: String = "https://www.google.com" // 기본 url
    
    var body: some View {
        
        List(self.$maskSales.wrappedValue){ aDeal in
            
            VStack(alignment: .leading){
                HStack{
                    Text("\(aDeal.price)원").foregroundColor(Color.blue) // api company name
                }
                HStack{
                    Text(aDeal.title).frame(width: 240, alignment: .leading)
                        .font(Font.custom("Arial Rounded MT Bold", size: 14.8))
                    
                    Divider()
                    
                    Button(action: {
                        self.nowUrl = aDeal.url
                        self.modalisPresented = true
                    }) {
                        Text("스토어 방문>>").foregroundColor(.green).multilineTextAlignment(.center)
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

