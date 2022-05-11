//
//  Main.swift
//  MyKalla
//
//  Created by Hafshy Yazid Albisthami on 11/05/22.
//

import SwiftUI
import AVFoundation
import Combine

struct Main: View {
    // Gesture
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @State var currentColorName: String = ""
    @State var currentColor: Color = Color(red: 0, green: 0, blue: 0)
    @State var currentRGB: [String: Int] = [
        "red": -1,
        "green": -1,
        "blue": -1
    ]
    @State var currentHEX: String = ""
    @State var hexMode: Bool = false
    @State var inputHEX: String = ""
    @State var inputR: String = ""
    @State var inputG: String = ""
    @State var inputB: String = ""
    @GestureState var gestureOffset: CGFloat = 0
    @FocusState var isInputActive: Bool
    
    // Mapping Single Hex Value to RGB
    let mapHex: [String: Int] = [
        "0": 0,
        "1": 1,
        "2": 2,
        "3": 3,
        "4": 4,
        "5": 5,
        "6": 6,
        "7": 7,
        "8": 8,
        "9": 9,
        "A": 10,
        "B": 11,
        "C": 12,
        "D": 13,
        "E": 14,
        "F": 15
    ]
    
    // Mapping Single RGB Value to HEX
    let mapRGB: [Int: String] = [
        0: "0",
        1: "1",
        2: "2",
        3: "3",
        4: "4",
        5: "5",
        6: "6",
        7: "7",
        8: "8",
        9: "9",
        10: "A",
        11: "B",
        12: "C",
        13: "D",
        14: "E",
        15: "F"
    ]
    
    // HEX Input Validation
    var validInputHEX: Bool {
        inputHEX.count == 6 || inputHEX.isEmpty
    }
    
