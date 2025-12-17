

import UIKit

final class LoginViewController: UIViewController {

    private let loginView = LoginView()
    private var state = LoginViewState()

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.update(with: state)
        setupActions()
    }

    private func setupActions() {
        // Login
        loginView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        // Register
        loginView.registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }

    @objc private func loginTapped() {
        guard let username = loginView.usernameTextField.text, !username.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            showError("Por favor, completa todos los campos.")
            return
        }

        // Aquí podrías agregar tu autenticación real
        print("Iniciar sesión con \(username) y \(password)")
    }

    
    
    
    @objc private func registerTapped() {
        let registerVC = RegisterViewController()
        registerVC.title = "Registro"
        navigationController?.pushViewController(registerVC, animated: true)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
    
    
    
}
