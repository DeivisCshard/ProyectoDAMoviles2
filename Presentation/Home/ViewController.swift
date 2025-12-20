//
//  ViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import AVFoundation

// MARK: - MODELO PROMOCIONES
struct HomeBanner {
    let title: String
    let subtitle: String
    let icon: String
    let color: UIColor
}

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var bb: UIButton!

    // MARK: - HEADER
    private let headerView = UIView()
    private let headerTitle = UILabel()
    private let menuButton = UIButton(type: .system)
    private let loginButton = UIButton(type: .system)
    private let loginIndicator = UIView()

    // MARK: - GREETING
    private let greetingLabel = UILabel()
    private let subtitleLabel = UILabel()

    // MARK: - CARRUSEL PROMOCIONES
    private let carouselTitleLabel = UILabel()

    private lazy var carouselLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return layout
    }()

    private lazy var carouselCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = .fast
        return cv
    }()

    // MARK: - VIDEO MEJORES VALORADOS
    private let videoTitleLabel = UILabel()
    private let videoContainer = UIView()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    

    // MARK: - DATOS PROMOCIONES
    private let banners: [HomeBanner] = [
        HomeBanner(title: "🎄 Navidad Sale", subtitle: "Hasta 40% OFF", icon: "gift.fill", color: .systemRed),
        HomeBanner(title: "👟 Nuevos lanzamientos", subtitle: "Colección 2025", icon: "bag.fill", color: .systemIndigo),
        HomeBanner(title: "🔥 Exclusivo", subtitle: "Solo por hoy", icon: "flame.fill", color: .systemOrange)
    ]

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)

        let username = UserSession.shared.username ?? "Usuario"
        greetingLabel.text = "Hi \(username)!"

        updateLoginIndicator()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoContainer.bounds
    }

    // MARK: - UI SETUP
    private func setupUI() {
        view.backgroundColor = .systemGray6

        setupHeader()
        setupGreeting()
        setupCarousel()
        setupVideoSection()
        updateLoginIndicator()

    }
    
    

    // MARK: - HEADER
    private func setupHeader() {
        headerView.backgroundColor = UIColor(red: 0/255, green: 38/255, blue: 74/255, alpha: 1)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        headerTitle.text = "Inicio"
        headerTitle.textColor = .white
        headerTitle.font = .boldSystemFont(ofSize: 18)
        headerTitle.translatesAutoresizingMaskIntoConstraints = false

        menuButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        menuButton.tintColor = .white
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        
        
        loginButton.setImage(UIImage(systemName: "person.circle"), for: .normal)
        loginButton.tintColor = .white
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(openLogin), for: .touchUpInside)
        
        
        loginIndicator.translatesAutoresizingMaskIntoConstraints = false
        loginIndicator.layer.cornerRadius = 5
        loginIndicator.clipsToBounds = true

        view.addSubview(headerView)
        headerView.addSubview(headerTitle)
        headerView.addSubview(menuButton)
        headerView.addSubview(loginButton)
        headerView.addSubview(loginIndicator)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),

            headerTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),

            menuButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            menuButton.centerYAnchor.constraint(equalTo: headerTitle.centerYAnchor),
            
            
            loginButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
               loginButton.centerYAnchor.constraint(equalTo: headerTitle.centerYAnchor),
               loginButton.widthAnchor.constraint(equalToConstant: 30),
               loginButton.heightAnchor.constraint(equalToConstant: 30),

               loginIndicator.widthAnchor.constraint(equalToConstant: 10),
               loginIndicator.heightAnchor.constraint(equalToConstant: 10),
               loginIndicator.topAnchor.constraint(equalTo: loginButton.topAnchor),
               loginIndicator.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor)
        ])
    }
    @objc private func openLogin() {
        if UserSession.shared.isLoggedIn {
            tabBarController?.selectedIndex = 2 // Profile
        } else {
            let loginVC = LoginViewController()
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    private func updateLoginIndicator() {
        loginIndicator.backgroundColor =
            UserSession.shared.isLoggedIn ? .systemGreen : .systemRed
    }
    // MARK: - GREETING
    private func setupGreeting() {
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

    // MARK: - CARRUSEL PROMOCIONES
    private func setupCarousel() {
        carouselTitleLabel.text = "Promociones"
        carouselTitleLabel.font = .boldSystemFont(ofSize: 20)
        carouselTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.register(
            HomeBannerCell.self,
            forCellWithReuseIdentifier: HomeBannerCell.identifier
        )

        view.addSubview(carouselTitleLabel)
        view.addSubview(carouselCollectionView)

        NSLayoutConstraint.activate([
            carouselTitleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            carouselTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            carouselCollectionView.topAnchor.constraint(equalTo: carouselTitleLabel.bottomAnchor, constant: 16),
            carouselCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    // MARK: - VIDEO MEJORES VALORADOS
    private func setupVideoSection() {
        videoTitleLabel.text = "Mejores valorados"
        videoTitleLabel.font = .boldSystemFont(ofSize: 20)
        videoTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        videoContainer.backgroundColor = .black
        videoContainer.layer.cornerRadius = 16
        videoContainer.clipsToBounds = true
        videoContainer.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(videoTitleLabel)
        view.addSubview(videoContainer)

        NSLayoutConstraint.activate([
            videoTitleLabel.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 32),
            videoTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            videoContainer.topAnchor.constraint(equalTo: videoTitleLabel.bottomAnchor, constant: 16),
            videoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            videoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            videoContainer.heightAnchor.constraint(equalToConstant: 260)
        ])

        setupVideoPlayer()
    }

    private func setupVideoPlayer() {
        guard let path = Bundle.main.path(forResource: "VideoNavideno", ofType: "mp4") else {
            print("❌ Video no encontrado")
            return
        }

        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        player?.isMuted = true

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = videoContainer.bounds

        if let playerLayer = playerLayer {
            videoContainer.layer.addSublayer(playerLayer)
        }

        player?.play()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loopVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }
    
    @objc private func loopVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    // MARK: - ACTIONS
    @objc private func openMenu() {
        let menuVC = SideMenuViewController()
        menuVC.modalPresentationStyle = .overFullScreen
        present(menuVC, animated: false)
    }
}

// MARK: - COLLECTION VIEW
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        banners.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeBannerCell.identifier,
            for: indexPath
        ) as! HomeBannerCell

        cell.configure(with: banners[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        CGSize(
            width: collectionView.bounds.width - 48,
            height: collectionView.bounds.height
        )
    }
    
    
}
