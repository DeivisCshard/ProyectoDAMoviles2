//
//  ProductListViewController.swift
//  ProyectoMoviles2
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
        // Fondo navideño suave como en el formulario
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Título navideño con emojis
        title = "🎄 Products 🎁"
        
        // Botón agregar rojo con sombra verde
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.tintColor = .systemRed
        addButton.layer.shadowColor = UIColor.systemGreen.cgColor
        addButton.layer.shadowOpacity = 0.4
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowRadius = 4
        addButton.addTarget(self, action: #selector(addProductTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        
        // Agregar tabla
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
    }
    
    @objc private func addProductTapped() {
        let formVC = ProductFormViewController(vm: vm)
        formVC.delegate = self
        navigationController?.pushViewController(formVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.products.count
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
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = vm.products[indexPath.row]
            vm.deleteProduct(product: product)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = vm.products[indexPath.row]
        let formVC = ProductFormViewController(vm: vm, productToEdit: product)
        formVC.delegate = self
        navigationController?.pushViewController(formVC, animated: true)
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
    
    private let container = UIView()
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
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container navideño
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.systemRed.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0, height: 3)
        container.layer.shadowRadius = 6
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Imagen de producto
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 12
        productImageView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        productImageView.layer.borderColor = UIColor.systemRed.cgColor
        productImageView.layer.borderWidth = 1
        container.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Labels
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .systemRed
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.textColor = .darkGray
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            productImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            productImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 70),
            productImageView.heightAnchor.constraint(equalToConstant: 70),
            
            stack.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
    func configure(with product: ProductEntity) {
        if let data = product.image, let uiImage = UIImage(data: data) {
            productImageView.image = uiImage
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }
        nameLabel.text = product.name
        detailLabel.text = "Stock: \(product.stock) - $\(product.price) - \(product.category ?? "")"
    }
}
