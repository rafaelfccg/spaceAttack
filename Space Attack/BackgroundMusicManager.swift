//
//  BackgroundMusicManager.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/6/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import AVFoundation

class BackgroundMusicSingleton {
  static let sharedInstance = BackgroundMusicSingleton()
  var backgroundAudioPlayer = AVAudioPlayer()
  
  fileprivate init() {
    playMusic(Resources.backgroundMusic, withFormat: "wav")
  }
  
  static func getInstance() -> BackgroundMusicSingleton {
    return sharedInstance
  }
  
  func playMusic(_ name: String, withFormat format: String) {
    let audioPath = Bundle.main.path(forResource: name, ofType:format)
    let path = URL.init(fileURLWithPath: audioPath!)
    
    do{
      backgroundAudioPlayer = try AVAudioPlayer.init(contentsOf: path)
      backgroundAudioPlayer.prepareToPlay()
      backgroundAudioPlayer.numberOfLoops = -1
      backgroundAudioPlayer.volume = 1.0
      backgroundAudioPlayer.play()
    } catch _ {
      print("error `background music` not found")
    }
  }
}
