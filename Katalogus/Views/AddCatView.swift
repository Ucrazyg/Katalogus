//
//  AddFoodView.swift
//  SampleCoreData
//
//  Created by Federico on 18/02/2022.
//

import SwiftUI

struct AddCatView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var ras: String = ""
    @State private var gewicht: Double = 0
    
    var body: some View {
        Form {
            Section() {
                Spacer()
                TextField("Naam", text: $name)
                TextField("Ras", text: $ras)
                VStack {
                    Text("Gewicht: \(Int(gewicht)) kgs")
                    Slider(value: $gewicht, in: 0...50, step: 1)
                }
                HStack {
                    Spacer()
                    Button("Opslaan") {
                        DataController().addCat(
                            name: name,
                            ras: ras,
                            gewicht: gewicht,
                            context: managedObjContext)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddCatView_Previews: PreviewProvider {
    static var previews: some View {
        AddCatView()
    }
}
