//
//  ProductsViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit

class ProductsViewController: UIViewController {

    private let productsView = ProductsView()
    private var currentCategory: ProductsCategory = .tazas

    override func loadView() {
        view = productsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos Navideños"
        setup()
    }

    private func setup() {
        productsView.configureCategories(
            ProductsCategory.allCases,
            action: #selector(categoryTapped(_:)),
            target: self
        )

        productsView.updateImages(currentCategory.images)
    }

    @objc private func categoryTapped(_ sender: UIButton) {
        let category = ProductsCategory.allCases[sender.tag]
        currentCategory = category
        productsView.updateImages(category.images)
    }
}
