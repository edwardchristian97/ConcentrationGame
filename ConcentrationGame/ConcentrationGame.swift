//
//  ConcentrationGame.swift
//  ConcentrationGame
//
//  Created by Edward Christian on 13/08/2018.
//  Copyright © 2018 Edward Christian. All rights reserved.
//

import Foundation

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

struct ConcentrationGame {
    
    private(set) var cards =  [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
             return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "ConcentrationGame.chooseCard(at \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                //check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                //either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "ConcentrationGame.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        //Shuffle the cards
        for i in (0...numberOfPairsOfCards * 2 - 1).reversed() {
            let nrRandom = Int(arc4random_uniform(UInt32(i)))

            let aux = cards[i]
            cards[i] = cards[nrRandom]
            cards[nrRandom] = aux
        }

    }
}
