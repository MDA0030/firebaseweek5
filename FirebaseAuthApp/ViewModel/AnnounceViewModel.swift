//
//  AnnounceViewModel.swift
//  FirebaseAuthApp
// Uses firebase firestore concept of title and content from lecture video
//  Created by matt on 11/22/26.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import Combine

@MainActor

final class AnnounceViewModel: ObservableObject {
    
    @Published var errorMsg: String?
    @Published var title = ""
    @Published var content = ""
    
    //database connection to firestore
    private let db = Firestore.firestore()
    
    //gets collection and document fields from firestore
    func announcementLoader() async {
        errorMsg = nil
        do {
            let announcement = try await db.collection("storeannouncements")
                .document("trekkie1")
                .getDocument()
            
            title = announcement["title"] as? String ?? ""
            content = announcement["content"] as? String ?? ""
            
            
        } catch {
            print("Banner error is:", error)
            errorMsg = "Could not process banner announcement"
            
        }
        
    }
    
}
