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
        VStack(alignment: .center, spacing: 16) {
            Text("Grocery List")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            List {
                ForEach(groceryItems) { item in
                    GroceryItemRow(item: item)
                        .listRowInsets(EdgeInsets())
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            HStack {
                Spacer()
                Button(action: {
                    self.addItem()
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.headline)
                        Text("Add Item")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
                }
                Spacer()
            }
            .padding(.vertical, 16)
        }
        .padding(.horizontal, 16)
    }

    func addItem() {
        
    }
    
    func deleteItems(at offsets: IndexSet) {
        groceryItems.remove(atOffsets: offsets)
    }
}

struct GroceryItemRow: View {
    let item: GroceryItem
    
    var body: some View {
        HStack {
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
            .padding(.horizontal)
            
            Spacer()
            
            VStack(alignment: .center) {
                if item.status == .Complete {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                        .overlay(
                            Image(systemName: "circle")
                                .foregroundColor(.white)
                        )
                } else {
                    Image(systemName: "circle")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
                
                Text(formatDate(item.due_date))
                    .font(.subheadline)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
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
        GroceryList()
    }
}
