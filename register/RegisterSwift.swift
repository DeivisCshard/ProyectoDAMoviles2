import UIKit

struct RegisterViewState {
    var isLoading: Bool = false
    var errorMessage: String? = nil
}

final class RegisterView: UIView {

    let titleLabel = UILabel()

    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let dniTextField = UITextField()
    let emailTextField = UITextField()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()

    let registerButton = UIButton(type: .system)

    private let cardView = UIView()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackground()
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemGreen.cgColor,
            UIColor.systemRed.cgColor
        ]
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }

    private func setupSubviews() {
        addSubview(cardView)
        cardView.addSubview(stackView)

        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        cardView.layer.cornerRadius = 22
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowRadius = 15

        stackView.axis = .vertical
        stackView.spacing = 12

        titleLabel.text = "🎄 Crear cuenta"
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textAlignment = .center

        [
            (firstNameTextField, "Nombres", "person"),
            (lastNameTextField, "Apellidos", "person"),
            (dniTextField, "DNI", "number"),
            (emailTextField, "Correo", "envelope"),
            (usernameTextField, "Usuario", "person.circle"),
            (passwordTextField, "Contraseña", "lock")
        ].forEach {
            configureField($0.0, placeholder: $0.1, icon: $0.2)
        }

        passwordTextField.isSecureTextEntry = true

        registerButton.setTitle("Registrarse", for: .normal)
        registerButton.backgroundColor = .systemRed
        registerButton.tintColor = .white
        registerButton.layer.cornerRadius = 12
        registerButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

        [
            titleLabel,
            firstNameTextField,
            lastNameTextField,
            dniTextField,
            emailTextField,
            usernameTextField,
            passwordTextField,
            registerButton
        ].forEach { stackView.addArrangedSubview($0) }
    }

    private func configureField(_ field: UITextField, placeholder: String, icon: String) {
        field.placeholder = placeholder
        field.backgroundColor = UIColor.systemGray6
        field.layer.cornerRadius = 10
        field.heightAnchor.constraint(equalToConstant: 42).isActive = true

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemGray
        iconView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        iconView.contentMode = .center
        field.leftView = iconView
        field.leftViewMode = .always
    }

    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
    }

    func update(with state: RegisterViewState) {
        registerButton.isEnabled = !state.isLoading
    }
}
