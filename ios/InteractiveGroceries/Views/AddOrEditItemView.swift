import SwiftUI

struct AddOrEditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ShoppingListViewModel

    @State private var name: String = ""
    @State private var quantity: String = "1"
    @State private var category: ShoppingItem.Category = .groceries
    @State private var priority: ShoppingItem.Priority = .medium
    @State private var notes: String = ""

    var itemToEdit: ShoppingItem?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("פרטי הפריט")) {
                    TextField("שם הפריט", text: $name)
                        .textInputAutocapitalization(.words)

                    TextField("כמות", text: $quantity)
                        .keyboardType(.numbersAndPunctuation)

                    Picker("קטגוריה", selection: $category) {
                        ForEach(ShoppingItem.Category.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }

                    Picker("עדיפות", selection: $priority) {
                        ForEach(ShoppingItem.Priority.allCases) { priority in
                            Text(priority.title).tag(priority)
                        }
                    }
                }

                Section(header: Text("הערות")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle(itemToEdit == nil ? "פריט חדש" : "עריכת פריט")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("ביטול") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(itemToEdit == nil ? "הוסף" : "שמירה") {
                        save()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear(perform: populateFromItem)
        }
    }

    private func populateFromItem() {
        guard let item = itemToEdit else { return }
        name = item.name
        quantity = item.quantity
        category = item.category
        priority = item.priority
        notes = item.notes
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        if var editing = itemToEdit {
            editing.name = trimmedName
            editing.quantity = quantity
            editing.category = category
            editing.priority = priority
            editing.notes = notes
            viewModel.update(item: editing)
            HapticsManager.playImpact()
        } else {
            let newItem = ShoppingItem(name: trimmedName, quantity: quantity, category: category, priority: priority, notes: notes)
            viewModel.addItem(newItem)
            HapticsManager.playImpact()
        }

        dismiss()
    }
}
