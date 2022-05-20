//
//  ColorDetail.swift
//  MyKalla
//
//  Created by Hafshy Yazid Albisthami on 19/05/22.
//

import SwiftUI

struct ColorDetail: View {
    @State var isShowToast: Bool = false
    var colorName: String
    var hex: String
    var r: String
    var g: String
    var b: String
    var group: String
    var body: some View {
        GeometryReader { proxy -> AnyView in
            
            let height = proxy.frame(in: .global).height
            let width = proxy.frame(in: .global).width
            
            return AnyView(
                VStack {
                    ScrollView {
                        VStack {
                            HStack {
                                Text(colorName)
                                    .font(.largeTitle)
                                    .bold()
                                Spacer()
                            }
                            HStack {
                                Text("From: " + group)
                                    .font(.headline)
                                Spacer()
                            }
                            
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: width - 80, height: width * 0.7 - 80, alignment: .center)
                                .padding()
                                .foregroundColor(Color(red: Double(r)! / 255, green: Double(g)! / 255, blue: Double(b)! / 255))
                            
                            HStack {
                                Text("HEX Value")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal, 4)
                            
                            ColorCard(showToast: $isShowToast, title: hex == "" ? "-" : hex)
                            
                            HStack {
                                Text("RGB Value")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal, 4)
                            .padding(.top, 12)
                            
                            RgbColorCard(showToast: $isShowToast, red: Int(r)!, green: Int(g)!, blue: Int(b)!)
                            
                            
                        }
                        .padding()
                    }
                    Spacer(minLength: 80)
                }
                
            )
        }
        .padding(.top, 90)
        .ignoresSafeArea()
        
    }
}
