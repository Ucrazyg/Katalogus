import SwiftUI
import CoreData

struct myCat: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var cat: FetchedResults<Kat>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(cat) { cat in
                        NavigationLink(destination: EditCatView(cat: cat)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(cat.name!)
                                        .bold()
                                    Text(cat.ras! + " - " + "Gewicht:" + String(cat.gewicht) + "KG")
                                        .font(.system(size: 12))
                                }
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: deleteCat)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Mijn katten😻")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add cat", systemImage: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddCatView()
            }
        }
        .navigationViewStyle(.stack) // Removes sidebar on iPad
    }
    
    // Deletes food at the current offset
    private func deleteCat(offsets: IndexSet) {
        withAnimation {
            offsets.map { cat[$0] }
            .forEach(managedObjContext.delete)
            
            // Saves to our database
            DataController().save(context: managedObjContext)
        }
    }
}

struct wikiCat : Codable {
    let id: String
    let name: String
    let origin: String
    let description: String
    let life_span: String
    let temperament: String
    let adaptability: Int
    let affection_level: Int
    //let reference_image_id: String
}

struct catWiki: View {
    @State private var cat = [wikiCat]()
    @State private var searchText = ""
    
    var body: some View {
        Section() {
            List(cat, id: \.id) { id in
                NavigationLink(id.name) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Section(){
                                Image("dummy")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .ignoresSafeArea()
                                Text(id.name)
                                    .font(.system(size: 32.0, weight: .bold))
                                    .padding(20)
                                Text(id.description)
                                //Text(id.reference_image_id)
                                    .padding(20)
                                Text("Origin: " + id.origin)
                                    .padding(20)
                                Text("Lifespan: " + id.life_span + " year")
                                    .padding(20)
                                Text("Temperament: " + id.temperament)
                                    .padding(20)
                                Text(String(id.adaptability))
                                    .padding(20)
                                Text(String(id.affection_level))
                                    .padding(20)
                                Spacer()
                            }
                        }
                        .ignoresSafeArea()
                        // Text(id.reference_image_id)
                    }
                }
            }
        }
        .navigationTitle("KatWiki")
        .task {
            await fetchData()
        }
    }
    
//    func catRate(rate: Int) -> Void {
//        if(rate == 1) {
//            return "😻"
//        } else if (rate == 2){
//            return "😻😻"
//        } else if (rate == 3){
//            return "😻😻😻"
//        } else if (rate == 4){
//            return "😻😻😻😻"
//        } else if (rate == 5){
//            return "😻😻😻😻😻"
//        } else {
//            return ""
//        }
//    }
    
    func fetchData() async {
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds?api_key=live_2csXkYff7xTqBRPRVanMHCupJAYdflfBho3yRth1VMEQtukXLYpMQ1GxE0pm7Rq2") else {
            print("Oops")
            return
        }
        
        do {
            let (data, _) =  try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([wikiCat].self, from: data){
                cat = decodedResponse
                print("Helaas1")
            } else {
                print("Helaas2")
            }
        } catch {
            print("Helaas3")
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("De Katalogus😺")
                    .font(.system(size: 32.0, weight: .bold))
                NavigationLink(destination: myCat()) {
                    Image("mycat")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
                NavigationLink(destination: catWiki()) {
                    Image("catwiki")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
            }
            .padding(20)
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        myCat()
    }
}
