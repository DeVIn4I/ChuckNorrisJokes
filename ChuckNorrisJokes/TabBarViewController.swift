//
//  TabBarViewController.swift
//  ChuckNorrisJokes
//
//  Created by Razumov Pavel on 30.07.2025.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
    }
    
    private func setupControllers() {
        let randomJokeVC = RandomJokeViewController()
        randomJokeVC.tabBarItem = UITabBarItem(
            title: "Random",
            image: UIImage(systemName: "quote.bubble"),
            selectedImage: nil
        )
        
        let downloadJokesVC = DownloadJokesViewController(
            jokes: StorageService.shared.getDownloadJokes(),
            state: .all, category: nil
        )
        downloadJokesVC.tabBarItem = UITabBarItem(
            title: "List",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: nil
        )
        
        let downloadCategoryJokesVC = DownloadCategoriesJokeListViewController()
        downloadCategoryJokesVC.tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "rectangle.3.group"),
            selectedImage: nil
        )
        let nav = UINavigationController(rootViewController: downloadCategoryJokesVC)
        
        viewControllers = [randomJokeVC, downloadJokesVC, nav]
    }

}
