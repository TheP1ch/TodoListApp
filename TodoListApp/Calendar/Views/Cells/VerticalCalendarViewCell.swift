//
//  VerticalCalendarViewCell.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import SwiftUI

final class VerticalCalendarViewCell: UITableViewCell {
    static let cellId = "VerticalCalendarViewCell"

    // MARK: view properties
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3

        return label
    }()

    private lazy var categoryColorCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()

    // MARK: Initialization
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = ColorTheme.Back.backSecondary.uiColor
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        descriptionLabel.attributedText = NSMutableAttributedString("")
        categoryColorCircle.backgroundColor = .clear
    }

    // MARK: Cell constraints
    private func configureConstraints() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(categoryColorCircle)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: categoryColorCircle.leadingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            categoryColorCircle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryColorCircle.heightAnchor.constraint(equalToConstant: 24),
            categoryColorCircle.widthAnchor.constraint(equalToConstant: 24),
            categoryColorCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        ])
    }

    // MARK: Configure cell method
    func configureCell(text: String, isCompleted: Bool, category: Category?) {
        let attr: [NSAttributedString.Key: Any]
        if isCompleted {
            attr = [
                .foregroundColor: ColorTheme.Label.labelTertiary.uiColor,
                .strikethroughStyle: NSUnderlineStyle.thick.rawValue
            ]
        } else {
            attr = [
                .foregroundColor: ColorTheme.Label.labelPrimary.uiColor
            ]
        }

        descriptionLabel.attributedText = NSAttributedString(string: text, attributes: attr)

        if let category = category {
            categoryColorCircle.backgroundColor = UIColor(Color(hex: category.hexColor) ?? Color.clear)
        }

    }
}

#Preview {
    let cell = VerticalCalendarViewCell()
    cell.configureCell(
        text: "СТрокаfadadasdaСТрокаfadadasdaСТрокаfadadasdaСТрокаfadadasda",
        isCompleted: true,
        category: .new
    )
    return cell
}
