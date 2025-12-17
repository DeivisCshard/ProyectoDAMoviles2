import UIKit

final class RegisterViewController: UIViewController, UITextFieldDelegate {

    private let registerView = RegisterView()

    override func loadView() {
        view = registerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        // Solo permitir números en DNI
        registerView.dniTextField.delegate = self
        registerView.dniTextField.keyboardType = .numberPad

        // Acción del botón
        registerView.registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }

    @objc private func registerTapped() {
        // Validaciones básicas
        guard let firstName = registerView.firstNameTextField.text, !firstName.isEmpty,
              let lastName = registerView.lastNameTextField.text, !lastName.isEmpty,
              let dni = registerView.dniTextField.text, dni.count >= 8, dni.allSatisfy({ $0.isNumber }),
              let email = registerView.emailTextField.text, email.contains("@"),
              let username = registerView.usernameTextField.text, !username.isEmpty,
              let password = registerView.passwordTextField.text, !password.isEmpty
        else {
            showError("Completa todos los campos correctamente")
            return
        }

        // Registro exitoso: regresar al login
        let alert = UIAlertController(title: "¡Éxito!", message: "Registro completado. Por favor inicia sesión.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }

    // Permitir solo números en DNI
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == registerView.dniTextField {
            return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        }
        return true
    }
}
