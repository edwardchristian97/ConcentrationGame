//
//  Card.swift
//  ConcentrationGame
//
//  Created by Edward Christian on 13/08/2018.
//  Copyright © 2018 Edward Christian. All rights reserved.
//

import Foundation

struct Card {
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqIdentifier()
    }
    
}
