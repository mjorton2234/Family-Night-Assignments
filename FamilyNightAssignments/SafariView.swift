//
//  SafariView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 8/5/26.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}
