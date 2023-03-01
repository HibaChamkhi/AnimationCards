//
//  CardModel.swift
//  CardsAnimation
//
//  Created by hiba on 27/2/2023.
//

import Foundation
import SwiftUI

struct Card: Identifiable{
    var id = UUID().uuidString
    var cardColor : Color
    var title : String
}
