//
//  LoginViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 17/12/25.
//

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
        
        loginView.passwordTextField.isSecureTextEntry = true
        loginView.passwordTextField.textContentType = .none
        loginView.passwordTextField.autocorrectionType = .no
        loginView.passwordTextField.autocapitalizationType = .none
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

        print("Iniciar sesión con \(username) y \(password)")

        UserSession.shared.isLoggedIn = true

        let alert = UIAlertController(
            title: "¡Éxito!",
            message: "Ya estás en línea.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
            self.goToMainTabBar()
        })

        present(alert, animated: true)
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
    
    private func goToMainTabBar() {
        let tabBar = MainTabBarController()

        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = scene.delegate as? SceneDelegate,
            let window = sceneDelegate.window
        else {
            return
        }

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = tabBar
            }
        )
    }

}
    
