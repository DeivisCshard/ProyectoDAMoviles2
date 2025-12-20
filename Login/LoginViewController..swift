//
//  LoginViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 17/12/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

 struct LoginViewState {
    var isLoading: Bool = false
    var errorMessage: String? = nil
}
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

        loginView.passwordTextField.isSecureTextEntry = true
        loginView.passwordTextField.textContentType = .none
        loginView.passwordTextField.autocorrectionType = .no
        loginView.passwordTextField.autocapitalizationType = .none
    }

    private func setupActions() {
        loginView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        loginView.guestButton.addTarget(self, action: #selector(guestTapped), for: .touchUpInside)
    }
    private func goToHome() {
        let tabBar = MainTabBarController()

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }

    // MARK: - Invitado
    @objc private func guestTapped() {
        let session = UserSession.shared
        session.isGuest = true
        session.isLoggedIn = false

        clearFields();
        goToHome()
    }

    // MARK: - Login
    @objc private func loginTapped() {
        guard let username = loginView.usernameTextField.text, !username.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            showError("Completa todos los campos")
            return
        }

        // 🔐 LOGIN ADMIN LOCAL
        if username == "admin" && password == "202500" {
            let productListVC = ProductListViewController()
            navigationController?.pushViewController(productListVC, animated: false)
            clearFields()
            return
        }

        // 🔥 LOGIN NORMAL CON FIREBASE
        Firestore.firestore()
            .collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in

                if let error = error {
                    self.showError(error.localizedDescription)
                    return
                }

                guard let document = snapshot?.documents.first,
                      let email = document.data()["email"] as? String else {
                    self.showError("Usuario no encontrado")
                    return
                }

                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        self.showError(error.localizedDescription)
                        return
                    }

                    let data = document.data()
                    let session = UserSession.shared

                    session.isLoggedIn = true
                    session.isGuest = false
                    session.uid = result?.user.uid
                    session.username = data["username"] as? String
                    session.firstName = data["firstName"] as? String
                    session.lastName = data["lastName"] as? String
                    session.email = email

                    self.clearFields()
                    self.goToHome()
                }
            }
    }

    @objc private func registerTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    private func clearFields() {
        loginView.usernameTextField.text = ""
        loginView.passwordTextField.text = ""
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alert, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let session = UserSession.shared
        let showGuest = !session.isLoggedIn && !session.isGuest
        loginView.configureGuestButton(visible: showGuest)
    }
    
    
}
