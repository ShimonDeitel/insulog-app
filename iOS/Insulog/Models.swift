import Foundation

struct InsulationEntryEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var rating: Int = 3
    var dateAdded: Date = Date()
    var area: String
    var insulationType: String
    var rValue: String
    var dateInstalled: Date

    init(id: UUID = UUID(), title: String, rating: Int = 3, dateAdded: Date = Date(), area: String = "", insulationType: String = "", rValue: String = "", dateInstalled: Date = Date()) {
        self.id = id
        self.title = title
        self.rating = rating
        self.dateAdded = dateAdded
        self.area = area
        self.insulationType = insulationType
        self.rValue = rValue
        self.dateInstalled = dateInstalled
    }
}
