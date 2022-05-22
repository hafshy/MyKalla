//
//  Main.swift
//  MyKalla
//
//  Created by Hafshy Yazid Albisthami on 11/05/22.
//

import SwiftUI
import AVFoundation
import Combine
import CoreData

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
    @State var hexMode: Bool = true
    @State var inputHEX: String = ""
    @State var inputR: String = ""
    @State var inputG: String = ""
    @State var inputB: String = ""
    @State var isShowToast: Bool = false
    @State var isShowSheet: Bool = false
    @GestureState var gestureOffset: CGFloat = 0
    @FocusState var isInputActive: Bool
    @Environment(\.managedObjectContext) var manageObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.colorName)]) var kallaColor: FetchedResults<KallaCollection>
    @SectionedFetchRequest(sectionIdentifier: \.group!, sortDescriptors: [SortDescriptor(\.colorName)]) var kallaSectionColor: SectionedFetchResults<String, KallaCollection>
    
    // MARK: Map HEX <-> RGB
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
    
    // MARK: Input Validation
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
                // MARK: Background View
                // TODO: change to My Kalla view
                GeometryReader { proxy in
                    let frame = proxy.frame(
                        in: .global
                    )
                    
                    // TODO: Change this image into MyKalla, ok?
//                    Image("gradient")
//                        .resizable()
//                        .aspectRatio(
//                            contentMode: .fill
//                        )
//                        .frame(
//                            width: frame.width,
//                            height: frame.height,
//                            alignment: .center
//                        )
                }
                .ignoresSafeArea()
                
                VStack {
                    // MARK: Total Color
                    HStack {
                        Text("Total color: \(totalColor())")
                            .font(.headline)
                            .bold()
                            .padding(.horizontal)
                            
                        Spacer()
                    }
                    
                    // MARK: Color List
                    if (totalColor() == 0) {
                        Spacer()
                        Text("Swipe to convert and save color!")
                            .bold()
                        Spacer()
                    } else {
                        List {
                            ForEach(kallaSectionColor) { section in
                                Section(header: Text(section.id)) {
                                    ForEach(section) { color in
                                        NavigationLink(destination: ColorDetail(colorName: color.colorName!, hex: color.hex!, r: String(color.r), g: String(color.g), b: String(color.b), group: color.group!)) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(color.colorName ?? "Unknown")
                                                        .font(.title2)
                                                        .bold()
                                                    Text("#" + (color.hex ?? "Unknown"))
                                                        .font(.subheadline)
                                                }
                                                
                                                Spacer()
                                                
                                                RoundedRectangle(cornerRadius: 8)
                                                    .frame(width: 40, height: 40, alignment: .center)
                                                    .foregroundColor(Color(red: Double(color.r) / 255, green: Double(color.g) / 255, blue: Double(color.b) / 255))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(.gray, lineWidth: 1)
                                                    )
                                                    .padding()
                                                    .simultaneousGesture(
                                                        LongPressGesture()
                                                            .onEnded { _ in
                                                                onHold(text: color.colorName ?? "Unknown")
                                                            }
                                                    )
                                            }
                                        }
                                        .swipeActions(content: {
                                            Button(role: .destructive, action: {
                                                withAnimation {
                                                    deleteColorInSection(collection: color)
                                                }
                                            }, label: {
                                                Image(systemName: "trash")
                                                
                                            })
                                        })
                                    }
                                }
                            }
                            
                            
                        }
                        .listStyle(.plain)
                    }
                    Spacer(minLength: 105.0)
                    
                    
                }
                
                // MARK: Bottom Sheet View
                // TODO: add convert component
                GeometryReader { proxy -> AnyView in
                    
                    let height = proxy.frame(in: .global).height
                    let width = proxy.frame(in: .global).width
                    
                    return AnyView(
                        
                        // MARK: Bottom Sheet Container
                        ZStack {
                            
                            // MARK: Background Blur
                            BlurView(style: .systemUltraThinMaterial)
                                .clipShape(CustomEdge(corner: [.topLeft, .topRight], radius: 32))
                            
                            // MARK: Bottom Sheet Content
                            // TODO: Add Converter behind capsule
                            VStack {
                                Capsule()
                                    .fill(.primary)
                                    .frame(
                                        width: 40,
                                        height: 4,
                                        alignment: .center
                                    )
                                    .padding(.top, 12)
                                
                                Text("Convert")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                
                                ScrollView {
                                    Section(
                                        header:
                                            // MARK: Mode Switcher
                                        VStack {
                                            Divider()
                                            
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
                                        }
                                    ) {
                                        // MARK: HEX Mode
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
                                                            loadName(hex: currentHEX) { (colorName) in
                                                                currentColorName = colorName.name.value
                                                            }
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
                                        
                                        // MARK: RGB Mode
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
                                                            
                                                            loadName(hex: currentHEX) { (colorName) in
                                                                currentColorName = colorName.name.value
                                                            }
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
                                                            loadName(hex: currentHEX) { (colorName) in
                                                                currentColorName = colorName.name.value
                                                            }
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
                                                        .accessibility(label: Text("RGB Text"))
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
                                                            loadName(hex: currentHEX) { (colorName) in
                                                                currentColorName = colorName.name.value
                                                            }
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
                                        
                                        
                                        // MARK: Color View and Colorname
                                        if currentHEX != "" {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .frame(width: width - 80, height: width * 0.75 - 80, alignment: .center)
                                                    .padding()
                                                    .foregroundColor(currentColor)
                                                    .simultaneousGesture(
                                                        LongPressGesture()
                                                            .onEnded { _ in
                                                                if !currentColorName.isEmpty {
                                                                    onHold(text: currentColorName)
                                                                }
                                                            }
                                                    )

                                                Text(!currentColorName.isEmpty ? currentColorName : "?")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.bold)
                                                    .padding(.vertical, 8)
                                                    .padding(.horizontal, 24)
                                                    .background(.gray.opacity(0.5))
                                                    .clipShape(Capsule())
                                            }
                                            
                                            if (!hexMode) {
                                                // MARK: HEX Color Copy Card
                                                HStack {
                                                    Text("HEX Value")
                                                        .font(.subheadline)
                                                        .fontWeight(.bold)
                                                    Spacer()
                                                }
                                                .padding(.horizontal, 4)
                                                
                                                ColorCard(showToast: $isShowToast, title: currentHEX == "" ? "-" : currentHEX)
                                            }
                                                
                                            if (hexMode) {
                                                // MARK: RGB Color Copy Card
                                                HStack {
                                                    Text("RGB Value")
                                                        .font(.subheadline)
                                                        .fontWeight(.bold)
                                                    Spacer()
                                                }
                                                .padding(.horizontal, 4)
                                                .padding(.top, 12)
                                                
                                                RgbColorCard(showToast: $isShowToast, red: currentRGB["red"]!, green: currentRGB["green"]!, blue: currentRGB["blue"]!)
                                            }

                                            Button(action: {
                                                isInputActive = false
                                                isShowSheet.toggle()

                                            }
                                            ) {
                                                Text("Save Color")
                                                    .bold()
                                                    .frame(maxWidth: .infinity)
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .background(.blue)
                                            }
                                            .cornerRadius(16)
                                            .padding(.vertical)
                                            .sheet(isPresented: $isShowSheet) {
                                                SaveSheet(hex: currentHEX, rgb: currentRGB, groupList: getDistinctGroup(), passedColorName: currentColorName)
                                            }
                                            
                                            Spacer(minLength: 100.0)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                            .offset(y: height - 190)
                            .offset(y: -offset > 0 ? -offset <= (height - 190) ? offset : -(height - 190) : 0)
                            .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                                
                                out = value.translation.height
                                onChange()
                                
                            }).onEnded({ value in
                                
                                let maxHeight = height - 190
                                
                                withAnimation(
                                    .spring()
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
                
                // MARK: Toast Alert
                if isShowToast {
                    VStack {
                        Spacer()
                        
                        Text("Copied!")
                            .padding(10)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .background(.black.opacity(0.8))
                            .clipShape(Capsule())
                            .padding(42)
                    }
                }
            }
            .navigationTitle("My Kalla")
        }
        .toolbar {
            
            // TODO: Add gesture with function to show sheet
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Image(
                    systemName: "square.grid.2x2"
                )
                .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: Function
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
    
    // MARK: HEX to RGB
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
    
    // MARK: RGB to HEX
    func toHEX(r: Int, g: Int, b: Int) -> String {
        let hexR: String = mapRGB[r / 16]! + mapRGB[r % 16]!
        let hexG: String = mapRGB[g / 16]! + mapRGB[g % 16]!
        let hexB: String = mapRGB[b / 16]! + mapRGB[b % 16]!
        
        return (hexR + hexG + hexB)
    }
    
    func deleteColor(offsets: IndexSet) {
        withAnimation {
            offsets.map { kallaColor[$0] }.forEach(manageObjectContext.delete)
            
            ColorDataController().save(context: manageObjectContext)
        }
    }
    
    func deleteColorInSection(collection: KallaCollection) {
        manageObjectContext.delete(collection)
        ColorDataController().save(context: manageObjectContext)
    }
    
    func totalColor() -> Int {
        return kallaColor.count
    }
    
    func loadName(hex: String, completion: @escaping (ColorName) -> ()) {
        guard let url = URL(string: "https://www.thecolorapi.com/id?hex=" + currentHEX) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            do {
                if data != nil {
                    let colorName = try! JSONDecoder().decode(ColorName.self, from: data!)
                    DispatchQueue.main.async {
                        completion(colorName)
                    }
                } else {
                    print("Wrong path")
                }
            }
        }
        .resume()
    }
    
    func getDistinctGroup() -> [String] {
        let groups: [String] = kallaColor.map { $0.group! }
        let filtered: [String] = Array(Set(groups))
        return filtered
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}

