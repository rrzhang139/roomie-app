//
//  GroceryList.swift
//  Roommate App
//
//  Created by Logan Norman on 4/6/23.
//

import SwiftUI

struct GroceryList: View {
    @State private var groceryItems: [GroceryItem] = [
        GroceryItem(name: "Apples", quantity: 3, due_date: Date() + 1, added_by: User(token: UserToken(token: "abc")), status: .InProgress),
        GroceryItem(name: "Bananas", quantity: 2, due_date: Date() + 2, added_by: User(token: UserToken(token: "abc")), status: .InProgress),
        GroceryItem(name: "Milk", quantity: 1, due_date: Date() + 3, added_by: User(token: UserToken(token: "abc")), status: .Complete)
    ]
    
    var body: some View {
        VStack {
            Text("Grocery List")
                .font(.system(size: 36, weight: .semibold))
            
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVStack {
                        ForEach(groceryItems) { item in
                            CardView {
                                GroceryItemRow(item: item)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .navigationBarTitleDisplayMode(.inline)
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: addItem) {
                        Image(systemName: "plus")
                            .frame(width: 50, height: 40)
                            .font(.system(size: 25))
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        EmptyView()
                    }
                }
            }
        }
    }
    
    func addItem() {
        
    }
    
    func deleteItems(at offsets: IndexSet) {
        groceryItems.remove(atOffsets: offsets)
    }
}

struct CardView<Content: View>: View {
    let content: () -> Content
    var body: some View {
        VStack {
            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
}

struct GroceryItemRow: View {
    let item: GroceryItem
    @State var completed = false
    
    var body: some View {
        HStack {
            Button(action: { completed.toggle() }) {
                Image(systemName: completed ? "checkmark.square.fill" : "square")
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                
                Text("\(item.quantity, specifier: "%.2f") items")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Added by " + (item.added_by.firstname ?? "Logan"))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(completed ? Color.gray.opacity(0.3) : Color.white)
        .cornerRadius(10)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .none
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}

struct GroceryList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GroceryList()
        }
    }
}
