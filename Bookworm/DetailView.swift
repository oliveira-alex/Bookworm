//
//  DetailView.swift
//  Bookworm
//
//  Created by Alex Oliveira on 03/10/21.
//

import CoreData
import SwiftUI

extension Date {
    func string() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd/MM/yyyy"
        return dateformat.string(from: self)
    }
}

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(self.book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("\(Int(self.book.rating) == 1 ? "1 star" : "\(Int(self.book.rating)) stars")"))
                    .accessibilityRemoveTraits(.isButton)
                
                Text(self.book.date?.string() ?? "Unknown date")
                    .font(.title2)
                    .padding()
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown book"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete book"),
                message: Text("Are you sure?"),
                primaryButton: .destructive(Text("Delete")) { self.deleteBook() },
                secondaryButton: .cancel()
            )
        }
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    
    func deleteBook() {
        moc.delete(book)
        
        // try? self.moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Text book"
        book.author = "Text author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
