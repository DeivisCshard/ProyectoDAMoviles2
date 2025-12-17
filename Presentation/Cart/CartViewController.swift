//
//  CartViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit

class CartViewController: UIViewController {

    var cartItems: [Product] = []

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private let totalLabel = UILabel()
    private let checkoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Carrito"
        view.backgroundColor = .systemBackground

        setupScrollView()
        setupStackView()
        setupCheckoutButton()
        setupTotalLabel()
        updateCartItems()
    }

    // MARK: - ScrollView y StackView
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120) // deja espacio para total + botón
        ])
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32) // importante para scroll horizontal
        ])
    }

    // MARK: - Total Label
    private func setupTotalLabel() {
        totalLabel.font = .boldSystemFont(ofSize: 18)
        totalLabel.textColor = .black
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(totalLabel)

        NSLayoutConstraint.activate([
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            totalLabel.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -16)
        ])
    }

    // MARK: - Checkout Button
    private func setupCheckoutButton() {
        checkoutButton.setTitle("Finalizar compra", for: .normal)
        checkoutButton.tintColor = .white
        checkoutButton.backgroundColor = .systemGreen
        checkoutButton.layer.cornerRadius = 8
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)

        view.addSubview(checkoutButton)

        NSLayoutConstraint.activate([
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            checkoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actualizar carrito
    private func updateCartItems() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for item in cartItems {
            let itemView = createItemView(for: item)
            stackView.addArrangedSubview(itemView)
        }

        updateTotal()
    }

    private func createItemView(for product: Product) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true

        let imageView = UIImageView(image: product.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let nameLabel = UILabel()
        nameLabel.text = product.name
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let priceLabel = UILabel()
        priceLabel.text = "$\(String(format: "%.2f", product.price))"
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView(arrangedSubviews: [imageView, nameLabel, priceLabel])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.distribution = .fillProportionally
        hStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: view.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        return view
    }

    private func updateTotal() {
        let total = cartItems.reduce(0.0) { $0 + $1.price }
        totalLabel.text = "Total: $\(String(format: "%.2f", total))"
    }

    @objc private func checkoutTapped() {
        cartItems.removeAll()
        updateCartItems()
    }
    
    
    
    
}


