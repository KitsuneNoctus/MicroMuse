//
//  TabHomeController.swift
//  MicroMuse
//
//  Created by Henry Calderon on 9/16/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit

class TabHomeController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabs()
    }
    
    func setupTabs(){
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.gray
        self.tabBar.tintColor = UIColor.black

        let home = HomeViewController()
        let navHome = UINavigationController(rootViewController: home)
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named:"home"), tag: 0)
        
        let favorites = FavViewController()
        favorites.tableView.reloadData()
        let navFav = UINavigationController(rootViewController: favorites)
        favorites.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named:"star"), tag: 1)
        
        viewControllers = [navHome, navFav]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == FavViewController(){
            FavViewController().tableView.reloadData()
        }
        print("Selected a new view controller")
    }

}

// Icons
/// <div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
