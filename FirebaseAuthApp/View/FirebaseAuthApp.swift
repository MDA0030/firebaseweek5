//
//  FirebaseAuthApp.swift
//  FirebaseAuthApp
//
//  Created by matt on 11/16/26.
//


import SwiftUI
import FirebaseCore
//import FirebaseAuth



@main
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

