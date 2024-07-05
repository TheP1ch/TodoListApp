//
//  CalendarViewController.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 05.07.2024.
//

import UIKit

class CalendarViewController: UIViewController {
    
    //MARK: Private Properties
    private let viewModel: CalendarViewModel
    
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
        print(viewModel.todoItems)
        view.backgroundColor = ColorTheme.Back.backIOSPrimary.uiColor
    }

}

#Preview {
    let vc = CalendarViewController(viewModel: CalendarViewModel())
    
    return vc
}
