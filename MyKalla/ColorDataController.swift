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
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data Saved")
        } catch {
            print("Could not save the data")
        }
    }
    
    func addColor(colorName: String, hex: String, r: String, g: String, b: String, context: NSManagedObjectContext) {
        let kallaColor =  KallaCollection(context: context)
        
        kallaColor.id = UUID()
        kallaColor.colorName = colorName
        kallaColor.hex = hex
        kallaColor.r = r
        kallaColor.g = g
        kallaColor.b = b
        
        save(context: context)
    }
}
