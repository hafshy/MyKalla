//
//  SaveSheet.swift
//  MyKalla
//
//  Created by Hafshy Yazid Albisthami on 13/05/22.
//

import SwiftUI

struct SaveSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var pickedGroupName = ""
    @State private var enteredGroupName = ""
    @State private var enteredColorName = ""
    @State private var showOptions: Bool = false
    @FocusState var isInputActiveSave: Bool
    @Environment(\.managedObjectContext) var manageObjectContext
    var hex: String
    var rgb: [String : Int]
    var groupList: [String]
    var passedColorName: String
    
        var body: some View {
            NavigationView {
                ZStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Text("Cancel")
                                    .bold()
                            }
                            Spacer()
                            Text("Save color")
                                .bold()
                            Spacer()
                            Button {
                                ColorDataController().addColor(colorName: enteredColorName.isEmpty ? "Unknown" : enteredColorName, hex: hex, r: rgb["red"]!, g: rgb["green"]!, b: rgb["blue"]!, group: pickedGroupName == "+ New Group..." ? enteredGroupName : pickedGroupName, context: manageObjectContext)
                                dismiss()
                            } label: {
                                Text("Save")
                                    .bold()
                            }
                            .disabled(pickedGroupName == "" || (pickedGroupName == "+ New Group..." && enteredGroupName == ""))
                        }
                        HStack {
                            Text("Color Name")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 4)
                        TextField("Enter color name...", text: $enteredColorName)
                            .font(.title2)
                            .textFieldStyle(.roundedBorder)
                            .focused($isInputActiveSave)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()

                                    Button("Done") {
                                        isInputActiveSave = false
                                    }
                                    .disabled(false)
                                }
                            }
                        HStack {
                            Text("Group Name")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.top, 12)
                        .padding(.horizontal, 4)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(groupList, id: \.self) { group in
                                    Text(group)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .foregroundColor(group == pickedGroupName ? .white : .primary)
                                        .background(group == pickedGroupName ? .blue : .gray.opacity(0.2))
                                        .cornerRadius(4)
                                        .onTapGesture {
                                            pickedGroupName = group
                                            enteredGroupName = ""
                                        }
                                }
                                Text("+ New Group...")
                                    .foregroundColor(pickedGroupName == "+ New Group..." ? .white : .blue)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(pickedGroupName == "+ New Group..." ? .blue : .gray.opacity(0.2))
                                    .cornerRadius(4)
                                    .onTapGesture {
                                        pickedGroupName = "+ New Group..."
                                    }
                                Spacer()
                            }
                            .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                        }
                        if (pickedGroupName == "+ New Group...") {
                            TextField("Enter group name...", text: $enteredGroupName)
                                .font(.title2)
                                .textFieldStyle(.roundedBorder)
                                .padding(.vertical, 8)
                                .focused($isInputActiveSave)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()

                                        Button("Done") {
                                            isInputActiveSave = false
                                        }
                                        .disabled(false)
                                    }
                                }
                                
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding()
                    .onAppear {
                        enteredColorName = passedColorName
                    }
                    
                }
                .navigationBarHidden(true)
            }
        }
        
}
