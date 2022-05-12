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
    
    func addColor(colorName: String, hex: String, r: Int, g: Int, b: Int, group: String, context: NSManagedObjectContext) {
        let kallaColor =  KallaCollection(context: context)
        
        kallaColor.id = UUID()
        kallaColor.colorName = colorName
        kallaColor.hex = hex
        kallaColor.r = Int16(r)
        kallaColor.g = Int16(g)
        kallaColor.b = Int16(b)
        kallaColor.group = group
        
        print("\(hex)")
        save(context: context)
    }
}
