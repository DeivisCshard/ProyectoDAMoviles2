//
//  CartItemCell.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 17/12/25.
//

import UIKit

class CartItemCell: UITableViewCell {

    private let productImageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let vStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Imagen del producto
        productImageView.contentMode = .scaleAspectFit
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(productImageView)
        
        // Etiquetas
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.numberOfLines = 0  // permite varias líneas
        nameLabel.lineBreakMode = .byWordWrapping
            
        priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        priceLabel.textColor = .systemGreen
        priceLabel.setContentHuggingPriority(.required, for: .vertical)

        // Stack vertical para nombre y precio
        vStack.axis = .vertical
        vStack.spacing = 4
        vStack.alignment = .leading
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(priceLabel)
        contentView.addSubview(vStack)

        // Constraints
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 50),
            productImageView.heightAnchor.constraint(equalToConstant: 50),
                
            vStack.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with cartItem: CartEntity) {
        let product = cartItem.product
        nameLabel.text = product?.name
        priceLabel.text = String(format: "$%.2f", cartItem.total)
        
        if let data = product?.image {
            productImageView.image = UIImage(data: data)
        }
    }
}
 
 
