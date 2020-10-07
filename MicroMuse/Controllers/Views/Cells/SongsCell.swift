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
    
    var tapCheck: (()->Void)?
    
    var songURL = ""
    
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
    
    @IBAction func pressPlay(_ sender: Any) {
        print(songURL)
        let url = URL(string: songURL)
        MusicPlayer.shared.downloadFileFromURL(url: url!)
    }
    @IBAction func selectFav(_ sender: Any) {
        tapCheck!()
//        let favList = [String]()
//        UserDefaults.standard.setValue(favList, forKey: "favSongs")
    }
}