    // RGB Input Validation
    var validInputRGB: Bool {
        (Int(inputR) ?? -1) >= 0 &&
        (Int(inputR) ?? 256) <= 255 &&
        (Int(inputG) ?? -1) >= 0 &&
        (Int(inputG) ?? 256) <= 255 &&
        (Int(inputB) ?? -1) >= 0 &&
        (Int(inputB) ?? 256) <= 255
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background View
                // TODO: change to My Kalla view
                GeometryReader { proxy in
                    let frame = proxy.frame(
                        in: .global
                    )
                    
                    // TODO: Change this image into MyKalla, ok?
                    Image("gradient")
                        .resizable()
                        .aspectRatio(
                            contentMode: .fill
                        )
                        .frame(
                            width: frame.width,
                            height: frame.height,
                            alignment: .center
                        )
                }
                .ignoresSafeArea()
                
                // Bottom Sheet View
                // TODO: add convert component
                GeometryReader { proxy -> AnyView in
                    
                    let height = proxy.frame(in: .global).height
                    let width = proxy.frame(in: .global).width
                    
                    return AnyView(
                        
                        // Bottom Sheet Conainer
                        ZStack {
                            
                            // Background Blur
                            BlurView(style: .systemThinMaterial)
                                .clipShape(CustomEdge(corner: [.topLeft, .topRight], radius: 32))
                            
                            // Content
                            // TODO: Add Converter behind capsule
                            VStack {
                                Capsule()
                                    .fill(.white)
                                    .frame(width: 40, height: 4, alignment: .center)
                                    .padding(.top, 12)
                                
                                Text("Convert")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                
                                ScrollView {
                                    Section(
                                        header:
                                            // Mode Switcher
                                            HStack {
                                                Text(hexMode ? "From HEX" : "From RGB")
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                
                                                Spacer()
                                                
                                                Button("Switch") {
                                                    hexMode.toggle()
                                                }
                                                .padding(4)
                                                .background(.clear)
                                                .clipShape(Capsule())
                                            }
                                    ) {
                                        // HEX Mode
                                        if hexMode {
                                            // Input HEX
                                            HStack {
                                                Text("#")
                                                    .font(.title2)
                                                    .foregroundColor(validInputHEX ? .primary : .red)
                                                
                                                TextField("123ABC", text: $inputHEX)
                                                    .font(.title2)
                                                    .textFieldStyle(.roundedBorder)
                                                    .border(validInputHEX ? .gray : .red)
                                                    .textInputAutocapitalization(.characters)
                                                    .focused($isInputActive)
                                                    .toolbar {
                                                        ToolbarItemGroup(placement: .keyboard) {
                                                            Spacer()

                                                            Button("Done") {
                                                                isInputActive = false
                                                            }
                                                        }
                                                    }
                                                    .onReceive(Just(inputHEX)) { newValue in
                                                        let filtered = newValue.filter {
                                                            "0123456789ABCDEFabcdef"
                                                            .contains($0)
                                                        }
                                                        if filtered != newValue {
                                                            inputHEX = String(filtered.prefix(6)).uppercased()
                                                        }
                                                        if (inputHEX.count == 6) {
                                                            let rgb = toRGB(hex: inputHEX)
                                                            
                                                            currentHEX = inputHEX
                                                            currentRGB = [
                                                                "red": rgb.r,
                                                                "green": rgb.g,
                                                                "blue": rgb.b
                                                            ]

                                                            currentColor = Color(
                                                                red: Double(rgb.r) / 255,
                                                                green: Double(rgb.g) / 255,
                                                                blue: Double(rgb.b) / 255
                                                            )
                                                            
                                                        } else {
                                                            currentHEX = ""
                                                            currentRGB = [
                                                                "red": -1,
                                                                "green": -1,
                                                                "blue": -1
                                                            ]
                                                            currentColor = .gray
                                                            currentColorName = ""
                                                        }
                                                    }
                                            }
                                            
                                            // Input Hex Validation
                                            HStack {
                                                if !validInputHEX {
                                                    Text("HEX value must be 6")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.5)))
                                                }

                                                Spacer()
                                            }
                                        }
                                        
                                        // RGB Mode
                                        if !hexMode {
                                            // Input R
                                            HStack {
                                                Text("R")
                                                    .font(.title2)
                                                    .foregroundColor(((Int(inputR) ?? -1) >= 0 && (Int(inputR) ?? -1) <= 255) || inputR == "" ? .primary : .red)
                                                
                                                TextField("0", text: $inputR)
                                                    .font(.title2)
                                                    .textFieldStyle(.roundedBorder)
                                                    .border(((Int(inputR) ?? -1) >= 0 && (Int(inputR) ?? -1) <= 255) || inputR == "" ? .gray : .red)
                                                    .keyboardType(.decimalPad)
                                                    .focused($isInputActive)
                                                    .onReceive(Just(inputR)) { newValue in
                                                        let filtered = newValue.filter {
                                                            $0.isNumber
                                                        }
                                                        if filtered != newValue {
                                                            inputR = filtered
                                                        }
                                                        if (validInputRGB) {
                                                            currentRGB = [
                                                                "red": Int(inputR)!,
                                                                "green": Int(inputG)!,
                                                                "blue": Int(inputB)!
                                                            ]
                                                            let hex = toHEX(r: Int(inputR)!, g: Int(inputG)!, b: Int(inputB)!)
                                                            currentHEX = hex
                                                            currentRGB = [
                                                                "red": Int(inputR)!,
                                                                "green": Int(inputG)!,
                                                                "blue": Int(inputB)!
                                                            ]

                                                            currentColor = Color(
                                                                red: Double(inputR)! / 255,
                                                                green: Double(inputG)! / 255,
                                                                blue: Double(inputB)! / 255
                                                            )
                                                        } else {
                                                            currentHEX = ""
                                                            currentRGB = [
                                                                "red": -1,
                                                                "green": -1,
                                                                "blue": -1
                                                            ]
                                                            currentColor = .gray
                                                            currentColorName = ""
                                                        }
                                                    }
                                            }
                                            
                                            // Input R Validation
                                            HStack {
                                                if !((Int(inputR) ?? -1) >= 0 && (Int(inputR) ?? -1) <= 255) && inputR != "" {
                                                    Text("RGB Value must between 0 and 255")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.5)))
                                                }

                                                Spacer()
                                            }
                                            
                                            // Input G
                                            HStack {
                                                Text("G")
                                                    .font(.title2)
                                                    .foregroundColor(((Int(inputG) ?? -1) >= 0 && (Int(inputG) ?? -1) <= 255) || inputG == "" ? .primary : .red)
                                                
                                                TextField("0", text: $inputG)
                                                    .font(.title2)
                                                    .textFieldStyle(.roundedBorder)
                                                    .border(((Int(inputG) ?? -1) >= 0 && (Int(inputG) ?? -1) <= 255) || inputG == "" ? .gray : .red)
                                                    .keyboardType(.decimalPad)
                                                    .focused($isInputActive)
                                                    .onReceive(Just(inputG)) { newValue in
                                                        let filtered = newValue.filter {
                                                            $0.isNumber
                                                        }
                                                        if filtered != newValue {
                                                            inputG = filtered
                                                        }
                                                        if (validInputRGB) {
                                                            currentRGB = [
                                                                "red": Int(inputR)!,
                                                                "green": Int(inputG)!,
                                                                "blue": Int(inputB)!
                                                            ]
                                                            let hex = toHEX(r: Int(inputR)!, g: Int(inputG)!, b: Int(inputB)!)
                                                            currentHEX = hex
                                                            currentRGB = [
                                                                "red": Int(inputR)!,
                                                                "green": Int(inputG)!,
                                                                "blue": Int(inputB)!
                                                            ]

                                                            currentColor = Color(
                                                                red: Double(inputR)! / 255,
                                                                green: Double(inputG)! / 255,
                                                                blue: Double(inputB)! / 255
                                                            )
                                                        } else {
                                                            currentHEX = ""
                                                            currentRGB = [
                                                                "red": -1,
                                                                "green": -1,
                                                                "blue": -1
                                                            ]
                                                            currentColor = .gray
                                                            currentColorName = ""
                                                        }
                                                    }
                                            }
                                            
                                            // Input G Validation
                                            HStack {
                                                if !((Int(inputG) ?? -1) >= 0 && (Int(inputG) ?? -1) <= 255) && inputG != "" {
                                                    Text("RGB Value must between 0 and 255")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.5)))
                                                }

