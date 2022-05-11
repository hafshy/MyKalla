//
//  ColorDataController.swift
//  MyKalla
//
//  Created by Hafshy Yazid Albisthami on 11/05/22.
//

import CoreData
import Foundation

class ColorDataController: ObservableObject {
    let container = NSPersistentContainer(name: "ColorCollection")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Coredata failed to load: \(error.localizedDescription)")
            }
        }
    }
}
