//
//  ConcentrationGame.swift
//  ConcentrationGame
//
//  Created by Edward Christian on 13/08/2018.
//  Copyright © 2018 Edward Christian. All rights reserved.
//

import Foundation

class ConcentrationGame {
    
    var cards =  [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                //check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                //either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            //let matchingCard = card
            //cards += [card, card]
            cards.append(card)
            cards.append(card)
        }
        //Shuffle the cards
        for i in (1...numberOfPairsOfCards).reversed() {
            let nrRandom = Int(arc4random_uniform(UInt32(i)))

            //print("FIRST: ", cards[nrRandom].identifier)
            let aux = cards[i].identifier
            cards[i].identifier = cards[nrRandom].identifier
            cards[nrRandom].identifier = aux

            //print("SECOND: ", cards[nrRandom].identifier)
        }
    }
}
