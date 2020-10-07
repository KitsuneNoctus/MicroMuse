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
    static let shared = MusicPlayer()
    public var AudioPlayer: AVAudioPlayer!
    
    public func downloadFileFromURL(url: URL){

        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.playMusic(URL!)
        })

        downloadTask.resume()

    }

    
    //MARK: Play Music
    public func playMusic(_ songURL: URL){
        do {
            print(songURL)
            self.AudioPlayer = try AVAudioPlayer(contentsOf: songURL)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
              } catch(let error) {
                print(error.localizedDescription)
              }
            AudioPlayer.prepareToPlay()
            AudioPlayer.volume = 1.0
            AudioPlayer.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }

//        let strU = songURL as! String
//        let url = Bundle.main.url(forResource: strU, withExtension: nil) // 3)
//        if (songURL == nil) {
//            print("Could not find file: \(songURL)")
//            return
//        }
////
//        var error: NSError? = nil
//        do {
//            AudioPlayer = try AVAudioPlayer(contentsOf: songURL) // 4)
//        } catch let error1 as NSError {
//            error = error1
//            AudioPlayer = nil
//        }
//
//        if let player = AudioPlayer {
//            player.numberOfLoops = -1 // 5)
//            player.prepareToPlay() // 6)
//            player.play() // 7)
//        } else {
//            print("Could not create audio player: \(error!)")
//        }
    }
}
