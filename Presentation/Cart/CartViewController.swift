//
//  CartViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit
import CoreData

class CartViewController: UIViewController {

    var tempCart: [TempCartItem] = [] // no Core Data aún
    var onCheckoutComplete: (() -> Void)?   // <-- aquí agregamos el callback
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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

        for item in tempCart {
            let itemView = createItemView(for: item)
            stackView.addArrangedSubview(itemView)
        }

        updateTotal()
    }

    private func createItemView(for item: TempCartItem) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // Imagen
        let imageView = UIImageView()
        if let data = item.product.image {
            imageView.image = UIImage(data: data)
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // Nombre
        let nameLabel = UILabel()
        nameLabel.text = item.product.name
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        // Cantidad + Precio
        let detailLabel = UILabel()
        detailLabel.text = "Cantidad: \(item.quantity) • Precio: $\(String(format: "%.2f", item.total))"
        detailLabel.font = .systemFont(ofSize: 14)
        detailLabel.textColor = .darkGray
        detailLabel.numberOfLines = 1

        // Stack vertical para nombre + detalles
        let vStack = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        vStack.axis = .vertical
        vStack.spacing = 4
        vStack.alignment = .leading
        vStack.translatesAutoresizingMaskIntoConstraints = false

        // Stack horizontal imagen + vStack
        let hStack = UIStackView(arrangedSubviews: [imageView, vStack])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])

        return container
    }

    private func updateTotal() {
        let total = tempCart.reduce(0) { $0 + $1.total }
        totalLabel.text = String(format: "Total: $%.2f", total)
    }

    @objc private func checkoutTapped() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        for item in tempCart {
            let cartItem = CartEntity(context: context)
            cartItem.id = UUID()
            cartItem.createdAt = Date()
            cartItem.quantity = Int16(item.quantity)
            cartItem.total = item.total
            cartItem.product = item.product

            // Reducir stock real
            item.product.stock -= Int16(item.quantity)
        }

        try? context.save()
        tempCart.removeAll()
        updateCartItems()

        // Notificar a ProductsViewController
        onCheckoutComplete?()
    }
    
}
 

