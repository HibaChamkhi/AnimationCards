//
//  ContentView.swift
//  CardsAnimation
//
//  Created by hiba on 27/2/2023.
//

import SwiftUI

struct ContentView: View {
    @State var backViewSize : CGFloat = 80
    @State var size : CGSize = .zero
    var body: some View {
        
        GeometryReader { reader in
            ZStack{
                VStack{
                    Color.red
                }
                .frame(width: reader.size.width - 160, height: 300)
                .cornerRadius(20)
                .shadow(radius: 20)
                .offset(y:-30)
                
                VStack{
                    Color.green
                }
                .frame(width: reader.size.width - self.backViewSize , height: 300)
                .cornerRadius(20)
                .shadow(radius: 20)
                .offset(y:-15)
                
                VStack{
                    Color.yellow
                }
                .frame(width: reader.size.width - 50 , height: 300)
                .cornerRadius(20)
                .shadow(radius: 20)
                .gesture(
                    DragGesture()
                    .onChanged({ (value) in
                    self.size = value.translation
                    self.backViewSize = 50
                })
                    .onEnded({ (value) in
                        self.size = .zero
                        self.backViewSize = 80
                        
                    })
                )
                .offset(self.size)
            }
            .animation(.spring())
        }
        
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
