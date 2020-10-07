//
//  SongsCell.swift
//  MicroMuse
//
//  Created by Henry Calderon on 10/6/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit

class SongsCell: UITableViewCell {
    static let identifier = "SongsCell"
    
    let userDefaults = UserDefaults.standard
    
    var tapCheck: (()->Void)?
    
    var songURL = ""
    var current = ""
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: Actions
    @IBAction func pressPlay(_ sender: Any) {

        if let c = userDefaults.string(forKey: "currentTune"){
            current = c
        }
        
        let url = URL(string: songURL)
        
        if MusicPlayer.shared.AudioPlayer == nil{
            MusicPlayer.shared.downloadFileFromURL(url: url!)
            userDefaults.setValue(songURL, forKey: "currentTune")
            self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }else if MusicPlayer.shared.AudioPlayer != nil && current != songURL{
            MusicPlayer.shared.downloadFileFromURL(url: url!)
            userDefaults.setValue(songURL, forKey: "currentTune")
            self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }else if MusicPlayer.shared.AudioPlayer != nil && current == songURL{
            if MusicPlayer.shared.AudioPlayer.isPlaying == true{
                MusicPlayer.shared.AudioPlayer.pause()
                self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }else if MusicPlayer.shared.AudioPlayer.isPlaying == false{
//                MusicPlayer.shared.downloadFileFromURL(url: url!)
                MusicPlayer.shared.AudioPlayer.play()
                self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        }
        

    }
    @IBAction func selectFav(_ sender: Any) {
        tapCheck!()
    }
}
