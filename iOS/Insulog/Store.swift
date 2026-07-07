import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [InsulationEntryEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Kept comfortably above seed count so a fresh install
    /// never hits the paywall immediately.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("insulog_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: InsulationEntryEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: InsulationEntryEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: InsulationEntryEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([InsulationEntryEntry].self, from: data) else {
            seed()
            return
        }
        entries = decoded
    }

    private func seed() {
        entries = [
            InsulationEntryEntry(title: "Sample InsulationEntry 1", rating: 3, area: "Sample", insulationType: "Sample", rValue: "Sample", dateInstalled: Date()),
            InsulationEntryEntry(title: "Sample InsulationEntry 2", rating: 4, area: "Sample", insulationType: "Sample", rValue: "Sample", dateInstalled: Date()),
            InsulationEntryEntry(title: "Sample InsulationEntry 3", rating: 5, area: "Sample", insulationType: "Sample", rValue: "Sample", dateInstalled: Date())
        ]
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
