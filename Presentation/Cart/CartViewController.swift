import UIKit


class CartViewController: UIViewController {

    private let tableView = UITableView()
    private let checkoutButton = UIButton(type: .system)
    private let totalLabel = UILabel()
    
    // Diccionario para manejar cantidades
    private var cartDict: [String: CartItem] = [:]

    // Variable para recibir productos
    var cartItems: [Product] = [] {
        didSet {
            // Actualizar diccionario con cantidades
            cartDict.removeAll()
            for product in cartItems {
                if let existing = cartDict[product.name] {
                    cartDict[product.name] = CartItem(product: product, quantity: existing.quantity + 1)
                } else {
                    cartDict[product.name] = CartItem(product: product, quantity: 1)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Carrito"
        view.backgroundColor = .systemBackground
        setupTable()
        setupTotalLabel()
        setupCheckoutButton()
        updateTotal()
    }

    // MARK: - Tabla
    private func setupTable() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110)
        ])
    }

    // MARK: - Label total
    private func setupTotalLabel() {
        totalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        totalLabel.textColor = .label
        totalLabel.textAlignment = .center
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(totalLabel)

        NSLayoutConstraint.activate([
            totalLabel.heightAnchor.constraint(equalToConstant: 30),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            totalLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }

    private func updateTotal() {
        let total = cartDict.values.reduce(0) { $0 + $1.subtotal }
        totalLabel.text = "Total: $\(total)"
    }

    // MARK: - Botón finalizar
    private func setupCheckoutButton() {
        checkoutButton.setTitle("Finalizar compra", for: .normal)
        checkoutButton.backgroundColor = .systemGreen
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.layer.cornerRadius = 10
        checkoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkoutButton)

        NSLayoutConstraint.activate([
            checkoutButton.heightAnchor.constraint(equalToConstant: 50),
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    @objc private func checkoutTapped() {
        let alert = UIAlertController(title: "Compra finalizada", message: "Se ha vaciado tu carrito.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)

        cartItems.removeAll()
        cartDict.removeAll()
        tableView.reloadData()
        updateTotal()
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartDict.values.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cartArray = Array(cartDict.values)
        let item = cartArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Mostrar nombre, precio unitario, cantidad y subtotal
        cell.textLabel?.text = "\(item.product.name) - $\(item.product.price) x\(item.quantity) = $\(item.subtotal)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.selectionStyle = .none

        return cell
    }
}
