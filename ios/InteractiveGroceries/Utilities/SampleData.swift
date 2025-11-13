import Foundation

enum SampleData {
    static let sampleItems: [ShoppingItem] = [
        ShoppingItem(name: "קפה איכותי", quantity: "1 חבילה", category: .groceries, priority: .high, notes: "100% ערביקה"),
        ShoppingItem(name: "אבוקדו", quantity: "4 יחידות", category: .produce, priority: .medium, notes: "להבשיל בבית"),
        ShoppingItem(name: "חלה טרייה", quantity: "2 יחידות", category: .bakery, priority: .high, notes: "לשבת"),
        ShoppingItem(name: "גבינת עיזים", quantity: "1 קופסה", category: .dairy, priority: .medium),
        ShoppingItem(name: "נייר סופג", quantity: "3 גלילים", category: .household, priority: .low),
        ShoppingItem(name: "ויטמין C", quantity: "1 בקבוק", category: .health, priority: .medium, notes: "לשמור במקרר"),
        ShoppingItem(name: "שוקולד מריר", quantity: "2 חבילות", category: .groceries, priority: .low),
        ShoppingItem(name: "פרחים טריים", quantity: "זר אחד", category: .other, priority: .medium, notes: "לסלון", isCompleted: true, dateCompleted: .now)
    ]
}
