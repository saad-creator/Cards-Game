//
//  CardModel.swift
//  cards game
//
//  Created by Apple on 21/04/2020.
//  Copyright © 2020 saad. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Cards] {
        
        var generateCardsArray = [Cards]()
        
        for _ in 1...8 {
            
            
            let randomNumber = arc4random_uniform(13) + 1
            print(randomNumber)
            
            let card0 = Cards()
            card0.imageName = "card\(randomNumber)"
            generateCardsArray.append(card0)
            
            
            
            let cardTwo = Cards()
            cardTwo.imageName = "card\(randomNumber)"
            generateCardsArray.append(cardTwo)
        }
        return generateCardsArray
    }
}
