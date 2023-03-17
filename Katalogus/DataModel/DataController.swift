import Foundation
import CoreData

class DataController: ObservableObject {
    // Responsible for preparing a model
    let container = NSPersistentContainer(name: "KatModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load data in DataController \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved successfully. WUHU!!!")
        } catch {
            // Handle errors in our database
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addCat(name: String, ras: String, gewicht: Double, context: NSManagedObjectContext) {
        let kat = Kat(context: context)
        kat.id = UUID()
        kat.ras = ras
        kat.gewicht = gewicht
        kat.name = name
        
        save(context: context)
    }
    
    func editCat(cat: Kat, name: String, ras: String, gewicht: Double, context: NSManagedObjectContext) {
        cat.name = name
        cat.ras = ras
        cat.gewicht = gewicht
        
        save(context: context)
    }
}
