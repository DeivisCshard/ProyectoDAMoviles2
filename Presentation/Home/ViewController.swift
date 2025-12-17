//
//  ViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bb: UIButton!
    
    private let headerView = UIView()
        private let headerTitle = UILabel()
        private let menuButton = UIButton(type: .system)

        private let greetingLabel = UILabel()
        private let subtitleLabel = UILabel()

        private let searchContainer = UIView()
        private let searchIcon = UIImageView()
        private let searchTextField = UITextField()

        private let welcomeCard = UIView()
        private let welcomeTitle = UILabel()
        private let welcomeSubtitle = UILabel()
        private let welcomeIcon = UIImageView()

        private let sectionLabel = UILabel()

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }

        // MARK: - Setup UI

        private func setupUI() {
            view.backgroundColor = UIColor.systemGray6

            setupHeader()
            setupGreeting()
            setupSearch()
            setupWelcomeCard()
            setupSection()
        }

    
    private func setupHeader() {
            headerView.backgroundColor = UIColor(red: 0/255, green: 38/255, blue: 74/255, alpha: 1)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(headerView)

            headerTitle.text = "Inicio"
            headerTitle.textColor = .white
            headerTitle.font = .boldSystemFont(ofSize: 18)
            headerTitle.translatesAutoresizingMaskIntoConstraints = false

            menuButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
            menuButton.tintColor = .white
            menuButton.translatesAutoresizingMaskIntoConstraints = false

            headerView.addSubview(headerTitle)
            headerView.addSubview(menuButton)

            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: view.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 100),

                headerTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                headerTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),

                menuButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
                menuButton.centerYAnchor.constraint(equalTo: headerTitle.centerYAnchor)
            ])
        }

        private func setupGreeting() {
            greetingLabel.text = "Hi Gabriel!"
            greetingLabel.font = .boldSystemFont(ofSize: 28)
            greetingLabel.translatesAutoresizingMaskIntoConstraints = false

            subtitleLabel.text = "Good Morning"
            subtitleLabel.textColor = .secondaryLabel
            subtitleLabel.font = .systemFont(ofSize: 16)
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(greetingLabel)
            view.addSubview(subtitleLabel)

            NSLayoutConstraint.activate([
                greetingLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
                greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

                subtitleLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
                subtitleLabel.leadingAnchor.constraint(equalTo: greetingLabel.leadingAnchor)
            ])
        }

        private func setupSearch() {
            searchContainer.backgroundColor = .white
            searchContainer.layer.cornerRadius = 14
            searchContainer.translatesAutoresizingMaskIntoConstraints = false

            searchIcon.image = UIImage(systemName: "magnifyingglass")
            searchIcon.tintColor = .systemTeal
            searchIcon.translatesAutoresizingMaskIntoConstraints = false

            searchTextField.placeholder = "Search products..."
            searchTextField.borderStyle = .none
            searchTextField.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(searchContainer)
            searchContainer.addSubview(searchIcon)
            searchContainer.addSubview(searchTextField)

            NSLayoutConstraint.activate([
                searchContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
                searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                searchContainer.heightAnchor.constraint(equalToConstant: 56),

                searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
                searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),

                searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 12),
                searchTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -16),
                searchTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor)
            ])
        }

        private func setupWelcomeCard() {
            welcomeCard.backgroundColor = UIColor.systemGray5
            welcomeCard.layer.cornerRadius = 16
            welcomeCard.translatesAutoresizingMaskIntoConstraints = false

            welcomeTitle.text = "Welcome!"
            welcomeTitle.font = .boldSystemFont(ofSize: 18)
            welcomeTitle.translatesAutoresizingMaskIntoConstraints = false

            welcomeSubtitle.text = "Let's explore new shoes for you"
            welcomeSubtitle.font = .systemFont(ofSize: 14)
            welcomeSubtitle.textColor = .secondaryLabel
            welcomeSubtitle.numberOfLines = 2
            welcomeSubtitle.translatesAutoresizingMaskIntoConstraints = false

            welcomeIcon.image = UIImage(systemName: "bag.fill")
            welcomeIcon.tintColor = .systemGray
            welcomeIcon.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(welcomeCard)
            welcomeCard.addSubview(welcomeTitle)
            welcomeCard.addSubview(welcomeSubtitle)
            welcomeCard.addSubview(welcomeIcon)

            NSLayoutConstraint.activate([
                welcomeCard.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 20),
                welcomeCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                welcomeCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                welcomeCard.heightAnchor.constraint(equalToConstant: 110),

                welcomeTitle.topAnchor.constraint(equalTo: welcomeCard.topAnchor, constant: 20),
                welcomeTitle.leadingAnchor.constraint(equalTo: welcomeCard.leadingAnchor, constant: 20),

                welcomeSubtitle.topAnchor.constraint(equalTo: welcomeTitle.bottomAnchor, constant: 6),
                welcomeSubtitle.leadingAnchor.constraint(equalTo: welcomeTitle.leadingAnchor),
                welcomeSubtitle.trailingAnchor.constraint(equalTo: welcomeIcon.leadingAnchor, constant: -12),

                welcomeIcon.trailingAnchor.constraint(equalTo: welcomeCard.trailingAnchor, constant: -20),
                welcomeIcon.centerYAnchor.constraint(equalTo: welcomeCard.centerYAnchor),
                welcomeIcon.widthAnchor.constraint(equalToConstant: 40),
                welcomeIcon.heightAnchor.constraint(equalToConstant: 40)
            ])
        }

        private func setupSection() {
            sectionLabel.text = "Ongoing Projects"
            sectionLabel.font = .boldSystemFont(ofSize: 18)
            sectionLabel.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(sectionLabel)

            NSLayoutConstraint.activate([
                sectionLabel.topAnchor.constraint(equalTo: welcomeCard.bottomAnchor, constant: 28),
                sectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
            ])
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    }
