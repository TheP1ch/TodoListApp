//
//  VerticalCalendarViewCell.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import UIKit

final class VerticalCalendarViewCell: UITableViewCell {
    static let cellId = "VerticalCalendarViewCell"
    
    //MARK: view properties
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTheme.Label.labelPrimary.uiColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        
        return label
    }()
    
    
    //MARK: Initialization
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
        
        descriptionLabel.text = ""
        descriptionLabel.strikeThrough(false)
    }
    
    //MARK: Cell constraints
    private func configureConstraints() {
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    //MARK: Configure cell method
    func configureCell(text: String, isCompleted: Bool) {
        descriptionLabel.text = text
        descriptionLabel.strikeThrough(isCompleted)
    }
}

#Preview {
    let cell = VerticalCalendarViewCell()
    cell.configureCell(text: "СТрока", isCompleted: true)
    return cell
}


