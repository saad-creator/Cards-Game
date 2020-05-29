//
//  SoundModel.swift
//  cards game
//
//  Created by Apple on 30/04/2020.
//  Copyright © 2020 saad. All rights reserved.
//

import Foundation
import AVFoundation

class SoundModel {
    
    var soundPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case match
        case noMatch
        case shuffle
        
    }
    
    func playSound(_ effect: SoundEffect) {
        
        var soundFileName = ""
        
        switch effect {
            
        case .flip:
            soundFileName = "cardflip"
        case .match:
            soundFileName =  "dingcorrect"
        case .noMatch:
            soundFileName = "dingwrong"
        case .shuffle:
            soundFileName = "shuffle"
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("file name counld not found at \(soundFileName) location")
            return
        }
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            soundPlayer?.play()
            
        } catch {
            print("could not play the sound file because it was not found")
        }
    }
}
