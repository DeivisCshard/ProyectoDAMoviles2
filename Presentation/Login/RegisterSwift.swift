import UIKit

// MARK: - Estado de la vista
struct RegisterViewState {
    var isLoading: Bool = false
    var errorMessage: String? = nil
}

// MARK: - Vista de Registro
final class RegisterView: UIView {

    // MARK: - Labels y campos
    let titleLabel = UILabel()
    
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let dniTextField = UITextField()
    let emailTextField = UITextField()       // <-- Campo de correo antes del usuario
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    
    let registerButton = UIButton(type: .system)

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
        
        let snowEmitter = CAEmitterLayer()
        snowEmitter.emitterPosition = CGPoint(x: bounds.width / 2, y: -50)
        snowEmitter.emitterShape = .line
        snowEmitter.emitterSize = CGSize(width: bounds.width, height: 1)
        
        let snowflake = CAEmitterCell()
        snowflake.contents = UIImage(systemName: "snowflake")?.withTintColor(.white).cgImage
        snowflake.birthRate = 5
        snowflake.lifetime = 20
        snowflake.velocity = 50
        snowflake.velocityRange = 20
        snowflake.yAcceleration = 30
        snowflake.scale = 0.05
        snowflake.scaleRange = 0.02
        
        snowEmitter.emitterCells = [snowflake]
        layer.addSublayer(snowEmitter)
    }

    // MARK: - Subviews
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(firstNameTextField)
        addSubview(lastNameTextField)
        addSubview(dniTextField)
        addSubview(emailTextField)            // <-- Antes del usuario
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(registerButton)
        
        // Título
        titleLabel.text = "Regístrate"
        titleLabel.textColor = .red
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.textAlignment = .center
        
        // Campos de texto
        let fields = [
            (firstNameTextField, "Nombres"),
            (lastNameTextField, "Apellidos"),
            (dniTextField, "DNI"),
            (emailTextField, "Correo Electrónico"), // <-- Email antes del username
            (usernameTextField, "Usuario"),
            (passwordTextField, "Contraseña")
        ]
        
        fields.forEach { (tf, placeholder) in
            tf.placeholder = placeholder
            tf.borderStyle = .roundedRect
            tf.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        }
        
        passwordTextField.isSecureTextEntry = true
        
        // Botón
        registerButton.setTitle("Registrarse", for: .normal)
        registerButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        registerButton.layer.cornerRadius = 8
        registerButton.tintColor = .red
    }

    // MARK: - Layout
    private func setupConstraints() {
        [titleLabel,
         firstNameTextField, lastNameTextField,
         dniTextField, emailTextField, usernameTextField, passwordTextField,
         registerButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            firstNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            firstNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            firstNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 15),
            lastNameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            lastNameTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            
            dniTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 15),
            dniTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            dniTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: dniTextField.bottomAnchor, constant: 15),
            emailTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            
            usernameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            usernameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            registerButton.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actualizar estado
    func update(with state: RegisterViewState) {
        registerButton.isEnabled = !state.isLoading
        // Aquí podrías mostrar errores
    }
}
