//
//  FirebaseAuthApp.swift
//  FirebaseAuthApp
//
//  Created by matt on 11/16/26.
// Uses firebase firestore concept of title and content from lecture video
//


import SwiftUI
import FirebaseCore
//import FirebaseAuth



@main
//struct for firebase login info
struct FirebaseAuthApp: App {
    @StateObject private var auth: AuthenticateViewModel
    
    init() {
        FirebaseApp.configure()
        _auth = StateObject(wrappedValue: AuthenticateViewModel())
    
    }
    


    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
        }
    }
}

//shows store ContentView screen after login
struct RootView: View {
    @EnvironmentObject var auth: AuthenticateViewModel
    
    var body: some View {
        if auth.isLoggedIn {
            ContentView()
        } else {
            UserLoginView()
        }
    }
    
    
}

