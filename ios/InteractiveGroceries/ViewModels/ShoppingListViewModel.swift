import Foundation
import Combine

final class ShoppingListViewModel: ObservableObject {
    @Published private(set) var items: [ShoppingItem] = []
    @Published private(set) var archivedItems: [ShoppingItem] = []
    @Published var searchQuery: String = ""
    @Published var filterCategory: ShoppingItem.Category? = nil
    @Published var sortOption: SortOption = .priority

    private var cancellables = Set<AnyCancellable>()
    private let persistence = ShoppingListPersistence()

    enum SortOption: String, CaseIterable, Identifiable {
        case priority
        case alphabetical
        case recent

        var id: String { rawValue }

        var title: String {
            switch self {
            case .priority: return "עדיפות"
            case .alphabetical: return "אלפביתי"
            case .recent: return "נוסף לאחרונה"
            }
        }
    }

    init() {
        load()
        Publishers.CombineLatest($searchQuery.removeDuplicates(), $sortOption)
            .debounce(for: .milliseconds(150), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func load() {
        let result = persistence.load()
        items = result.current
        archivedItems = result.archived
    }

    func addItem(_ item: ShoppingItem) {
        items.append(item)
        persist()
    }

    func toggleCompletion(for item: ShoppingItem) {
        guard let index = items.firstIndex(of: item) else { return }
        items[index].isCompleted.toggle()
        items[index].dateCompleted = items[index].isCompleted ? Date() : nil

        if items[index].isCompleted {
            archivedItems.insert(items.remove(at: index), at: 0)
        }

        persist()
    }

    func update(item: ShoppingItem) {
        if let currentIndex = items.firstIndex(where: { $0.id == item.id }) {
            items[currentIndex] = item
        } else if let archivedIndex = archivedItems.firstIndex(where: { $0.id == item.id }) {
            archivedItems[archivedIndex] = item
        }
        persist()
    }

    func restore(_ item: ShoppingItem) {
        guard let index = archivedItems.firstIndex(of: item) else { return }
        var restored = archivedItems.remove(at: index)
        restored.isCompleted = false
        restored.dateCompleted = nil
        items.insert(restored, at: 0)
        persist()
    }

    func deleteCurrent(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        persist()
    }

    func deleteArchived(at offsets: IndexSet) {
        archivedItems.remove(atOffsets: offsets)
        persist()
    }

    func filteredItems() -> [ShoppingItem] {
        let base = items.filter { !$0.isCompleted }
        let filtered = base.filter { item in
            (filterCategory == nil || item.category == filterCategory) &&
            (searchQuery.isEmpty || item.name.localizedCaseInsensitiveContains(searchQuery) || item.notes.localizedCaseInsensitiveContains(searchQuery))
        }

        return sort(items: filtered)
    }

    func sort(items: [ShoppingItem]) -> [ShoppingItem] {
        switch sortOption {
        case .priority:
            return items.sorted { lhs, rhs in
                if lhs.priority == rhs.priority {
                    return lhs.dateAdded > rhs.dateAdded
                }
                return lhs.priority.weight > rhs.priority.weight
            }
        case .alphabetical:
            return items.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        case .recent:
            return items.sorted { $0.dateAdded > $1.dateAdded }
        }
    }

    func clearHistory() {
        archivedItems.removeAll()
        persist()
    }

    func importSampleData() {
        let samples = SampleData.sampleItems
        items = samples.filter { !$0.isCompleted }
        archivedItems = samples.filter { $0.isCompleted }
        persist()
    }

    private func persist() {
        persistence.save(current: items, archived: archivedItems)
    }
}

private extension ShoppingItem.Priority {
    var weight: Int {
        switch self {
        case .high: return 3
        case .medium: return 2
        case .low: return 1
        }
    }
}
