//
//  ProductItemView.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//


import UIKit

class ProductItemView: UIView {

    var onAddTapped: (() -> Void)?

    private let imageView = UIImageView()
    private let infoView = UIView()

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let stockLabel = UILabel()
    private let addButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Info bar
        infoView.backgroundColor = .systemRed
        infoView.translatesAutoresizingMaskIntoConstraints = false

        // Labels
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 2

        priceLabel.font = .boldSystemFont(ofSize: 14)
        priceLabel.textColor = .white

        stockLabel.font = .systemFont(ofSize: 12)
        stockLabel.textColor = .white

        // Button
        addButton.setTitle("Agregar", for: .normal)
        addButton.tintColor = .white
        addButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)

        let leftStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel, stockLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 2

        let infoStack = UIStackView(arrangedSubviews: [leftStack, addButton])
        infoStack.axis = .horizontal
        infoStack.distribution = .equalSpacing
        infoStack.alignment = .center
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        infoView.addSubview(infoStack)
        addSubview(imageView)
        addSubview(infoView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 140),

            infoView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 50),

            infoStack.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 8),
            infoStack.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -8),
            infoStack.centerYAnchor.constraint(equalTo: infoView.centerYAnchor)
        ])
    }

    func configure(product: Product) {
        imageView.image = product.image
        nameLabel.text = product.name
        priceLabel.text = String(format: "$%.2f", product.price)  // Formato adecuado para el precio
        stockLabel.text = "Stock: \(product.stock)"
    }

    @objc private func addTapped() {
        onAddTapped?()
    }
}