                                                Spacer()
                                            }
                                            
                                            // Input B
                                            HStack {
                                                Text("B")
                                                    .font(.title2)
                                                    .foregroundColor(((Int(inputB) ?? -1) >= 0 && (Int(inputB) ?? -1) <= 255) || inputB == "" ? .primary : .red)
                                                
                                                TextField("0", text: $inputB)
                                                    .font(.title2)
                                                    .textFieldStyle(.roundedBorder)
                                                    .border(((Int(inputB) ?? -1) >= 0 && (Int(inputB) ?? -1) <= 255) || inputB == "" ? .gray : .red)
                                                    .keyboardType(.decimalPad)
                                                    .focused($isInputActive)
                                                    .toolbar {
                                                        ToolbarItemGroup(placement: .keyboard) {
                                                            Spacer()

                                                            Button("Done") {
                                                                isInputActive = false
                                                            }
                                                        }
                                                    }
                                                    .onReceive(Just(inputB)) { newValue in
                                                        let filtered = newValue.filter {
                                                            $0.isNumber
                                                        }
                                                        if filtered != newValue {
                                                            inputB = filtered
                                                        }
                                                        if (validInputRGB) {
                                                            currentRGB = [
                                                                "red": Int(inputR)!,
                                                                "green": Int(inputG)!,
                                                                "blue": Int(inputB)!
                                                            ]
                                                            let hex = toHEX(r: Int(inputR)!, g: Int(inputG)!, b: Int(inputB)!)
                                                            currentHEX = hex
                                                            currentRGB = [
                                                                "red": Int(inputR)!,
                                                                "green": Int(inputG)!,
                                                                "blue": Int(inputB)!
                                                            ]

                                                            currentColor = Color(
                                                                red: Double(inputR)! / 255,
                                                                green: Double(inputG)! / 255,
                                                                blue: Double(inputB)! / 255
                                                            )
                                                        } else {
                                                            currentHEX = ""
                                                            currentRGB = [
                                                                "red": -1,
                                                                "green": -1,
                                                                "blue": -1
                                                            ]
                                                            currentColor = .gray
                                                            currentColorName = ""
                                                        }
                                                    }
                                                
                                            }
                                            
                                            // Input B Validation
                                            HStack {
                                                if !((Int(inputB) ?? -1) >= 0 && (Int(inputB) ?? -1) <= 255) && inputB != "" {
                                                    Text("RGB Value must between 0 and 255")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.5)))
                                                }

                                                Spacer()
                                            }
                                        }
                                        
                                        
                                        // Color View and Colorname
                                        if currentHEX != "" {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .frame(width: width - 80, height: width * 0.75 - 80, alignment: .center)
                                                    .padding()
                                                    .foregroundColor(currentColor)
                                                    .simultaneousGesture(
                                                        LongPressGesture()
                                                            .onEnded { _ in
                                                                onHold(text: "Ashyaap")
                                                            }
                                                    )
                                                
                                                Text(!currentHEX.isEmpty ? currentHEX : "?")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.bold)
                                                    .padding(.vertical, 8)
                                                    .padding(.horizontal, 24)
                                                    .background(.gray.opacity(0.5))
                                                    .clipShape(Capsule())
                                            }
                                            
                                            // HEX Color Copy Card
                                            HStack {
                                                Text("HEX Value")
                                                    .font(.subheadline)
                                                    .fontWeight(.bold)
                                                Spacer()
                                            }
                                            .padding(.horizontal, 4)
                                            
                                            ColorCard(title: currentHEX == "" ? "-" : currentHEX)
                                            
                                            // RGB Color Copy Card
                                            HStack {
                                                Text("RGB Value")
                                                    .font(.subheadline)
                                                    .fontWeight(.bold)
                                                Spacer()
                                            }
                                            .padding(.horizontal, 4)
                                            .padding(.top, 12)
                                            RgbColorCard(red: currentRGB["red"]!, green: currentRGB["green"]!, blue: currentRGB["blue"]!)
                                            Spacer(minLength: 100.0)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                            .offset(y: height - 285)
                            .offset(y: -offset > 0 ? -offset <= (height - 285) ? offset : -(height - 285) : 0)
                            .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                                
                                out = value.translation.height
                                onChange()
                                
                            }).onEnded({ value in
                                
                                let maxHeight = height - 285
                                
                                withAnimation(
                                    .interpolatingSpring(
                                        mass: 0.3,
                                        stiffness: 10,
                                        damping: 2,
                                        initialVelocity: 0
                                    )
                                )
                                {
                                    if (-offset > 150 && -offset < maxHeight / 1.5) {
                                        offset = -(maxHeight / 2.5)
                                    } else if (-offset > maxHeight / 1.5) {
                                        offset = -maxHeight
                                    } else {
                                        offset = 0
                                    }
                                }
                                lastOffset = offset
                            }))
                    )
                }
                .ignoresSafeArea(.all, edges: .bottom)
            }
            .navigationTitle("My Kalla")
        }
        .toolbar {
            
            // TODO: Add gesture with function to show sheet
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Image(
                    systemName: "plus.rectangle.on.rectangle"
                )
                .foregroundColor(.blue)
            }
        }
    }
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    func onHold(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.4

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    // HEX to RGB
    func toRGB(hex: String) -> (r: Int, g: Int, b: Int) {
        let rStr: String = String(hex.prefix(2))
        let gStr: String = String(hex.suffix(4).prefix(2))
        let bStr: String = String(hex.suffix(2))
        
        return (
            mapHex[String(rStr.prefix(1))]! * 16 + mapHex[String(rStr.suffix(1))]!,
            mapHex[String(gStr.prefix(1))]! * 16 + mapHex[String(gStr.suffix(1))]!,
            mapHex[String(bStr.prefix(1))]! * 16 + mapHex[String(bStr.suffix(1))]!
        )
    }
    
    // RGB to HEX
    func toHEX(r: Int, g: Int, b: Int) -> String {
        let hexR: String = mapRGB[r / 16]! + mapRGB[r % 16]!
        let hexG: String = mapRGB[g / 16]! + mapRGB[g % 16]!
        let hexB: String = mapRGB[b / 16]! + mapRGB[b % 16]!
        
        return (hexR + hexG + hexB)
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}

