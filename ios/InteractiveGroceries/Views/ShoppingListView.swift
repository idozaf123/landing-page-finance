import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    @State private var showAddSheet = false
    @State private var editingItem: ShoppingItem?
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            header
            listContent
        }
        .background(appState.selectedTheme.backgroundColor.ignoresSafeArea())
        .navigationTitle("רשימת קניות")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddSheet = true
                } label: {
                    Label("פריט חדש", systemImage: "plus.circle.fill")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Menu {
                    Picker("מיין לפי", selection: $viewModel.sortOption) {
                        ForEach(ShoppingListViewModel.SortOption.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }

                    Picker("סנן קטגוריה", selection: Binding(get: {
                        viewModel.filterCategory ?? ShoppingItem.Category.other
                    }, set: { newValue in
                        viewModel.filterCategory = newValue == .other ? nil : newValue
                    })) {
                        Text("הכל").tag(ShoppingItem.Category.other)
                        ForEach(ShoppingItem.Category.allCases.filter { $0 != .other }) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }

                    Button("נתוני הדגמה") {
                        viewModel.importSampleData()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddOrEditItemView(viewModel: viewModel)
        }
        .sheet(item: $editingItem, onDismiss: { editingItem = nil }) { item in
            AddOrEditItemView(viewModel: viewModel, itemToEdit: item)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("היי! בואו נתכנן קנייה חכמה")
                .font(.system(.title2, design: .rounded, weight: .semibold))
            Text("נהלו את הרשימה בזמן אמת, חלקו עם בני משפחה וקבלו תובנות על ההוצאות")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)

            SearchBar(text: $viewModel.searchQuery)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 12)
        )
        .padding([.horizontal, .top])
    }

    private var listContent: some View {
        List {
            if viewModel.filteredItems().isEmpty {
                emptyState
            } else {
                ForEach(groupedItems.keys.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { category in
                    if let items = groupedItems[category] {
                        Section(header: CategoryHeader(category: category)) {
                            ForEach(items) { item in
                                ShoppingItemRow(item: item) {
                                    HapticsManager.playSuccess()
                                    viewModel.toggleCompletion(for: item)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        delete(item: item)
                                    } label: {
                                        Label("מחק", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        editingItem = item
                                    } label: {
                                        Label("ערוך", systemImage: "square.and.pencil")
                                    }
                                    .tint(.indigo)
                                }
                                .listRowBackground(Color.clear)
                            }
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }

    private var groupedItems: [ShoppingItem.Category: [ShoppingItem]] {
        Dictionary(grouping: viewModel.filteredItems(), by: \.category)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("הרשימה שלכם ריקה")
                .font(.title3.bold())
            Text("לחצו על הכפתור למעלה כדי להוסיף את הפריטים הראשונים שלכם")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .listRowBackground(Color.clear)
    }

    private func delete(item: ShoppingItem) {
        if let index = viewModel.items.firstIndex(of: item) {
            viewModel.deleteCurrent(at: IndexSet(integer: index))
        }
    }
}
