//
//  ContentView.swift
//  Book2
//
//  Created by matt on 10/26/26.
// Uses firebase firestore concept of title and content from lecture video
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var auth: AuthenticateViewModel
    
    @State private var chosenBook: Book?
    @State private var toggleMystery = false
    @State private var showConfirmed = false
    
    //
    @State private var mysteryBook: Book?
    
    // loads store banner based on title and content in firestore
    @StateObject private var banner = AnnounceViewModel()
    
    
    //returns price of book and adds Book.mysteryPrice of $9.99 if toggled, else adds 0
    private var mysteryTotal: Double {
        guard let book = chosenBook else {return 0}
        return book.bookPrice + (toggleMystery ? Book.mysteryPrice:0)
    }
    
    //returns msg of book title, the mystery book if chosen and then mysteryTotal limited to XX.XX price.
    private var confirmationText: String {
        guard let book = chosenBook else {return ""}
        
        
        var message = "Selected book: \(book.bookTitle)"
        
        if toggleMystery {
            if let mystery = mysteryBook {
                message += "\nMystery book: \(mystery.bookTitle)"
            }
        }
        //limits mysteryTotal msg to XX.XX for price
        message += "\nTotal: \(mysteryTotal.dollarCurrency.prefix(5))"
        //** prefix? for string extra characters in confirmationText
        return message
        
    }
    
    
    var body: some View {
        VStack(spacing:0) {
            header
            
            //banner that uses firestore for store messages
            showStoreBanner
            
            ScrollView {
                VStack(spacing:10) {
                    ForEach(Book.bookCatalog) {book in bookRow(book)
                            .onTapGesture {
                                chosenBook = book}
                    }
                }
                .padding(.horizontal)
            }
            checkoutBar
        }
        .alert("Order submitted", isPresented: $showConfirmed) {
            Button("OK") {
            }
        } message: {
            Text(confirmationText)
        }
        .task {
            await banner.announcementLoader()
        }
    }
    
    // banner that ties to firebase firestore
    @ViewBuilder
    private var showStoreBanner: some View {
        if !banner.content.isEmpty || !banner.title.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                Text(banner.title)
                    .font(.headline)
                Text(banner.content)
                    .font(.subheadline)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple.opacity(0.25)))
            .padding(.horizontal)
            .padding(.bottom, 6)
        }
        
        
    }
    
    
        
    // view for logo and name of book store
    private var header: some View {
        VStack(spacing:8) {
            //button to logout
            HStack {
                Text(auth.fbUser?.email ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Log Out") {
                    auth.userSignOut()
                }
                .font(.headline.bold())
                .tint(.purple)
                
            }
            .padding(.horizontal)
            
            //Logo
                Image("purpleDragon")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                .font(.system(size: 36))
                .foregroundStyle(.white)
                .frame(width:72, height:72)
                .background(Image("purpleDragon"))
                .overlay(Circle().stroke(Color.purple.opacity(0.25), lineWidth:1))
            
            
            Text("The Lore and Myth Page")
                .font(.system(.title, design: .serif).bold())
            Text("Sci Fi Fantasy Book Store")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                    colors: [.purple, .indigo],
                    startPoint: .leading,
                    endPoint: .trailing
                    )
                )
                //.foregroundStyle(Color("#7030A0"))
            }
            .padding(.vertical)
        }
    
    //returns view for catalog list row
    private func bookRow(_ book: Book) -> some View {
     
        return HStack {
            Image(systemName: book == chosenBook ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(book == chosenBook ? .purple: .secondary)
            Text(book.bookTitle)
                .font(.headline)
            Spacer()
            Text(book.bookPrice.dollarCurrency)
           // precision(.fractionLength(2))
          //  )
                .monospacedDigit()
        }
        .padding()
        .background (RoundedRectangle(cornerRadius: 12)
            .fill(book == chosenBook ? Color.purple.opacity(0.15) : Color(.secondarySystemBackground)))
        .contentShape(Rectangle())
        }
    
    // view for checkout portion, toggle option is connected to toggleMystery, shows price total and button to submit order
    private var checkoutBar: some View {
        VStack(spacing:12) {
            Toggle("Include a mystery 2nd book (\(Book.mysteryPrice.dollarCurrency))",
                   isOn: $toggleMystery
            )
                .disabled(chosenBook == nil)
            
            HStack {
                Text("Total")
                    .font(.title3.bold())
                Spacer()

              //  let mysteryTotal = (mysteryTotal * 100).rounded() / 100
              //  Text(mysteryTotal.dollarCurrency.prefix(5))
                Text(mysteryTotal.dollarCurrency.prefix(5))
                    .font(.title3.bold())
                    .monospacedDigit()
            }
            
            Button("Submit your Order") {
                //if toggled gets book from mysterBookBin tuple, none if not toggled
                if toggleMystery {
                    mysteryBook = Book.mysteryBookBin.randomElement()
                } else {
                    mysteryBook = nil
                }
            
                //activates alert
            showConfirmed = true
        }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .controlSize(.large)
                .disabled(chosenBook == nil)
        }
        .padding()
        .background(.ultraThinMaterial)
        }
    }
