import UIKit
import FirebaseAuth
import FirebaseFirestore

final class RegisterViewController: UIViewController, UITextFieldDelegate {

    private let registerView = RegisterView()
    private let db = Firestore.firestore()

    // MARK: - Lifecycle
    override func loadView() {
        view = registerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        // Solo números en DNI
        registerView.dniTextField.delegate = self
        registerView.dniTextField.keyboardType = .numberPad

        // Acción botón
        registerView.registerButton.addTarget(
            self,
            action: #selector(registerTapped),
            for: .touchUpInside
        )
    }

    // MARK: - Registro
    @objc private func registerTapped() {

        guard let firstName = registerView.firstNameTextField.text, !firstName.isEmpty,
              let lastName = registerView.lastNameTextField.text, !lastName.isEmpty,
              let dni = registerView.dniTextField.text,
              dni.count >= 8, dni.allSatisfy({ $0.isNumber }),
              let email = registerView.emailTextField.text, email.contains("@"),
              let username = registerView.usernameTextField.text, !username.isEmpty,
              let password = registerView.passwordTextField.text, password.count >= 6
        else {
            showError("Completa todos los campos correctamente")
            return
        }

        // 🔍 Validar username duplicado
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { [weak self] snapshot, error in

                if let error = error {
                    self?.showError("Error al verificar usuario: \(error.localizedDescription)")
                    return
                }

                if let snapshot = snapshot, !snapshot.isEmpty {
                    self?.showError("El nombre de usuario ya está en uso")
                    return
                }

                // ✅ Username libre → crear usuario
                self?.createUser(
                    firstName: firstName,
                    lastName: lastName,
                    dni: dni,
                    email: email,
                    username: username,
                    password: password
                )
            }
    }

    // MARK: - Crear usuario Firebase
    private func createUser(
        firstName: String,
        lastName: String,
        dni: String,
        email: String,
        username: String,
        password: String
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in

            if let error = error {
                print("🔥 Firebase Auth Error:", error)
                self?.showError(error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else {
                self?.showError("No se pudo obtener el usuario")
                return
            }

            let userData: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName,
                "dni": dni,
                "username": username,
                "email": email,
                "createdAt": Timestamp()
            ]

            self?.db.collection("users")
                .document(uid)
                .setData(userData) { error in

                    if let error = error {
                        self?.showError("Error al guardar datos: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(
                                title: "¡Éxito!",
                                message: "Registro completado. Inicia sesión.",
                                preferredStyle: .alert
                            )

                            alert.addAction(
                                UIAlertAction(title: "Aceptar", style: .default) { _ in
                                    self?.navigationController?.popViewController(animated: true)
                                }
                            )

                            self?.present(alert, animated: true)
                        }
                    }
                }
        }
    }

    // MARK: - Errores
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alert, animated: true)
        }
    }

    // MARK: - Solo números DNI
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textField == registerView.dniTextField {
            return CharacterSet.decimalDigits
                .isSuperset(of: CharacterSet(charactersIn: string))
        }
        return true
    }
}
