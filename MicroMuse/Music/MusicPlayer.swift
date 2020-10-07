//
//  MusicPlayer.swift
//  MicroMuse
//
//  Created by Henry Calderon on 10/6/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer{
    private var AudioPlayer: AVAudioPlayer?
    
    //MARK: Play Music
    public func playMusic(_ songURL: String){
        let url = Bundle.main.url(forResource: songURL, withExtension: nil) // 3)
        if (url == nil) {
            print("Could not find file: \(songURL)")
            return
        }
        
        var error: NSError? = nil
        do {
            AudioPlayer = try AVAudioPlayer(contentsOf: url!) // 4)
        } catch let error1 as NSError {
            error = error1
            AudioPlayer = nil
        }
        if let player = AudioPlayer {
            player.numberOfLoops = -1 // 5)
            player.prepareToPlay() // 6)
            player.play() // 7)
        } else {
            print("Could not create audio player: \(error!)")
        }
    }
}
