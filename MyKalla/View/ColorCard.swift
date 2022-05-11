//
//  ColorCard.swift
//  MyKalla
//
//  Created by Hafshy Yazid Albisthami on 11/05/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct ColorCard: View {
    @Binding var showToast: Bool
    
    var title: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text("#     " + title)
                .font(.headline)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            if title != "-" {
                Image(systemName: "doc.on.doc")
                    .onTapGesture {
                        UIPasteboard.general.string = self.title
                        withAnimation {
                            showToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.background)
        .opacity(0.8)
        .modifier(CardModifier())
    }
}

struct RgbColorCard: View {
    @Binding var showToast: Bool
    
    var red: Int
    var green: Int
    var blue: Int
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("R     " + String(red))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                
                Spacer()
                
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.red)
                    .onTapGesture {
                        UIPasteboard.general.string = String(red)
                        withAnimation {
                            showToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            Divider()
            
            HStack(alignment: .center) {
                Text("G     " + String(green))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Spacer()
                
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.green)
                    .onTapGesture {
                        UIPasteboard.general.string = String(green)
                        withAnimation {
                            showToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Divider()
            
            HStack(alignment: .center) {
                Text("B     " + String(blue))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        UIPasteboard.general.string = String(blue)
                        withAnimation {
                            showToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.background)
        .opacity(0.8)
        .modifier(CardModifier())
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
}

