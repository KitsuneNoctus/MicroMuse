//
//  FavViewController.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/16/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit
import AVFoundation
import Spartan
import Kingfisher

class FavViewController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.register(HomeCell.self, forCellReuseIdentifier: HomeCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Favorites"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .white
        setup()
    }
    
    //MARK: Setup
    func setup(){
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    
    //MARK: Song Player
    func playSong(){
        
    }
    
}

//MARK: Table Extensions
extension FavViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.identifier, for: indexPath) as! HomeCell
        return cell
    }
    
    
}

