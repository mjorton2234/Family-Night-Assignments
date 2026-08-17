//
//  PrivacyPolicyView.swift
//  FamilyNightAssignments
//
//  Created by MJ Orton on 8/5/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        SafariView(
            url: URL(string: "https://sites.google.com/view/familynightassignmentsprivacy/home")!
        )
        .ignoresSafeArea()
    }
}

#Preview {
    PrivacyPolicyView()
}
