//
//  UserLoginView.swift
//  FirebaseAuthApp
//
//  Created by matt on 11/16/26.
//

import SwiftUI

//for user login or user account creation
struct UserLoginView: View {
    @EnvironmentObject var auth: AuthenticateViewModel
    
    @State private var passwd = ""
    @State private var email = ""
    @State private var isSignUp = false
    
    //lets user submit if field isn't empty
    private var userSubmit: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && passwd.count >= 1 && !auth.isLoading
    }
    
    
    var body: some View {
        VStack(spacing: 12) {
            Text("The Lore and Myth Page")
                .font(.system(.title, design: .serif).bold())
            Text(isSignUp ? "Create an account" : "Log in")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            //field for email
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(.secondarySystemBackground)))
            
            //field for password
            SecureField("Password", text: $passwd)
                .textContentType(isSignUp ? .newPassword: .password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(.secondarySystemBackground)))
            
            if let error = auth.errorMsg {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
            
            if passwd.isEmpty || email.isEmpty {
                Text("Email and password is required to login")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
            }
            
            //button for login or signup
            Button {
                Task {
                    if isSignUp {
                        await auth.userSignUp(email: email, passwd: passwd)
                    } else {
                        await auth.userSignIn(email: email, passwd: passwd)
                    }
                    
                    
                }
            }
            
            label: {
                if auth.isLoading {
                    ProgressView().frame(maxWidth: .infinity)
                } else {
                    Text(isSignUp ? "Sign Up" : "Log in").frame(maxWidth: .infinity)
                }
                
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .controlSize(.large)
            .disabled(!userSubmit)
            
            //button toggle for login or sign up
            Button(isSignUp ? "Already have an account? Log in here" : "New here? Sign up") {
                auth.errorMsg = nil
                isSignUp.toggle()
            }
            .font(.footnote)
            .tint(.purple)
        }
        .padding()
    }
    
 
}


