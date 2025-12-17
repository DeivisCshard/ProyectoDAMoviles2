//
//  MainTabBarController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 17/12/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {

        let homeVC = ViewController()
        let productsVC = ProductsViewController()
        let profileVC = ProfileViewController()

        let homeNav = UINavigationController(rootViewController: homeVC)
        let productsNav = UINavigationController(rootViewController: productsVC)
        let profileNav = UINavigationController(rootViewController: profileVC)

        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        productsNav.tabBarItem = UITabBarItem(
            title: "Productos",
            image: UIImage(systemName: "cube"),
            selectedImage: UIImage(systemName: "cube.fill")
        )

         profileNav.tabBarItem = UITabBarItem(
          title: "User",
           image: UIImage(systemName: "person"),
           selectedImage: UIImage(systemName: "person.fill")
         )
        

        viewControllers = [homeNav, productsNav,profileNav]
    }

    private func setupAppearance() {
        tabBar.backgroundColor = UIColor.systemGray6
        tabBar.tintColor = UIColor.systemIndigo
        tabBar.unselectedItemTintColor = UIColor.gray
    }
}
