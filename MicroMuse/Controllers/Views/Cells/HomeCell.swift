//
//  HomeCell.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/28/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCell: UITableViewCell {
    static let identifier = "HomeCell"
    
    let artistImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    //MARK: Setup
    func setup() {
        self.contentView.addSubview(artistImage)
        self.contentView.addSubview(artistLabel)
        
        NSLayoutConstraint.activate([
            artistImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            artistImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            artistImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            artistLabel.leadingAnchor.constraint(equalTo: self.artistImage.trailingAnchor, constant: 10),
            artistLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
