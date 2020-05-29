//
//  ViewController.swift
//  cards game
//
//  Created by Apple on 21/04/2020.
//  Copyright © 2020 saad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var model = CardModel()
    var cardArray = [Cards]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliSeconds:Float = 20000 //milliSeconds
    
    var soundManager = SoundModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardArray = model.getCards()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timeElasped), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundManager.playSound(.shuffle)
    }
    
    // MARK: - Timer Functions
    
    var seconds = ""
    
    @objc func timeElasped()  {
        
        milliSeconds -= 1
        
        seconds = String(format: "%.2f", milliSeconds/1000)
        
        timerLabel.text = "Time Elasped: \(seconds)"
        
        if milliSeconds == 0 {
            
            timer?.invalidate()
            timerLabel.textColor = .red
            checkGameEnded()
        }
    }
    
    // MARK: - CollectionView protocol methods call
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get a cardCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //get the card that collectionView is trying to display
        let card = cardArray[indexPath.row]
        cell.setCards(card)
        
        //set that card to the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliSeconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false {
            
            cell.flip()
            soundManager.playSound(.flip)
            
            card.isFlipped = true
            
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            else {
                
                checkForMatches(indexPath)
                
                // TODO: here we have to do something
                
            }
        }
    }
    
    // MARK: - here are the match finctions
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath)  {
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as! CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as! CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName {
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            soundManager.playSound(.match)
            
            cardOneCell.remove()
            cardTwoCell.remove()
            
            checkGameEnded()
            
        } else {
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            soundManager.playSound(.noMatch)
            
            cardOneCell.flipBack()
            cardTwoCell.flipBack()
            
            checkGameEnded()
            
        }
        
        if cardOneCell == nil {
            
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        firstFlippedCardIndex = nil
    }
    
    //MARK: - Checking if Game Ended or not
    
    func checkGameEnded() {
        
        var hasWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                
                hasWon = false
                break
            }
        }
        
        var title = ""
        var message = ""
        
        if hasWon == true {
            
            if milliSeconds > 0 {
                timer?.invalidate()
                timerLabel.alpha = 0
            }
            
            title = "Congratuations!"
            message = "You have Won by \(seconds) seconds"
            
        } else {
                
            if milliSeconds > 0 {
                return
            }
                
            title = "Game Over!"
            message = "You Loose the time is over\n"
            
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.showAlert(title, message)
        })
    }
    
    func showAlert(_ title:String,_ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}

