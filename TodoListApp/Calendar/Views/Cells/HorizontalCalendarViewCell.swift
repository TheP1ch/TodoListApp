//
//  HorizontalCalendarViewCell.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import UIKit

final class HorizontalCalendarViewCell: UICollectionViewCell {
    static let cellId = "HorizontalCalendarViewCell"

    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectCell()
            } else {
                deselectCell()
            }
        }
    }

    // MARK: view properties
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTheme.Label.labelTertiary.uiColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = AppFont.subheadBold.uiFont
        label.textAlignment = .center

        return label
    }()

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureConstraints()

        contentView.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        dateLabel.text = ""
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = nil
    }

    // MARK: Cell constraints
    private func configureConstraints() {
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: Configure cell method
    func configureCell(date: Date?) {
        let labelText = if let date {
            date.toString().split(separator: " ").joined(separator: "\n")
        } else {
            "Другое"
        }

        dateLabel.text = labelText
    }

    // MARK: selected cell style
    func selectCell() {
        contentView.backgroundColor = ColorTheme.Support.calendarBack.uiColor
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = ColorTheme.ColorPalette.gray.uiColor.cgColor
    }

    func deselectCell() {
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = nil
    }
}

#Preview {
    let cell = HorizontalCalendarViewCell()
    cell.configureCell(date: nil)
    cell.selectCell()
    return cell
}
