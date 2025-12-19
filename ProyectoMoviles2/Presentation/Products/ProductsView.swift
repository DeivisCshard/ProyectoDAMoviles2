//
//  ProductsView.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//


import UIKit


protocol ProductsViewDelegate: AnyObject {
    func didTapAddProduct(at index: Int)
}


class ProductsView: UIView {
//hola
    // MARK: - Properties

    private let gridStack = UIStackView()
    private let bottomBar = UIStackView()

    private var productViews: [ProductItemView] = []
    
    weak var delegate: ProductsViewDelegate?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupBottomBar()
        setupGrid()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Grid

    private func setupGrid() {
        gridStack.axis = .vertical
        gridStack.spacing = 12
        gridStack.translatesAutoresizingMaskIntoConstraints = false

        for _ in 0..<2 {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 12
            row.distribution = .fillEqually

            for _ in 0..<2 {
                let productView = ProductItemView()
                productView.translatesAutoresizingMaskIntoConstraints = false
                productView.heightAnchor.constraint(equalToConstant: 190).isActive = true

                productViews.append(productView)
                row.addArrangedSubview(productView)
            }

            gridStack.addArrangedSubview(row)
        }

        addSubview(gridStack)

        NSLayoutConstraint.activate([
            gridStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            gridStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            gridStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            gridStack.bottomAnchor.constraint(equalTo: bottomBar.topAnchor, constant: -16)
        ])
    }
    
    // MARK: - Bottom Bar

    private func setupBottomBar() {
        bottomBar.axis = .horizontal
        bottomBar.distribution = .fillEqually
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.backgroundColor = .systemGray6

        addSubview(bottomBar)

        NSLayoutConstraint.activate([
            bottomBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Public

    func configureCategories(_ categories: [ProductsCategory], action: Selector, target: Any) {
        bottomBar.arrangedSubviews.forEach { $0.removeFromSuperview() }

        categories.enumerated().forEach { index, category in
            let button = UIButton(type: .system)
            button.setTitle(category.title, for: .normal)
            button.tag = index
            button.addTarget(target, action: action, for: .touchUpInside)
            bottomBar.addArrangedSubview(button)
        }
    }

    func updateProducts(_ products: [ProductEntity]) {
        // Limpiar celdas anteriores
        gridStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        var rowStack: UIStackView?
        
        for (index, product) in products.enumerated() {
            if index % 2 == 0 {
                rowStack = UIStackView()
                rowStack!.axis = .horizontal
                rowStack!.spacing = 12
                rowStack!.distribution = .fillEqually
                gridStack.addArrangedSubview(rowStack!)
            }
            
            let productView = ProductItemView()
            productView.heightAnchor.constraint(equalToConstant: 190).isActive = true
            productView.configure(product: product)
            productView.onAddTapped = { [weak self] in
                self?.delegate?.didTapAddProduct(at: index)
            }
            
            rowStack!.addArrangedSubview(productView)
        }
    }

}
 

