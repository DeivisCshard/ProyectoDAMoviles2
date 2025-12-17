//
//  ProductListViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 17/12/25.
//

import UIKit

class ProductListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let vm = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        title = "Products"
        view.backgroundColor = .systemBackground
        
        // Botón para agregar producto
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addProductTapped))
        
        // Agregar tabla
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
    }
    
    @objc private func addProductTapped() {
        let formVC = ProductFormViewController(vm: vm)
        formVC.delegate = self
        let nav = UINavigationController(rootViewController: formVC)
        present(nav, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        let product = vm.products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductListViewController: UITableViewDelegate {
    
    // Permitir eliminar
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = vm.products[indexPath.row]
            vm.deleteProduct(product: product)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Editar producto al tocar celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = vm.products[indexPath.row]
        let formVC = ProductFormViewController(vm: vm, productToEdit: product)
        formVC.delegate = self
        let nav = UINavigationController(rootViewController: formVC)
        present(nav, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ProductFormDelegate
extension ProductListViewController: ProductFormDelegate {
    func didUpdateProducts() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewCell personalizada
class ProductCell: UITableViewCell {
    static let identifier = "ProductCell"
    
    private let productImageView = UIImageView()
    private let nameLabel = UILabel()
    private let detailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.textColor = .gray
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(productImageView)
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 50),
            productImageView.heightAnchor.constraint(equalToConstant: 50),
            
            stack.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with product: Product) {
        if let data = product.image, let uiImage = UIImage(data: data) {
            productImageView.image = uiImage
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }
        nameLabel.text = product.name
        detailLabel.text = "Stock: \(product.stock) - $\(product.price) - \(product.category ?? "")"
    }
}
