//
//  CalendarViewController.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import UIKit

final class CalendarViewController: UIViewController {
    
    //MARK: Private Properties
    private let viewModel: CalendarViewModel
    
    //MARK: Private view properties
    private lazy var horizontalCalendar: HorizontalCalendarView = {
        HorizontalCalendarView()
    }()
    
    private lazy var verticalCalendar: VerticalCalendarView = {
        VerticalCalendarView()
    }()
    
    //MARK: Initializer
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorTheme.Back.backIOSPrimary.uiColor
        configureConstraints()
    }
    
    //MARK: Constraints configuration
    private func configureConstraints() {
        [horizontalCalendar, verticalCalendar].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            horizontalCalendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            horizontalCalendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            horizontalCalendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            horizontalCalendar.heightAnchor.constraint(equalToConstant: 100),
            
            verticalCalendar.topAnchor.constraint(equalTo: horizontalCalendar.bottomAnchor),
            verticalCalendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            verticalCalendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            verticalCalendar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        horizontalCalendar.configure(with: [
            Date.now,
            Date.tommorow,
            Date.tommorow.addingTimeInterval(60*60*24),
            Date.tommorow.addingTimeInterval(60*60*24*2),
            nil])
        
        verticalCalendar.configure(with: [
            (Date.now, [TodoItem.new()]),
            (Date.tommorow, [TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new()]),
            (Date.tommorow.addingTimeInterval(60*60*24), [TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new()]),
            (Date.tommorow.addingTimeInterval(60*60*24*2), [TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new()]),
            (nil, [TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new(), TodoItem.new()])])
    }
}



#Preview {
    let vc = CalendarViewController(viewModel: CalendarViewModel())
    
    return vc
}
