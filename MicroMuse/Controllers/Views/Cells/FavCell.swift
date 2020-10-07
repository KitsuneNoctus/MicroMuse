//
//  FavCell.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/28/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit
import Kingfisher

class FavCell: UITableViewCell {
    static let identifier = "FavCell"
    
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
    
    let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    //MARK: Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup(){
        self.contentView.addSubview(songImage)
        self.contentView.addSubview(songLabel)
        self.contentView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            /// Song Image Constraints
            songImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            songImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            songImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10),
            
            //MARK: NEED TO CHANGE THIS TO FIT THE WIRE FRAMES
            /// Song Label Constraints
            songLabel.leadingAnchor.constraint(equalTo: self.songImage.trailingAnchor, constant: 20),
            songLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            /// Play Button Constraints
            playButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            playButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }

    //MARK: Set Selected and Required Init
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
