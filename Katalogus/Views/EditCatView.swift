//
//  EditFoodView.swift
//  SampleCoreData
//
//  Created by Federico on 18/02/2022.
//

import SwiftUI

struct EditCatView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var cat: FetchedResults<Kat>.Element
    
    @State private var name:String = ""
    @State private var ras:String = ""
    @State private var gewicht:Double = 0
    
    var body: some View {
        Form {
            Section() {
                TextField("\(cat.name!)", text: $name)
                    .onAppear {
                        name = cat.name!
                    }
                TextField("\(cat.ras!)", text: $ras)
                    .onAppear {
                        ras = cat.ras!
                    }
                VStack {
                    Text("Gewicht: \(Int(gewicht)) kgs")
                    Slider(value: $gewicht, in: 0...50, step: 1)
                }
                
                HStack {
                    Spacer()
                    Button("Opslaan") {
                        DataController().editCat(cat: cat, name: name, ras: ras, gewicht: gewicht, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}
