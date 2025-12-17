import UIKit

class ProfileViewController: UIViewController {

    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let menuButton = UIButton(type: .system)

    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let lastNameLabel = UILabel()
    private let emailLabel = UILabel()
    private let companyLabel = UILabel()

    private let logoutButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground

        setupHeader()
        setupProfileInfo()
        setupLogoutButton()
    }

    private func setupHeader() {
        headerView.backgroundColor = UIColor(red: 0/255, green: 38/255, blue: 74/255, alpha: 1)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        titleLabel.text = "Usuario"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        menuButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        menuButton.tintColor = .white
        menuButton.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(titleLabel)
        headerView.addSubview(menuButton)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),

            menuButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            menuButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }

    private func setupProfileInfo() {
        avatarView.image = UIImage(systemName: "person.circle.fill")
        avatarView.tintColor = .systemGray3
        avatarView.contentMode = .scaleAspectFit
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = "andy"
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textAlignment = .center

        lastNameLabel.text = "munguia"
        lastNameLabel.font = .boldSystemFont(ofSize: 20)
        lastNameLabel.textAlignment = .center

        emailLabel.text = "andyjeison2007@gmail.com"
        emailLabel.font = .systemFont(ofSize: 14)
        emailLabel.textColor = .secondaryLabel
        emailLabel.textAlignment = .center

        companyLabel.text = "zap"
        companyLabel.font = .systemFont(ofSize: 16)
        companyLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [
            avatarView,
            nameLabel,
            lastNameLabel,
            emailLabel,
            companyLabel
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            avatarView.heightAnchor.constraint(equalToConstant: 100),
            avatarView.widthAnchor.constraint(equalToConstant: 100),

            stack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func setupLogoutButton() {
        logoutButton.setTitle("Cerrar sesión", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        logoutButton.backgroundColor = UIColor(red: 0/255, green: 38/255, blue: 74/255, alpha: 1)
        logoutButton.layer.cornerRadius = 24
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            logoutButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    // MARK: - Actions
    @objc private func logoutTapped() {
        // Cambiar estado de sesión
        UserSession.shared.isLoggedIn = false

        // Mostrar alerta
        let alert = UIAlertController(title: "Sesión cerrada", message: "Has cerrado sesión correctamente.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
            // Regresar al login
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
