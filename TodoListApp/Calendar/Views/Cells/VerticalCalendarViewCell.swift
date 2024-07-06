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
        
        descriptionLabel.attributedText = NSMutableAttributedString("")
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
    }
}

#Preview {
    let cell = VerticalCalendarViewCell()
    cell.configureCell(text: "СТрока", isCompleted: true)
    return cell
}


