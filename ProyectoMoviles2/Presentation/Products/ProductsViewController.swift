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

    private var products: [Product] = []
    private var cart: [Product] = []

    override func loadView() {
        view = productsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos Navideños"
        setup()
        setupCartButton()
    }

    private func setup() {
        productsView.configureCategories(
            ProductsCategory.allCases,
            action: #selector(categoryTapped(_:)),
            target: self
        )

        products = currentCategory.products
        productsView.updateProducts(products)
        productsView.delegate = self
    }

    private func setupCartButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Carrito",
            style: .plain,
            target: self,
            action: #selector(openCart)
        )
    }

    @objc private func categoryTapped(_ sender: UIButton) {
        currentCategory = ProductsCategory.allCases[sender.tag]
        products = currentCategory.products
        productsView.updateProducts(products)
    }

    @objc private func openCart() {
        let cartVC = CartViewController()
        cartVC.cartItems = cart
        navigationController?.pushViewController(cartVC, animated: true)
    }
}


extension ProductsViewController: ProductsViewDelegate {

    func didTapAddProduct(at index: Int) {
        guard products[index].stock > 0 else { return }

        products[index].stock -= 1
        cart.append(products[index])

        productsView.updateProducts(products)
    }
}

