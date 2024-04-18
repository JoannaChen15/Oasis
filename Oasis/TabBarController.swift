//
//  TabViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .systemBackground
        tabBarAppearance.shadowColor = .clear
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance

        self.delegate = self
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is NewDiaryViewController {
            let newDiaryViewController = NewDiaryViewController()
            let newDiaryViewNavigation = UINavigationController(rootViewController: newDiaryViewController)
            newDiaryViewNavigation.modalPresentationStyle = .fullScreen
            present(newDiaryViewNavigation, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}
