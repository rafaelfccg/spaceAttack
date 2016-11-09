//
//  BackgroundMusicManager.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/6/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import AVFoundation

class BackgroundMusicSingleton {
    static let sharedInstance = BackgroundMusicSingleton()
    var backgroundAudioPlayer = AVAudioPlayer()
    
    static func getInstance() -> BackgroundMusicSingleton {
        return sharedInstance
    }
    
    fileprivate init() {
        playMusic(Resources.backgroundMusic, withFormat: "wav")
    }
    
    func playMusic(_ name: String, withFormat format:String) {
        let audioPath = Bundle.main.path(forResource: name, ofType:format)
        let path = URL.init(fileURLWithPath: audioPath!)
        
        do{
            self.backgroundAudioPlayer = try AVAudioPlayer.init(contentsOf: path)
            self.backgroundAudioPlayer.prepareToPlay()
            self.backgroundAudioPlayer.numberOfLoops = -1
            self.backgroundAudioPlayer.volume = 1.0
            self.backgroundAudioPlayer.play()
        }catch _ {
            print("error `background music` not found")
        }
    }
}
