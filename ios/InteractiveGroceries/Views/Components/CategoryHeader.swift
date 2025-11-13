import SwiftUI

struct CategoryHeader: View {
    let category: ShoppingItem.Category

    var body: some View {
        HStack(spacing: 12) {
            Text(category.emoji)
            Text(category.rawValue)
                .font(.system(.headline, design: .rounded))
        }
        .padding(.vertical, 4)
    }
}
