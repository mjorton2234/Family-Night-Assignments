//
//  ShareSheet.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 7/30/26.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
