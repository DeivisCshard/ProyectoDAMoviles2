import UIKit

final class SideMenuViewController: UIViewController {

    private let overlayView = UIView()
    private let menuView = UIView()

    private let headerView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()

    private let ventasButton = UIButton(type: .system)

    private let menuWidth: CGFloat = UIScreen.main.bounds.width * 0.75

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGesture()
        animateIn()
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .clear

        // Overlay
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.alpha = 0
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Menu container
        menuView.backgroundColor = .systemGray6
        menuView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuView)

        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -menuWidth),
            menuView.widthAnchor.constraint(equalToConstant: menuWidth)
        ])

        setupHeader()
        setupVentas()
    }

    private func setupHeader() {
        headerView.backgroundColor = UIColor(red: 0/255, green: 38/255, blue: 74/255, alpha: 1)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(headerView)

        avatarImageView.image = UIImage(systemName: "bag.fill")
        avatarImageView.tintColor = .white

        nameLabel.text = "Zaply Store"
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 18)

        emailLabel.text = UserSession.shared.email ?? ""
        emailLabel.textColor = .white.withAlphaComponent(0.8)
        emailLabel.font = .systemFont(ofSize: 14)

        [avatarImageView, nameLabel, emailLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: menuView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 160),

            avatarImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 40),
            avatarImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }

    private func setupVentas() {
        ventasButton.setTitle("  Mis Ventas", for: .normal)
        ventasButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        ventasButton.tintColor = .label
        ventasButton.contentHorizontalAlignment = .leading
        ventasButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        ventasButton.translatesAutoresizingMaskIntoConstraints = false

        menuView.addSubview(ventasButton)

        NSLayoutConstraint.activate([
            ventasButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            ventasButton.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 20),
            ventasButton.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -20),
            ventasButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Gestures

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        overlayView.addGestureRecognizer(tap)
    }

    // MARK: - Animations

    private func animateIn() {
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = 1
            self.menuView.transform = CGAffineTransform(translationX: self.menuWidth, y: 0)
        }
    }

    @objc private func closeMenu() {
        UIView.animate(withDuration: 0.25, animations: {
            self.overlayView.alpha = 0
            self.menuView.transform = .identity
        }) { _ in
            self.dismiss(animated: false)
        }
    }
}
