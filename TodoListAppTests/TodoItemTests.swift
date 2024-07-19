//
//  TodoListAppTests.swift
//  TodoListAppTests
//
//  Created by Евгений Беляков on 17.06.2024.
//

@testable import TodoListApp
import XCTest

final class TodoItemTests: XCTestCase {

    var todoItem: TodoItem!

    override func setUpWithError() throws {
        try super.setUpWithError()

        todoItem = TodoItem(
            id: "test1",
            text: "description",
            priority: .low,
            deadline: Date(timeIntervalSince1970: 10000),
            isCompleted: true,
            createdAt: Date(timeIntervalSince1970: 100),
            changeAt: Date(timeIntervalSince1970: 500)
        )
    }

    // MARK: test init
    func testInitializationWithAllParameters() {
        XCTAssertEqual(todoItem.id, "test1")
        XCTAssertEqual(todoItem.text, "description")
        XCTAssertEqual(todoItem.priority, .low)
        XCTAssertEqual(todoItem.deadline, Date(timeIntervalSince1970: 10000))
        XCTAssertEqual(todoItem.isCompleted, true)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 100))
        XCTAssertEqual(todoItem.changeAt, Date(timeIntervalSince1970: 500))
    }

    func testInitializationWithoutRequiredParameters() {
        let todoItem = TodoItem(
            text: "Привет ШМР!",
            priority: .basic,
            isCompleted: false,
            createdAt: Date(timeIntervalSince1970: 399)
        )

        XCTAssertNotNil(todoItem.id)
        XCTAssertNil(todoItem.deadline)
        XCTAssertNil(todoItem.changeAt)
        XCTAssertEqual(todoItem.priority, .basic)
        XCTAssertEqual(todoItem.text, "Привет ШМР!")
        XCTAssertEqual(todoItem.isCompleted, false)
        XCTAssertEqual(todoItem.createdAt, Date(timeIntervalSince1970: 399))
    }

    // MARK: test convert object to json
    func testJsonPropertyWithAllProperties() {
        let json: Any = todoItem.json

        XCTAssertNotNil(json)

        guard let json = json as? [String: Any] else {
            fatalError()
        }

        XCTAssertEqual(json[TodoItem.CodingKeys.id.rawValue] as? String, "test1")
        XCTAssertEqual(json[TodoItem.CodingKeys.text.rawValue] as? String, "description")
        XCTAssertEqual(json[TodoItem.CodingKeys.priority.rawValue] as? String, "неважная")
        XCTAssertEqual(json[TodoItem.CodingKeys.isCompleted.rawValue] as? Bool, true)
        XCTAssertEqual(json[TodoItem.CodingKeys.createdAt.rawValue] as? Int, 100)
        XCTAssertEqual(json[TodoItem.CodingKeys.changeAt.rawValue] as? Int, 500)
    }
    // MARK: Проверка json без deadline и lastChangingDate, важность - обычная
    func testJsonPropertyWithoutNotRequiredPropertiesPriorityNormal() {
        let todoItem = TodoItem(
            text: "Привет ШМР!",
            priority: .basic,
            isCompleted: false,
            createdAt: Date(timeIntervalSince1970: 399)
        )

        let json: Any = todoItem.json

        XCTAssertNotNil(json)

        guard let json = json as? [String: Any] else {
            fatalError()
        }

        XCTAssertEqual(json[TodoItem.CodingKeys.id.rawValue] as? String, todoItem.id)
        XCTAssertEqual(json[TodoItem.CodingKeys.text.rawValue] as? String, todoItem.text)
        XCTAssertNil(json[TodoItem.CodingKeys.priority.rawValue], "Обычный приоритет не должен быть указан в json")
        XCTAssertEqual(json[TodoItem.CodingKeys.isCompleted.rawValue] as? Bool, false)
        XCTAssertEqual(json[TodoItem.CodingKeys.createdAt.rawValue] as? Int, 399)
        XCTAssertNil(json[TodoItem.CodingKeys.changeAt.rawValue])
        XCTAssertNil(json[TodoItem.CodingKeys.deadline.rawValue])
    }

    // MARK: Test parse function

    func testParseJsonWithoutPriority() {
        let json: [String: Any] = [
            "id": "test",
            "text": "description",
            "isCompleted": false,
            "createdAt": 500,
            "deadline": 399,
            "changeAt": 199
        ]

        let todoItem = TodoItem.parse(json: json)

        XCTAssertNotNil(todoItem)

        XCTAssertEqual(todoItem!.id, "test")
        XCTAssertEqual(todoItem!.text, "description")
        XCTAssertEqual(todoItem!.isCompleted, false)
        XCTAssertEqual(todoItem!.createdAt, Date(timeIntervalSince1970: 500))
        XCTAssertEqual(todoItem!.deadline, Date(timeIntervalSince1970: 399))
        XCTAssertEqual(todoItem!.changeAt, Date(timeIntervalSince1970: 199))
        XCTAssertEqual(todoItem!.priority, .basic)
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
            "createdAt": 500
        ]

        let todoItem = TodoItem.parse(json: json)

        XCTAssertNotNil(todoItem)

        XCTAssertEqual(todoItem?.id, "test")
        XCTAssertEqual(todoItem?.text, "hi")
        XCTAssertEqual(todoItem?.isCompleted, true)
        XCTAssertEqual(todoItem?.createdAt, Date(timeIntervalSince1970: 500))
        XCTAssertNil(todoItem?.deadline)
        XCTAssertNil(todoItem?.changeAt)

        XCTAssertEqual(todoItem?.priority, .important)
    }

    // MARK: Test parse function

    func testParseCSVWithNormalPriority() {
        let todoItem = TodoItem(
            id: "test1",
            text: "description",
            priority: .basic,
            deadline: Date(
                timeIntervalSince1970: 10000
            ),
            isCompleted: true,
            createdAt: Date(timeIntervalSince1970: 100),
            changeAt: Date(timeIntervalSince1970: 500)
        )

        let parsedCsv = TodoItem.parse(csv: todoItem.csv)

        XCTAssertNotNil(todoItem)

        XCTAssertEqual(todoItem.id, parsedCsv?.id)
        XCTAssertEqual(todoItem.text, parsedCsv?.text)
        XCTAssertEqual(todoItem.isCompleted, parsedCsv?.isCompleted)
        XCTAssertEqual(todoItem.createdAt, parsedCsv?.createdAt)
        XCTAssertEqual(todoItem.deadline, parsedCsv?.deadline)
        XCTAssertEqual(todoItem.changeAt, parsedCsv?.changeAt)
        XCTAssertEqual(todoItem.priority, parsedCsv?.priority)
    }

    func testCSVParseReturnNil() {
        let csv: String = ""

        let todoItem = TodoItem.parse(csv: csv)

        XCTAssertNil(todoItem)
    }

    func testCSVParseWithoutNotRequiredProperties() {
        let todoItem = TodoItem(
            text: "test",
            priority: .important,
            isCompleted: true,
            createdAt: Date(timeIntervalSince1970: 500)
        )

        let csvParsed = TodoItem.parse(csv: todoItem.csv)

        XCTAssertNotNil(todoItem)

        XCTAssertNotNil(csvParsed?.id)
        XCTAssertEqual(csvParsed?.id, todoItem.id)
        XCTAssertEqual(todoItem.text, csvParsed?.text)
        XCTAssertEqual(todoItem.isCompleted, csvParsed?.isCompleted)
        XCTAssertEqual(todoItem.createdAt, csvParsed?.createdAt)
        XCTAssertNil(csvParsed?.deadline)
        XCTAssertNil(csvParsed?.changeAt)

        XCTAssertEqual(csvParsed?.priority, todoItem.priority)
    }
}
