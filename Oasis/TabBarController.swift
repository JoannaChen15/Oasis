//
//  TabViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let mapViewController = MapViewController()
    let newDiaryViewController = NewDiaryViewController()
    let profileViewController = ProfileViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
        configureViewControllers()
        self.delegate = self
    }
        
    func configureTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .systemBackground
        tabBarAppearance.shadowColor = .clear
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    func configureViewControllers() {
        // 定義Navigation
        let profileViewNavigation = UINavigationController(rootViewController: profileViewController)
        
        // 定義Tab有哪些畫面
        viewControllers = [
            mapViewController,
            newDiaryViewController,
            profileViewNavigation
        ]
        
        // 定義TabBarItem
        mapViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        newDiaryViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus.circle"), tag: 1)
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person.crop.circle"), tag: 2)
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is NewDiaryViewController {
            let newDiaryViewController = NewDiaryViewController()
            newDiaryViewController.diaryListDelegate = profileViewController
            let newDiaryViewNavigation = UINavigationController(rootViewController: newDiaryViewController)
            newDiaryViewNavigation.modalPresentationStyle = .fullScreen
            present(newDiaryViewNavigation, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}
