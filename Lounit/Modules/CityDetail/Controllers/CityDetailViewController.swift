//
//  CityDetailViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class CityDetailViewController: UIViewController {
    private enum Category: Int, CaseIterable {
        case culture
        case nature
        case food

        var normalImageName: String {
            switch self {
            case .culture:
                return "CityDetailCulture"
            case .nature:
                return "CityDetailNature"
            case .food:
                return "CityDetailFood"
            }
        }

        var selectedImageName: String {
            switch self {
            case .culture:
                return "CityDetailCultureSelected"
            case .nature:
                return "CityDetailNatureSelected"
            case .food:
                return "CityDetailFoodSelected"
            }
        }
    }

    private let heroImageView = UIImageView()
    private let backButton = UIButton(type: .custom)
    private let contentCardView = UIView()
    private let categoryStackView = UIStackView()
    private var categoryButtons: [UIButton] = []
    private var selectedCategory: Category = .culture
    private let titleLabel = UILabel()
    private let descriptionTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupView() {
        view.backgroundColor = .white

        heroImageView.image = UIImage(named: "ExploreHeroImage")?.withRenderingMode(.alwaysOriginal)
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        heroImageView.translatesAutoresizingMaskIntoConstraints = false

        backButton.setImage(UIImage(named: "AuthBackIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        contentCardView.backgroundColor = .white
        contentCardView.layer.cornerRadius = 28
        contentCardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentCardView.translatesAutoresizingMaskIntoConstraints = false

        categoryStackView.axis = .horizontal
        categoryStackView.distribution = .equalSpacing
        categoryStackView.alignment = .center
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false

        Category.allCases.forEach { category in
            let button = UIButton(type: .custom)
            button.tag = category.rawValue
            button.imageView?.contentMode = .scaleAspectFit
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(didTapCategory(_:)), for: .touchUpInside)
            categoryStackView.addArrangedSubview(button)
            categoryButtons.append(button)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 94),
                button.heightAnchor.constraint(equalToConstant: 94)
            ])
        }
        updateCategoryButtons()

        titleLabel.text = "Florence, Italy - Old Renaissance Town"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionTextView.text = """
        The birthplace of the Renaissance, home to masterpieces by Botticelli and Leonardo da Vinci in the Uffizi Gallery; medieval art and architecture abound throughout the city, including the dome of the Florence Cathedral, the Ponte Vecchio, and Piazzale Michelangelo.
        """
        descriptionTextView.textColor = UIColor(white: 0.26, alpha: 1)
        descriptionTextView.font = .systemFont(ofSize: 18, weight: .regular)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        view.addSubview(heroImageView)
        view.addSubview(backButton)
        view.addSubview(contentCardView)
        view.addSubview(categoryStackView)

        contentCardView.addSubview(titleLabel)
        contentCardView.addSubview(descriptionTextView)

        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: view.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.58),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),

            contentCardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 440),
            contentCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            categoryStackView.topAnchor.constraint(equalTo: contentCardView.topAnchor, constant: -78),
            categoryStackView.leadingAnchor.constraint(equalTo: contentCardView.leadingAnchor, constant: 36),
            categoryStackView.trailingAnchor.constraint(equalTo: contentCardView.trailingAnchor, constant: -36),
            categoryStackView.heightAnchor.constraint(equalToConstant: 94),

            titleLabel.topAnchor.constraint(equalTo: contentCardView.topAnchor, constant: 52),
            titleLabel.leadingAnchor.constraint(equalTo: contentCardView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentCardView.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 26),

            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentCardView.leadingAnchor, constant: 24),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentCardView.trailingAnchor, constant: -24),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentCardView.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapCategory(_ sender: UIButton) {
        guard let category = Category(rawValue: sender.tag) else { return }
        selectedCategory = category
        updateCategoryButtons()
    }

    private func updateCategoryButtons() {
        categoryButtons.forEach { button in
            guard let category = Category(rawValue: button.tag) else { return }
            let imageName = category == selectedCategory ? category.selectedImageName : category.normalImageName
            button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
}
