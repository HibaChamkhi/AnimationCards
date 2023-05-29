//
//  Home.swift
//  CardsAnimation
//
//

import SwiftUI

struct Home: View {
    @State var cards: [Card] = [
        Card(cardColor: Color.yellow, title: "1"),
        Card(cardColor: Color.red, title: "2"),
        Card(cardColor: Color.green, title: "3"),
        Card(cardColor: Color.blue, title: "4"),
        Card(cardColor: Color.pink, title: "5")
    ]
    var body: some View {
        VStack{
            GeometryReader{proxy in
                let size = proxy.size
                let trailingCardsToShown : CGFloat = 2
                let trailingSpaceofEachCards : CGFloat = 20
                ZStack{
                    ForEach(cards){ card in
                        InfiniteStackedCardView(cards: $cards, card: card,trailingCardsToShown: trailingCardsToShown,trailingSpaceofEachCards: trailingSpaceofEachCards)
                    }
                }
                .padding(.horizontal,10)
                .padding(.trailing,(trailingCardsToShown * trailingSpaceofEachCards))
                .frame(height: size.height / 1.6)
                
                .frame(maxWidth: .infinity , maxHeight: .infinity ,alignment: .center)
            }
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct InfiniteStackedCardView : View{
    @Binding var cards : [Card]
    var card : Card
    var trailingCardsToShown : CGFloat
    var trailingSpaceofEachCards : CGFloat
    @GestureState var isDragging : Bool = false
    @State var offset : CGFloat = .zero
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            Image(card.title)
                .resizable()
        }
        .padding()
        .padding(.vertical , 10)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity , maxHeight: .infinity,alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(card.cardColor)
        )
        .padding(.trailing,-getPadding())
        .padding(.vertical,getPadding())
        .zIndex(Double(CGFloat(cards.count)-getIndex()))
        .rotationEffect(.init(degrees: getRotation(angle: 10)))
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .contentShape(Rectangle())
        .offset(x:offset)
        .gesture(DragGesture()
            .updating($isDragging, body: { _, out, _ in
                out = true
            })
                .onChanged({ value in
                    var translation = value.translation.width
                    translation = cards.first?.id == card.id ? translation : 0
                    translation = isDragging ? translation : 0
                    translation = (translation < 0  ? translation : 0)
                    offset = translation
                })
                    .onEnded({ value in
                        let width = UIScreen.main.bounds.width
                        let cardPassed = -offset > (width / 2)
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if cardPassed{
                                offset = -width
                                removeAndPutBack()
                            }else{
                                offset = .zero
                            }
                        }
                    })
        )
        
    }
    
    func remove(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                cards.removeFirst()
        }
    }
    func removeAndPutBack(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            var updateCard = card
            updateCard.id = UUID().uuidString
            cards.append(updateCard)
            withAnimation {
                cards.removeFirst()
            }
        }
    }
    func getRotation(angle : Double)->Double{
        let width = UIScreen.main.bounds.width - 50
        let progress = offset / width
        return Double(progress) * angle
    }
    func getPadding()->CGFloat{
        let maxPadding = trailingCardsToShown * trailingSpaceofEachCards
        let cardPadding = getIndex() * trailingSpaceofEachCards
        return (getIndex() <= trailingCardsToShown ? cardPadding : maxPadding)
    }
    func getIndex()->CGFloat{
        let index = cards.firstIndex {card in
            return self.card.id == card.id
        } ?? 0
        return CGFloat(index)
    }
}
