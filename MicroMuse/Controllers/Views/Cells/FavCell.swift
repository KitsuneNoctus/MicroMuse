//
//  FavCell.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/28/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit

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
