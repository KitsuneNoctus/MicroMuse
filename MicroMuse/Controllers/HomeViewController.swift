//
//  HomeViewController.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/16/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit
import Spartan
import Kingfisher

class HomeViewController: UIViewController {
    
    var artistList:[Artist] = []
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.register(HomeCell.self, forCellReuseIdentifier: HomeCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        return table
    }()
    
    
    
    //MARK: View Did Appear
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top Artists"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        setTable()
        fetchArtists()
        self.tableView.reloadData()
    }
    
    //MARK: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
//        fetchResults()
        tableView.reloadData()
    }
    
    //MARK: Set Table
    func setTable(){
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
    
    func fetchArtists(){
        DispatchQueue.global(qos: .userInitiated).async {
            NetworkManager.fetchTopArtists(){ (result) in
                switch result{
                case let .success(artists):
                    self.artistList = artists
                    self.tableView.reloadData()
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    //MARK: @Objc
    @objc func logout(){
        print("logout?")
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
//        print(self.view.window?.rootViewController)
//        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
//        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
//        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: Table Extensions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.identifier, for: indexPath) as! HomeCell
        
        let urlString = artistList[indexPath.row].images.first?.url
        let url = URL(string: urlString!)
        cell.imageView?.kf.setImage(with: url, options: []) { result in
            switch result{
            case .success(let value):
                DispatchQueue.main.async{
                    cell.imageView?.image = value.image
                    cell.textLabel?.text = self.artistList[indexPath.row].name
//                    cell.artistImage.image = value.image
//                    cell.artistLabel.text = self.artistList[indexPath.row].name
                }
            case .failure(let error):
                print(error)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! HomeCell
        let vc = SongViewController()
        vc.artist = artistList[indexPath.row].name
        vc.followers = artistList[indexPath.row].followers.total
        vc.artistID = artistList[indexPath.row].id as! String
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
