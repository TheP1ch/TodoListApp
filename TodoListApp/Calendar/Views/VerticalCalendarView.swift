//
//  VerticalCalendarView.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import UIKit

final class VerticalCalendarView: UIView {
    
    weak var delegate: VerticalCalendarDelegate?
    
    weak var complitionTaskDelegate: TaskComplitionDelegate?
    
    private var items: [(date: Date?, items: [TodoItem])] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(
            VerticalCalendarViewCell.self,
            forCellReuseIdentifier: VerticalCalendarViewCell.cellId
        )
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        return tableView
    }()

    //MARK: initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = ColorTheme.Back.backPrimary.uiColor
        
        configureTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: constraints configuration method
    private func configureConstraints() {
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    //MARK: tableView configuration method
    private func configureTable() {
        tableView.backgroundColor = ColorTheme.Back.backPrimary.uiColor
        tableView.sectionHeaderTopPadding = 0
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(VerticalCalendarViewCell.self, forCellReuseIdentifier: VerticalCalendarViewCell.cellId)
        
        configureConstraints()
    }
    
    //MARK: configure method
    func configure(with deadlineItems: [(Date?, [TodoItem])]){
        items = deadlineItems

        tableView.reloadData()
    }
}

//MARK: TableView dataSource methods
extension VerticalCalendarView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: VerticalCalendarViewCell.cellId,
            for: indexPath
        ) as? VerticalCalendarViewCell else {
            fatalError()
        }
        
        cell.configureCell(
            text: items[indexPath.section].items[indexPath.row].text,
            isCompleted: items[indexPath.section].items[indexPath.row].isCompleted
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        items[section].date?.toString() ?? "Другое"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .normal,
            title: ""
        ) { [weak self] (action, view, completionHandler) in
            guard let self else { return }
            
            let item = self.items[indexPath.section].items[indexPath.row]
            
            complitionTaskDelegate?.complete(item: item)
            
            completionHandler(true)
        }
        
        action.image = UIImage(systemName: "checkmark.circle.fill")
        action.backgroundColor = ColorTheme.ColorPalette.green.uiColor
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .normal,
            title: ""
        ) { [weak self] (action, view, completionHandler) in
            guard let self else { return }
            
            let item = self.items[indexPath.section].items[indexPath.row]
            
            complitionTaskDelegate?.uncomplete(item: item)
            
            completionHandler(true)
        }
        
        action.image = UIImage(systemName: "checkmark.gobackward")
        action.backgroundColor = ColorTheme.ColorPalette.green.uiColor
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

//MARK: TableView delegate methods
extension VerticalCalendarView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging || scrollView.isTracking || scrollView.isDecelerating {
            guard let firstSection = tableView.indexPathsForVisibleRows?.first else { return }
            
            delegate?.selectDate(at: firstSection.section)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section].items[indexPath.row]
        
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = ColorTheme.ColorPalette.grayLight.uiColor
        
        delegate?.presentDetailView(item: item, with: indexPath)
    }
    
    func deselectRow(at indexPath: IndexPath){
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = ColorTheme.Back.backSecondary.uiColor
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: integrate with horizontalCalendar methods
extension VerticalCalendarView {
    func scrollToSection(at section: Int){
        let indexPath = IndexPath(row: 0, section: section)
        
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}


#Preview {
    let view = VerticalCalendarView()
    view.configure(with: [
        (Date.now, [TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new()]),
        (Date.tommorow, [TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new()]),
        (Date.tommorow.addingTimeInterval(60*60*24), [TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new()]),
        (Date.tommorow.addingTimeInterval(60*60*24*2), [TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new()]),
        (nil, [TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new()])
    ])
    
    return view
}
