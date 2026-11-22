//
//  AuthViewModel.swift
//  FirebaseAuthApp
//
//  Created by matt on 11/16/26.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Combine

@MainActor
//handles logging in, logging out and signup
final class AuthenticateViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMsg: String?
    @Published var fbUser: User?
    
    //listener handle for firebase
    private var handle: AuthStateDidChangeListenerHandle?
    
    //updates for login or logout or if user still logged in
    init() {
        fbUser = Auth.auth().currentUser
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in self?.fbUser = user}
    }
    



var isLoggedIn: Bool { fbUser != nil }

    //function for user signup with email and password
func userSignUp(email: String, passwd: String) async {
    errorMsg = nil
    isLoading = true
    defer { isLoading = false }
    do {
        try await Auth.auth().createUser(withEmail: email, password: passwd)
    } catch {
        errorMsg = message(for: error)
    }
    
}

    //function for user sign out
func userSignOut() {
    errorMsg = nil
    do {
        try Auth.auth().signOut()
    } catch {
        errorMsg = message(for: error)
    }
}

    //function for user sign in with email and password
func userSignIn(email: String, passwd: String) async {
        errorMsg = nil
        isLoading = true
        defer { isLoading = false }
        do {
            try await Auth.auth().signIn(withEmail: email, password: passwd)
        } catch {
            errorMsg = message(for: error)
        }
    }

    
    //function for firebase errors of weak password, wrong password, email not valid,loss of network connection, existing email or too many tries
private func message(for error: Error) -> String {
    let idError = error as NSError
    guard let code = AuthErrorCode(rawValue: idError.code) else {
        return "Error, please try again."
        
    }
    switch code {
    case .tooManyRequests:
        return "Error, too many attempts. Please try later."
    case .weakPassword:
        return "Password must be 6 characters."
    case .wrongPassword, .userNotFound, .invalidCredential:
        return "Email or password is incorrect."
    case .invalidEmail:
        return "Enter a valid email."
    case .networkError:
        return "Network error."
    case .emailAlreadyInUse:
        return "This email is already taken."
    default: return "Error. Something went wrong."
        }
     }
}
    

