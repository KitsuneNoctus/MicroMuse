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
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named:""), tag: 0)
        
        let favorites = FavViewController()
        let navFav = UINavigationController(rootViewController: favorites)
        favorites.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named:""), tag: 1)
        
        viewControllers = [navHome, navFav]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected a new view controller")
    }

}
