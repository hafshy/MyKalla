//
//  BlurView.swift
//  MyKalla
//
//  Created by Hafshy Yazid Albisthami on 10/05/22.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
}

