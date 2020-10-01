//
//  HomeViewController.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/16/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit
import Spartan

class HomeViewController: UIViewController {
    
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
        self.title = "Top 50 Artists"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .white
        setTable()
//        fetchResults()
        fetchNew()
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
    
    //MARK: Fetch Results
    func fetchResults(){
        Spartan.authorizationToken = NetworkManager.accessToken
        _ = Spartan.getMyTopArtists(limit: 20, offset: 0, timeRange: .mediumTerm, success: { (pagingObject) in
            // Get the artists via pagingObject.items
            print(pagingObject.toJSON())
        }, failure: { (error) in
            print(error)
        })
    }
    
    func fetchNew(){
        Spartan.authorizationToken = NetworkManager.accessToken
        _ = Spartan.getMyTopTracks(limit: 20, offset: 0, timeRange: .mediumTerm, success: { (pagingObject) in
            // Get the tracks via pagingObject.items
            print(pagingObject.toJSON())
        }, failure: { (error) in
            print(error)
        })
    }
    

}

//MARK: Table Extensions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.identifier, for: indexPath) as! HomeCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! HomeCell
        let vc = SongViewController()
        vc.artist = "Artists Name"
        vc.followers = 1
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
