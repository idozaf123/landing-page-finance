import Foundation

struct ShoppingListPersistence {
    private let fileURL: URL
    private let archiveURL: URL
    private let queue = DispatchQueue(label: "shopping-list-persistence")

    init(fileManager: FileManager = .default) {
        let directory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first ?? fileManager.temporaryDirectory
        let appDirectory = directory.appendingPathComponent("InteractiveGroceries", isDirectory: true)
        if !fileManager.fileExists(atPath: appDirectory.path) {
            try? fileManager.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        }
        fileURL = appDirectory.appendingPathComponent("shopping-list.json")
        archiveURL = appDirectory.appendingPathComponent("shopping-archive.json")
    }

    func load() -> (current: [ShoppingItem], archived: [ShoppingItem]) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let currentItems = (try? Data(contentsOf: fileURL)).flatMap { data in
            try? decoder.decode([ShoppingItem].self, from: data)
        } ?? []

        let archivedItems = (try? Data(contentsOf: archiveURL)).flatMap { data in
            try? decoder.decode([ShoppingItem].self, from: data)
        } ?? []

        return (currentItems, archivedItems)
    }

    func save(current: [ShoppingItem], archived: [ShoppingItem]) {
        queue.async { [fileURL, archiveURL] in
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601

            if let currentData = try? encoder.encode(current) {
                try? currentData.write(to: fileURL, options: .atomic)
            }

            if let archivedData = try? encoder.encode(archived) {
                try? archivedData.write(to: archiveURL, options: .atomic)
            }
        }
    }
}
