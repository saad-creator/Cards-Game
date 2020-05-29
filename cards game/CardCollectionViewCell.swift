//
//  CardCollectionViewCell.swift
//  cards game
//
//  Created by Apple on 23/04/2020.
//  Copyright © 2020 saad. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImage: UIImageView!
    
    @IBOutlet weak var backImage: UIImageView!
    
    var card:Cards?
    
    func setCards(_ card:Cards) {
        self.card = card
        
        if card.isMatched == true {
            
            frontImage.alpha = 0
            backImage.alpha = 0
            
            return
        } else {
            
            frontImage.alpha = 1
            backImage.alpha = 1
        }
        
        frontImage.image = UIImage(named: card.imageName)
        
        if card.isFlipped == true && card.isMatched == false {
            
            UIView.transition(from: backImage, to: frontImage, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        } else {
            
            UIView.transition(from: frontImage, to: backImage, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
    }
    
    func flip() {
        
        UIView.transition(from: backImage, to: frontImage, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.transition(from: self.frontImage, to: self.backImage, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        })
    }
    
    func remove()  {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            
            UIView.animate(withDuration: 1) {
                self.frontImage.alpha = 0
                self.backImage.alpha = 0
            }
            
        })
    }
}
