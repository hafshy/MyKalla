//
//  SaveSheet.swift
//  MyKalla
//
//  Created by Hafshy Yazid Albisthami on 13/05/22.
//

import SwiftUI

struct SaveSheet: View {
    @Environment(\.dismiss) var dismiss
    var groupList: [String]
    var passedColorName: String

        var body: some View {
            VStack {
                Button("Press to dismiss") {
                    dismiss()
                }
                .font(.headline)
                .padding()
                Spacer()
            }
            
        }
}
