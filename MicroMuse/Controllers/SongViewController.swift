//
//  SongViewController.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/29/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit
import AVFoundation
import Spartan
import Kingfisher

class SongViewController: UIViewController {
    
    var artist = "Artist"
    var followers = 0
    var artistID = ""
    var songs:[Track] = []
    var favs:[Any] = []
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.register(UINib(nibName: "SongsCell", bundle: nil), forCellReuseIdentifier: SongsCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        return table
    }()
    
    //Label to display number of followers
    let label: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.font = UIFont(name: "System", size: 16)
        lab.textColor = .systemGray
        return lab
    }()
    
    let labelTop: UILabel = {
        let lab = UILabel()
        return lab
    }()
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = artist
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .white
        setup()
        FetchSongs()
        
    }
    
    //MARK: Setup
    func setup(){
        self.view.addSubview(label)
        label.text = "\(followers)# Followers"
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.view.topAnchor),
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    //MARK: Fetch Songs
    func FetchSongs(){
        NetworkManager.fetchTopTracks(artistId: artistID) { (result) in
            switch result{
            case let .success(track):
                DispatchQueue.main.async {
                    self.songs = track
//                    print(self.songs)
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

//MARK: Table Extensions
extension SongViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongsCell.identifier, for: indexPath) as! SongsCell
        let urlString = songs[indexPath.row].album.images.first?.url
        let url = URL(string: urlString!)
        cell.albumImage.kf.setImage(with: url)
        cell.songName.text = songs[indexPath.row].name
        guard let songURL = songs[indexPath.row].previewUrl else{
            cell.playButton.isEnabled = false
            return cell
        }
        cell.playButton.isEnabled = true
        cell.songURL = songURL
        
        cell.tapCheck = {
            print("Favorited")
            self.favs.append(self.songs[indexPath.row].id!)
            tableView.reloadData()
        }

        return cell
    }
    
    
}

