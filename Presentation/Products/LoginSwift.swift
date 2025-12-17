import UIKit

struct LoginViewState {
    var isLoading: Bool = false
    var errorMessage: String? = nil
}

final class LoginView: UIView {

    // MARK: - Labels y campos
    let titleLabel = UILabel()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()   
    let loginButton = UIButton(type: .system)
    let registerButton = UIButton(type: .system) // propiedad correcta

    // MARK: - Inicializador
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackground()
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Fondo navideño
    private func setupBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.red.cgColor, UIColor.systemOrange.cgColor, UIColor.yellow.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let snowEmitter = CAEmitterLayer()
            snowEmitter.emitterPosition = CGPoint(x: self.bounds.width / 2, y: -50)
            snowEmitter.emitterShape = .line
            snowEmitter.emitterSize = CGSize(width: self.bounds.width, height: 1)

            let snowflake = CAEmitterCell()
            snowflake.contents = UIImage(systemName: "snowflake")?.withTintColor(.white).cgImage
            snowflake.birthRate = 2   // reducir partículas
            snowflake.lifetime = 20
            snowflake.velocity = 30
            snowflake.velocityRange = 10
            snowflake.yAcceleration = 20
            snowflake.scale = 0.03
            snowflake.scaleRange = 0.01

            snowEmitter.emitterCells = [snowflake]
            self.layer.addSublayer(snowEmitter)
        }
    }


    // MARK: - Subviews
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(registerButton) // agrega la propiedad

        // Título
        titleLabel.text = "Iniciar sesión"
        titleLabel.textColor = .red
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.textAlignment = .center

        // Campos de texto
        let fields = [
            (usernameTextField, "Usuario"),
            (passwordTextField, "Contraseña")
        ]

        fields.forEach { (tf, placeholder) in
            tf.placeholder = placeholder
            tf.borderStyle = .roundedRect
            tf.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        }

        passwordTextField.isSecureTextEntry = true

        // Botón Login
        loginButton.setTitle("Iniciar sesión", for: .normal)
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        loginButton.layer.cornerRadius = 8
        loginButton.tintColor = .red

        // Botón Register
        registerButton.setTitle("¿No tienes cuenta? Registrarse", for: .normal)
        registerButton.setTitleColor(.blue, for: .normal)
        registerButton.titleLabel?.textAlignment = .center
        registerButton.backgroundColor = .clear
    }

    // MARK: - Layout
    private func setupConstraints() {
        [titleLabel, usernameTextField, passwordTextField, loginButton, registerButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }

    // MARK: - Actualizar estado
    func update(with state: LoginViewState) {
        loginButton.isEnabled = !state.isLoading
    }
}
