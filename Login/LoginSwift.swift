import UIKit



final class LoginView: UIView {

    // MARK: - UI
    let titleLabel = UILabel()

    let usernameTextField = UITextField()
    let passwordTextField = UITextField()

    let loginButton = UIButton(type: .system)
    let registerButton = UIButton(type: .system)
    let guestButton = UIButton(type: .system)

    private let cardView = UIView()
    private let stackView = UIStackView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackground()
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Background
    private func setupBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemGreen.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }

    // MARK: - Subviews
    private func setupSubviews() {
        addSubview(cardView)
        cardView.addSubview(stackView)

        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        cardView.layer.cornerRadius = 22
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowRadius = 15
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)

        stackView.axis = .vertical
        stackView.spacing = 16

        // Title
        titleLabel.text = "🎄 Bienvenido"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center

        // Fields
        configureField(usernameTextField, placeholder: "Usuario", icon: "person.fill")
        configureField(passwordTextField, placeholder: "Contraseña", icon: "lock.fill")
        passwordTextField.isSecureTextEntry = true

        // Buttons
        loginButton.setTitle("Iniciar sesión", for: .normal)
        loginButton.backgroundColor = UIColor.systemGreen
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 12
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

        guestButton.setTitle("Entrar como invitado", for: .normal)
        guestButton.setTitleColor(.systemGray, for: .normal)

        registerButton.setTitle("Crear cuenta", for: .normal)
        registerButton.setTitleColor(.systemRed, for: .normal)

        [
            titleLabel,
            usernameTextField,
            passwordTextField,
            loginButton,
            guestButton,
            registerButton
        ].forEach { stackView.addArrangedSubview($0) }
    }

    private func configureField(_ field: UITextField, placeholder: String, icon: String) {
        field.placeholder = placeholder
        field.backgroundColor = UIColor.systemGray6
        field.layer.cornerRadius = 10
        field.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemGray
        iconView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        iconView.contentMode = .center
        field.leftView = iconView
        field.leftViewMode = .always
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
    }

    // MARK: - Layout
    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 28),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -28)
        ])
    }

    func configureGuestButton(visible: Bool) {
        guestButton.isHidden = !visible
    }

    func update(with state: LoginViewState) {
        loginButton.isEnabled = !state.isLoading
    }
}
