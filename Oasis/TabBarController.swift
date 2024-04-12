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
        view.backgroundColor = .systemBackground

        self.delegate = self
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is NewDiaryViewController {
            let newDiaryViewController = NewDiaryViewController()
            let newDiaryViewNavigation = UINavigationController(rootViewController: newDiaryViewController)
            newDiaryViewNavigation.modalPresentationStyle = .fullScreen
            self.present(newDiaryViewNavigation, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}
