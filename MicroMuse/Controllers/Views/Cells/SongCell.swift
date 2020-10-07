//
//  SongCell.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/29/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit
import Kingfisher

class SongCell: UITableViewCell {
    static let identifier = "SongCell"
    
    //MARK: Assets
    let songLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    let songImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //MARK: Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    //MARK: Setup Function
    func setup(){
        self.contentView.addSubview(songImage)
        self.contentView.addSubview(songLabel)
        self.contentView.addSubview(playButton)
        self.contentView.addSubview(favButton)
        
        NSLayoutConstraint.activate([
            /// Song Image Constraints
            songImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            songImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            songImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            /// Song Label Constraints
            songLabel.leadingAnchor.constraint(equalTo: self.songImage.trailingAnchor, constant: 20),
            songLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            /// Fav Button Constraint
            favButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 15),
            favButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            /// Play Button Constraint
            playButton.trailingAnchor.constraint(equalTo: self.favButton.leadingAnchor, constant: 10),
            playButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            
        ])
    }
    
    //MARK: Set Selected and Coder?
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
