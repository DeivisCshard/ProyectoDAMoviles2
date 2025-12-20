//
//  ProductsViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit
import CoreData

struct TempCartItem {
    let product: ProductEntity
    var quantity: Int
    var total: Double
}

class ProductsViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private let productsView = ProductsView()
    private var currentCategory: ProductsCategory = .tazas

    private var products: [ProductEntity] = []
    private var tempCart: [TempCartItem] = []

    override func loadView() {
        view = productsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos Navideños"
        setup()
        setupCartButton()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(productsDidUpdate),
            name: NSNotification.Name("ProductsUpdated"),
            object: nil
        )
    }
    
    func fetchProducts() {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        products = (try? context.fetch(request)) ?? []
        productsView.updateProducts(products)
    }

    private func setup() {
        productsView.configureCategories(
            ProductsCategory.allCases,
            action: #selector(categoryTapped(_:)),
            target: self
        )

        products = currentCategory.fetchProducts(context: context)
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
        let category = ProductsCategory.allCases[sender.tag]
        products = category.fetchProducts(context: context)
        productsView.updateProducts(products)
    }

    @objc private func openCart() {
        let cartVC = CartViewController()
        cartVC.tempCart = tempCart
        cartVC.onCheckoutComplete = { [weak self] in
            guard let self = self else { return }
            
            // Recargar productos de la categoría actual y vaciar carrito temporal
            self.products = self.currentCategory.fetchProducts(context: self.context)
            self.productsView.updateProducts(self.products)
            self.tempCart.removeAll() // vaciar carrito temporal
        }
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @objc private func productsDidUpdate() {
        self.products = self.currentCategory.fetchProducts(context: self.context)
        self.productsView.updateProducts(self.products)
    }
    
}


extension ProductsViewController: ProductsViewDelegate {

    func didTapAddProduct(at index: Int) {
        let product = products[index]
        guard product.stock > 0 else { return }

        // Revisar si ya está en el carrito temporal
        if let existingIndex = tempCart.firstIndex(where: { $0.product == product }) {
            tempCart[existingIndex].quantity += 1
            tempCart[existingIndex].total += product.price
        } else {
            tempCart.append(TempCartItem(product: product, quantity: 1, total: product.price))
        }

        // Actualizar vista
        productsView.updateProducts(products)
    }
}
 
extension ProductsViewController: ProductFormDelegate {
    func didUpdateProducts() {
        // Recargar productos de la categoría actual
        self.products = self.currentCategory.fetchProducts(context: self.context)
        self.productsView.updateProducts(self.products)
    }
}
