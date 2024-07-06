//
//  CalendarViewController.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import SwiftUI

protocol HorizontalCalendarDelegate: AnyObject {
    func scrollToDate(at section: Int)
}

protocol VerticalCalendarDelegate: AnyObject {
    func selectDate(at index: Int)
    
    func presentDetailView(item: TodoItem, with indexPath: IndexPath)
}

final class CalendarViewController: UIViewController {
    
    //MARK: Private Properties
    private let viewModel: CalendarViewModel
    
    weak var delegate: CoordinatorDelegate?
    
    //MARK: Private view properties
    private lazy var horizontalCalendar: HorizontalCalendarView = {
        let vc = HorizontalCalendarView()
        vc.delegate = self
        
        return vc
    }()
    
    private lazy var verticalCalendar: VerticalCalendarView = {
        let vc = VerticalCalendarView()
        vc.delegate = self
        vc.complitionTaskDelegate = delegate
        
        return vc
    }()
    
    private lazy var addPlusButton: UIHostingController<AddNewItemButton> = {
        let vc = UIHostingController(rootView: AddNewItemButton(action: actionBtnTap))
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        vc.view.layer.cornerRadius = 22
        
        return vc
    }()

    
    private func actionBtnTap() {
        guard let delegate = self.delegate else { return }
        let viewModel = TodoDetailViewModel(todoItem: TodoItem.new(), collectionManager: delegate)
        let view = TodoDetailView(viewModel: viewModel, categoryViewModel: self.viewModel.categoryViewModel)

        navigationController?.present(
            UIHostingController(
                rootView: view
            ),
            animated: true
        )
    }
    
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
        
        self.addChild(addPlusButton)
        view.addSubview(addPlusButton.view)
        addPlusButton.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            horizontalCalendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            horizontalCalendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            horizontalCalendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            horizontalCalendar.heightAnchor.constraint(equalToConstant: 100),
            
            verticalCalendar.topAnchor.constraint(equalTo: horizontalCalendar.bottomAnchor),
            verticalCalendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            verticalCalendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            verticalCalendar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addPlusButton.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addPlusButton.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func updateUI(items: [TodoItem], categories: [Category]) {

        viewModel.update(items: items)
        horizontalCalendar.configure(with: viewModel.dates)
        verticalCalendar.configure(with: viewModel.items, categories: categories)
    }
}

extension CalendarViewController: HorizontalCalendarDelegate {
    func selectDate(at section: Int) {
        horizontalCalendar.selectItem(at: section)
    }
}

extension CalendarViewController: VerticalCalendarDelegate {
    func presentDetailView(item: TodoItem, with indexPath: IndexPath) {
        guard let delegate = self.delegate else {
            return
        }
        
        let viewModel = TodoDetailViewModel(todoItem: item, collectionManager: delegate)
        let view = TodoDetailView(viewModel: viewModel, categoryViewModel: self.viewModel.categoryViewModel)

        navigationController?.present(
            UIHostingController(
                rootView: view
            ),
            animated: true
        ) {[weak self] in
            guard let self else { return }
            self.verticalCalendar.deselectRow(at: indexPath)
        }
    }
    
    func scrollToDate(at section: Int) {
        verticalCalendar.scrollToSection(at: section)
    }
}


#Preview {
    let vc = CalendarViewController(viewModel: CalendarViewModel(categoryViewModel: CategoryViewModel(fileManagerJson: FileManagerJson())))
    
    return vc
}
