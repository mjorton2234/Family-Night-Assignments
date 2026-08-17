//
//  AboutView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 8/5/26.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        SafariView(url: URL(string: "https://sites.google.com/view/familynightassignmentsapp/home")!)
            .ignoresSafeArea()
    }
}
