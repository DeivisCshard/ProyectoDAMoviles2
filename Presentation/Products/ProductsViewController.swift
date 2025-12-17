import UIKit

final class UserSession {
    static let shared = UserSession()
    
    private init() { }
    
    // Estado de sesión
    var isLoggedIn: Bool = false
}
class ProductsViewController: UIViewController {

    private let productsView = ProductsView()
    private var currentCategory: ProductsCategory = .tazas

    private var products: [Product] = []
    private var cart: [Product] = []

    // Indicador de sesión
    private var loginIndicator: UIView?

    override func loadView() {
        view = productsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos Navideños"
        setup()
        setupCartButton()
        setupLoginButton() // botón de login con indicador
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLoginButtonAppearance()
    }

    private func setup() {
        productsView.configureCategories(
            ProductsCategory.allCases,
            action: #selector(categoryTapped(_:)),
            target: self
        )

        products = currentCategory.products
        productsView.updateProducts(products)
        productsView.delegate = self
    }

    // Botón de carrito
    private func setupCartButton() {
        let cartButton = UIBarButtonItem(
            title: "Carrito",
            style: .plain,
            target: self,
            action: #selector(openCart)
        )

        if let loginButton = navigationItem.rightBarButtonItems?.first(where: { $0.tag == 100 }) {
            navigationItem.rightBarButtonItems = [cartButton, loginButton]
        } else {
            navigationItem.rightBarButtonItem = cartButton
        }
    }

    // Botón de login
    private func setupLoginButton() {
        let loginButton = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(openLogin)
        )
        loginButton.tag = 100
        navigationItem.rightBarButtonItem = loginButton

        // Agregar indicador
        let indicatorSize: CGFloat = 10
        let indicator = UIView(frame: CGRect(x: 24, y: 0, width: indicatorSize, height: indicatorSize))
        indicator.layer.cornerRadius = indicatorSize / 2
        indicator.backgroundColor = UserSession.shared.isLoggedIn ? .green : .red
        indicator.clipsToBounds = true
        loginIndicator = indicator

        // Convertimos el view en customView de un UIBarButtonItem
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.frame = containerView.bounds
        imageView.tintColor = .label
        containerView.addSubview(imageView)
        containerView.addSubview(indicator)

        let customLoginButton = UIBarButtonItem(customView: containerView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLogin))
        containerView.addGestureRecognizer(tapGesture)
        customLoginButton.tag = 100

        navigationItem.rightBarButtonItem = customLoginButton
    }

    // Actualizar color del indicador según sesión
    private func updateLoginButtonAppearance() {
        loginIndicator?.backgroundColor = UserSession.shared.isLoggedIn ? .green : .red
    }

    @objc private func categoryTapped(_ sender: UIButton) {
        currentCategory = ProductsCategory.allCases[sender.tag]
        products = currentCategory.products
        productsView.updateProducts(products)
    }

    @objc private func openCart() {
        let cartVC = CartViewController()
        cartVC.cartItems = cart
        navigationController?.pushViewController(cartVC, animated: true)
    }

    @objc private func openLogin() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: false)
    }
}

extension ProductsViewController: ProductsViewDelegate {

    func didTapAddProduct(at index: Int) {
        guard products[index].stock > 0 else { return }

        products[index].stock -= 1
        cart.append(products[index])

        productsView.updateProducts(products)
    }
}
