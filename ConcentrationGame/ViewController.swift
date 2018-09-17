//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Edward Christian on 10/08/2018.
//  Copyright © 2018 Edward Christian. All rights reserved.
//

import UIKit

//ViewController
class ViewController: UIViewController {
    
    //Disable Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var game = ConcentrationGame(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    var bestScore = 99999
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    var emojiChoises = ["🤔", "😘", "😂", "🤪", "😎", "😭"]
    var counter = 0
    var cardsMatched = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.appearance().isExclusiveTouch = true //disable multitouch, so only one card can be flipped
        
        //Always load the best score so far
        let bestScoreDefault = UserDefaults.standard
        if (bestScoreDefault.value(forKey: "bestScore") != nil) {
            bestScore = bestScoreDefault.value(forKey: "bestScore") as! NSInteger
            bestScoreLabel.text = "Best: \(bestScore)"
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        //New Game function
        //Reinstantiate the view using the storyboard
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard") as UIViewController
        self.present(viewController, animated: true, completion: nil)
        
        
    }
    
    func disableButtons() {
        //Disable all buttons
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.isEnabled = false
        }
    }
    
    func enableButtons() {
        //Enable all buttons
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            button.isEnabled = card.isMatched ? false : true
        }
        
    }
    
    func winMessageView() {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WinMessageStoryboard") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
    
    func setBestScore() {
        //Update the best score
        if self.bestScore > self.flipCount {
            self.bestScore = self.flipCount
            self.bestScoreLabel.text = "Best: \(self.bestScore)"
            
            let bestScoreDefault = UserDefaults.standard
            bestScoreDefault.setValue(self.bestScore, forKey: "bestScore")
            bestScoreDefault.synchronize()
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        //Touch Card behaviour
        
        flipCount += 1
        
        //let cardNumber = cardButtons.index(of: sender)!
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber) //get card
            updateViewFromModel() //update the view
        } else {
            print("Chosen card was not found in cardButtons")
        }
        
        //If we flipped all the cards, show a winning message and a new game button
        if counter == cardButtons.count / 2 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.setBestScore()
                self.winMessageView()
            }
        }
    }
    
    func updateViewFromModel() {
        var previousIndex = -1
        var currentIndex = -1
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            //if the card is not flipped, flip it
            if card.isFaceUp {
                //set the emoji for the card
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.3786705404, green: 0.670083236, blue: 0.9630789975, alpha: 1)
                
                //remember the current and the previous card
                if previousIndex == currentIndex {
                    currentIndex = index
                } else {
                    previousIndex = currentIndex
                    currentIndex = index
                }
                button.isEnabled = false
                
                //if the card is matched, we have to remove the matching pair
                if card.isMatched {
                    //disable the buttons so we can't flip more than 2 cards at a time
                    disableButtons()
                   DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        button.setTitle("", for: UIControl.State.normal)
                        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                        button.isEnabled = false
                        self.enableButtons()
                    
                    }
                    if !self.cardsMatched.contains(card.identifier) {
                        self.cardsMatched.append(card.identifier)
                        self.counter += 1
                    }
                }
                    
                
            }
            //if the card is flipped, flip it back or remove it
            else if flipCount % 2 == 0 {
                disableButtons()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    let currentButton = self.cardButtons[currentIndex]
                    let currentCard = self.game.cards[currentIndex]
                    currentButton.setTitle("", for: UIControl.State.normal)
                    currentButton.backgroundColor = currentCard.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.3786705404, green: 0.670083236, blue: 0.9630789975, alpha: 1)
                    currentButton.isEnabled = currentCard.isMatched ? false : true
                    
                    let previousButton = self.cardButtons[previousIndex]
                    let previousCard = self.game.cards[previousIndex]
                    previousButton.setTitle("", for: UIControl.State.normal)
                    previousButton.backgroundColor = previousCard.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.3786705404, green: 0.670083236, blue: 0.9630789975, alpha: 1)
                    previousButton.isEnabled = previousCard.isMatched ? false : true
                    self.enableButtons()
                }
            }
        }
    }
    
    var emoji = Dictionary<Int, String>()
    //var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
       //set emojis for the cards
        
        if emoji[card.identifier] == nil, emojiChoises.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoises.count)))
            emoji[card.identifier] = emojiChoises.remove(at: randomIndex)
        }
        /* let emoji[card.identifier] != nil {
            return emoji[card.identifier]!
        } else {
            return "?"
        } */
        
        return emoji[card.identifier] ?? "?"
        
    }

}

//Design things
@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

