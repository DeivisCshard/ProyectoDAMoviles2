//
//  HomeBannerCell.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 19/12/25.
//

import UIKit

final class HomeBannerCell: UICollectionViewCell {

    static let identifier = "HomeBannerCell"

    private let container = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let iconView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 20
        container.clipsToBounds = true

        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textColor = .white

        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .white.withAlphaComponent(0.9)

        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit

        [titleLabel, subtitleLabel, iconView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            iconView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            iconView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(with banner: HomeBanner) {
        container.backgroundColor = banner.color
        titleLabel.text = banner.title
        subtitleLabel.text = banner.subtitle
        iconView.image = UIImage(systemName: banner.icon)
    }
}
