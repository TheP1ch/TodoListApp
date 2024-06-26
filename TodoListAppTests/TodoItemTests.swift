//
//  TodoListAppTests.swift
//  TodoListAppTests
//
//  Created by Евгений Беляков on 17.06.2024.
//

import XCTest
@testable import TodoListApp

final class TodoItemTests: XCTestCase {
    
    var todoItem: TodoItem!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        todoItem = TodoItem(id: "test1", text: "description", priority: .low, deadline: Date(timeIntervalSince1970: 10000), isCompleted: true, creationDate: Date(timeIntervalSince1970: 100), lastChangingDate: Date(timeIntervalSince1970: 500))
    }

    //MARK: test init
    func testInitializationWithAllParameters() {
        XCTAssertEqual(todoItem.id, "test1")
        XCTAssertEqual(todoItem.text, "description")
        XCTAssertEqual(todoItem.priority, .low)
        XCTAssertEqual(todoItem.deadline, Date(timeIntervalSince1970: 10000))
        XCTAssertEqual(todoItem.isCompleted, true)
        XCTAssertEqual(todoItem.creationDate, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.lastChangingDate, Date(timeIntervalSince1970: 500))
    }
    
    func testInitializationWithoutRequiredParameters() {
        let todoItem = TodoItem(text: "Привет ШМР!", priority: .normal, isCompleted: false, creationDate: Date(timeIntervalSince1970: 399))
        XCTAssertNotNil(todoItem.id)
        XCTAssertNil(todoItem.deadline)
        XCTAssertNil(todoItem.lastChangingDate)
        XCTAssertEqual(todoItem.priority, .normal)
        XCTAssertEqual(todoItem.text, "Привет ШМР!")
        XCTAssertEqual(todoItem.isCompleted, false)
        XCTAssertEqual(todoItem.creationDate, Date(timeIntervalSince1970: 399))
    }
    
    //MARK: test convert object to json
    func testJsonPropertyWithAllProperties() {
        let json: [String: Any] = todoItem.json as! [String: Any]
        
        XCTAssertEqual(json[TodoItemKeys.id.rawValue] as? String, "test1")
        XCTAssertEqual(json[TodoItemKeys.text.rawValue] as? String, "description")
        XCTAssertEqual(json[TodoItemKeys.priority.rawValue] as? String, "неважная")
        XCTAssertEqual(json[TodoItemKeys.isCompleted.rawValue] as? Bool, true)
        XCTAssertEqual(json[TodoItemKeys.creationDate.rawValue] as? Int, 100)
        XCTAssertEqual(json[TodoItemKeys.lastChangingDate.rawValue] as? Int, 500)
    }
    // MARK: Проверка json без deadline и lastChangingDate, важность - обычная
    func testJsonPropertyWithoutNotRequiredPropertiesPriorityNormal() {
        let todoItem = TodoItem(text: "Привет ШМР!", priority: .normal, isCompleted: false, creationDate: Date(timeIntervalSince1970: 399))
        
        let json: [String: Any] = todoItem.json as! [String: Any]
        
        XCTAssertEqual(json[TodoItemKeys.id.rawValue] as? String, todoItem.id)
        XCTAssertEqual(json[TodoItemKeys.text.rawValue] as? String, todoItem.text)
        XCTAssertNil(json[TodoItemKeys.priority.rawValue], "Обычный приоритет не должен быть указан в json")
        XCTAssertEqual(json[TodoItemKeys.isCompleted.rawValue] as? Bool, false)
        XCTAssertEqual(json[TodoItemKeys.creationDate.rawValue] as? Int, 399)
        XCTAssertNil(json[TodoItemKeys.lastChangingDate.rawValue])
        XCTAssertNil(json[TodoItemKeys.deadline.rawValue])
    }
    
    //MARK: Test parse function
    
    func testParseJsonWithoutPriority() {
        let json: [String: Any] = [
            "id": "test",
            "text": "description",
            "isCompleted": false,
            "creationDate": 500,
            "deadline": 399,
            "lastChangingDate": 199
        ]
        
        let todoItem = TodoItem.parse(json: json)
        
        XCTAssertNotNil(todoItem)
        
        XCTAssertEqual(todoItem?.id, "test")
        XCTAssertEqual(todoItem?.text, "description")
        XCTAssertEqual(todoItem?.isCompleted, false)
        XCTAssertEqual(todoItem?.creationDate, Date(timeIntervalSince1970: 500))
        XCTAssertEqual(todoItem?.deadline, Date(timeIntervalSince1970: 399))
        XCTAssertEqual(todoItem?.lastChangingDate, Date(timeIntervalSince1970: 199))
        XCTAssertEqual(todoItem?.priority, .normal)
    }
    
    func testJsonParseReturnNil() {
        let json: [String: Any] = [:]
        
        let todoItem = TodoItem.parse(json: json)
        
        XCTAssertNil(todoItem)
    }
    
    func testJsonParseWithoutNotRequiredProperties() {
        let json: [String: Any] = [
            "id": "test",
            "text": "hi",
            "isCompleted": true,
            "priority": "важная",
            "creationDate": 500
        ]
        
        let todoItem = TodoItem.parse(json: json)
        
        XCTAssertNotNil(todoItem)
        
        XCTAssertEqual(todoItem?.id, "test")
        XCTAssertEqual(todoItem?.text, "hi")
        XCTAssertEqual(todoItem?.isCompleted, true)
        XCTAssertEqual(todoItem?.creationDate, Date(timeIntervalSince1970: 500))
        XCTAssertNil(todoItem?.deadline)
        XCTAssertNil(todoItem?.lastChangingDate)
        
        XCTAssertEqual(todoItem?.priority, .important)
    }
    
    //MARK: Test parse function
    
    func testParseCSVWithNormalPriority() {
        let todoItem = TodoItem(id: "test1", text: "description", priority: .normal, deadline: Date(timeIntervalSince1970: 10000), isCompleted: true, creationDate: Date(timeIntervalSince1970: 100), lastChangingDate: Date(timeIntervalSince1970: 500))
        let parsedCsv = TodoItem.parse(csv: todoItem.csv
        )
        
        XCTAssertNotNil(todoItem)
        
        XCTAssertEqual(todoItem.id, parsedCsv?.id)
        XCTAssertEqual(todoItem.text, parsedCsv?.text)
        XCTAssertEqual(todoItem.isCompleted, parsedCsv?.isCompleted)
        XCTAssertEqual(todoItem.creationDate, parsedCsv?.creationDate)
        XCTAssertEqual(todoItem.deadline, parsedCsv?.deadline)
        XCTAssertEqual(todoItem.lastChangingDate, parsedCsv?.lastChangingDate)
        XCTAssertEqual(todoItem.priority, parsedCsv?.priority)
    }
    
    func testCSVParseReturnNil() {
        let csv: String = ""
        
        let todoItem = TodoItem.parse(csv: csv)
        
        XCTAssertNil(todoItem)
    }
    
    func testCSVParseWithoutNotRequiredProperties() {
        let todoItem = TodoItem(text: "test", priority: .important, isCompleted: true, creationDate: Date(timeIntervalSince1970: 500))
        
        let csvParsed = TodoItem.parse(csv: todoItem.csv)
        
        XCTAssertNotNil(todoItem)
        
        XCTAssertNotNil(csvParsed?.id)
        XCTAssertEqual(csvParsed?.id, todoItem.id)
        XCTAssertEqual(todoItem.text, csvParsed?.text)
        XCTAssertEqual(todoItem.isCompleted, csvParsed?.isCompleted)
        XCTAssertEqual(todoItem.creationDate, csvParsed?.creationDate)
        XCTAssertNil(csvParsed?.deadline)
        XCTAssertNil(csvParsed?.lastChangingDate)
        
        XCTAssertEqual(csvParsed?.priority, todoItem.priority)
    }
}
