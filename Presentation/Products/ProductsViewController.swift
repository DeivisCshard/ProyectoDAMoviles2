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

    override func loadView() {
        view = productsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos Navideños"
        setup()
        setupCartButton()
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
            image: UIImage(systemName: "cart"),
            style: .plain,
            target: self,
            action: #selector(openCart)
        )
        navigationItem.rightBarButtonItem = cartButton
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
}

extension ProductsViewController: ProductsViewDelegate {

    func didTapAddProduct(at index: Int) {
        guard products[index].stock > 0 else { return }

        products[index].stock -= 1
        cart.append(products[index])

        productsView.updateProducts(products)
    }
}
