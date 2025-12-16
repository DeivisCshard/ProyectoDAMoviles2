//
//  ProductItemView.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit

class ProductsItemView: UIView {

    private let imageView = UIImageView()
    private let infoView = UIView()
    private let priceLabel = UILabel()
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

        // Price
        priceLabel.textColor = .white
        priceLabel.font = .boldSystemFont(ofSize: 16)

        // Button
        addButton.setTitle("+", for: .normal)
        addButton.tintColor = .white
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 18)

        let infoStack = UIStackView(arrangedSubviews: [priceLabel, addButton])
        infoStack.axis = .horizontal
        infoStack.distribution = .equalSpacing
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
            infoView.heightAnchor.constraint(equalToConstant: 40),

            infoStack.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 8),
            infoStack.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -8),
            infoStack.centerYAnchor.constraint(equalTo: infoView.centerYAnchor)
        ])
    }

    func configure(image: UIImage, price: String) {
        imageView.image = image
        priceLabel.text = price
    }
}
