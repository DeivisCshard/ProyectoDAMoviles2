import UIKit

final class RegisterViewController: UIViewController {

    private let registerView = RegisterView()

    override func loadView() {
        view = registerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        
        //.systemBackground
        setupActions()
    }

    private func setupActions() {
        registerView.registerButton.addTarget(
            self,
            action: #selector(registerTapped),
            for: .touchUpInside
        )
    }

    @objc private func registerTapped() {
        guard let firstName = registerView.firstNameTextField.text, !firstName.isEmpty else {
            showError("Por favor ingresa tu nombre")
            return
        }

        guard let lastName = registerView.lastNameTextField.text, !lastName.isEmpty else {
            showError("Por favor ingresa tus apellidos")
            return
        }

        guard let dni = registerView.dniTextField.text, dni.count >= 8 else {
            showError("El DNI debe tener al menos 8 dígitos")
            return
        }

        guard let username = registerView.usernameTextField.text, !username.isEmpty else {
            showError("Por favor ingresa un usuario")
            return
        }

        guard let password = registerView.passwordTextField.text, !password.isEmpty else {
            showError("Por favor ingresa una contraseña")
            return
        }

        print("Registrando usuario: \(username)")
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }
}
