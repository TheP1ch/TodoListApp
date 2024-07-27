//
//  TodoListViewModel.swift
//  TodoListApp
//
//  Created by Евгений Беляков on 29.06.2024.
//

import Combine
import Foundation
import SwiftData

protocol CollectionManaging: AnyObject {
    func add(item: TodoItem)
    func update(item: TodoItem)
    func remove(by id: String)
}

final class TodoListViewModel: ObservableObject, CollectionManaging {
    // MARK: public properties
    @Published var hasUnCompletedNetwork: Bool = false

    @Published var filterOption: FilterOption = .hideDone {
        didSet {
            Logger.log("Items will be filtered by option: \(filterOption)", level: .debug)
        }
    }

    @Published var sortOption: SortOption = .createdAt {
        didSet {
            Logger.log("Items will be sorted by option: \(sortOption)", level: .debug)
        }
    }

    private(set) var isDoneCount: Int = 0

    init() {
        do {
            let container = try ModelContainer.init(for: TodoItemModel.self)

            self.storageHelper = TodoListStorageHelper(container: container)
            Logger.log("Initialize TodoListViewModel", level: .debug)
        } catch {
            Logger.log("Fail initializing SwiftData Context", level: .error)
            fatalError()
        }

        bind()
    }

    // MARK: private properties

    @Published private(set) var items: [TodoItem] = []

    private let networkHelper: TodoNetworkingHelper = TodoListNetworkingHelper()

    private let storageHelper: TodoStorageHelper

    private let fileCache: FileManaging = FileCache()

    private let fileName: String = FileCache.fileName

    private let format: FileFormat = FileCache.fileExtension

    var subscribers: [AnyCancellable] = []
}

// MARK: Networking
extension TodoListViewModel {

    private func bind() {
        $sortOption.combineLatest($filterOption).sink { sort, filter in
            Task {[weak self] in
                guard let self else { return }

                await fetchFilteredItems(filter, sort)
            }
        }.store(in: &subscribers)

        Task {
            await networkHelper.isItemUpdate.sink { _ in
                Task {[weak self] in
                    guard let self else { return }

                    let helperItems = await networkHelper.todoItems
                    await storageHelper.updateAll(helperItems)

                    await fetchFilteredItems(filterOption, sortOption)
                }

            }.store(in: &subscribers)

            await networkHelper.hasRunningNetworkCall
                .receive(on: DispatchQueue.main)
                .assign(to: \.hasUnCompletedNetwork, on: self)
                .store(in: &subscribers)
        }
    }

    func load() {
        let fetchStored = Task {
            await storageHelper.fetch()
            await updateStorageItems()
        }

        Task {
            await networkHelper.fetchTodoList()

            fetchStored.cancel()

            Logger.log("Network data load (fetch request)", level: .debug)
        }
    }

    func isCompletedChange(for item: TodoItem, newValue: Bool) {
        let item = TodoItem(
            id: item.id,
            text: item.text,
            priority: item.priority,
            deadline: item.deadline,
            isCompleted: newValue,
            createdAt: item.createdAt,
            changeAt: Date.now,
            hexColor: item.hexColor,
            category: item.category
        )

        Task {
            await withDiscardingTaskGroup { [weak self] group in
                guard let self else { return }

                group.addTask {
                    await self.networkHelper.updateTodoItem(with: item.id, item)
                }

                group.addTask {
                    await self.storageHelper.update(item)
                }
            }

            Logger.log(
                "isCompleted change to \(newValue.description) for TodoItem with text:'\(item.text)'",
                level: .debug
            )

            await fetchFilteredItems()
        }
    }

    func update(item: TodoItem) {
        Task {
            await withDiscardingTaskGroup { [weak self] group in
                guard let self else { return }

                group.addTask {
                    await self.networkHelper.updateTodoItem(with: item.id, item)
                }

                group.addTask {
                    await self.storageHelper.update(item)
                }
            }

            Logger.log("TodoItem with id: '\(item.id)' updated", level: .debug)

            await fetchFilteredItems()
        }
    }

    func add(item: TodoItem) {
        Task {
            await withDiscardingTaskGroup { [weak self] group in
                guard let self else { return }

                group.addTask {
                    await self.networkHelper.addTodoItem(item)
                }

                group.addTask {
                    await self.storageHelper.insert(item)
                }
            }

            Logger.log("TodoItem with id: '\(item.id)' added", level: .debug)

            await fetchFilteredItems()
        }
    }

    func remove(by id: String) {
        Task {
            await withDiscardingTaskGroup { [weak self] group in
                guard let self else { return }

                group.addTask {
                    await self.networkHelper.deleteTodoItem(with: id)
                }

                group.addTask {
                    let item = self.items.first { $0.id == id }

                    guard let item else { return }

                    await self.storageHelper.delete(item)
                }
            }

            Logger.log("TodoItem with id: '\(id)' removed", level: .debug)

            await fetchFilteredItems()
        }
    }

    private func updateStorageItems() async {
        let storageItems = await storageHelper.items

        Logger.log("Download storageItems by StorageItems", level: .debug)

        await networkHelper.updateItems(storageItems)

        await fetchFilteredItems()
    }

    private func fetchFilteredItems(_ filterOption: FilterOption? = nil, _ sortOption: SortOption? = nil) async {
        Task {
            let filterOption = filterOption ?? self.filterOption
            let sortOption = sortOption ?? self.sortOption
            let filteredItems = await storageHelper.filteredFetch(filterOption: filterOption, sortOption: sortOption)
            let isDoneCount = await storageHelper.isDoneCount()

            await MainActor.run {
                self.items = filteredItems
                self.isDoneCount = isDoneCount
            }
        }
    }
}
