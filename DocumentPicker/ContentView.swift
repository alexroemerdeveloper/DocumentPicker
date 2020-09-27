//
//  ContentView.swift
//  DocumentPicker
//
//  Created by Alexander Römer on 26.09.20.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    
    @State private var fileName = ""
    @State private var openFile = false
    @State private var saveFile = false

    var body: some View {
        VStack {
            Text(fileName)
                .fontWeight(.bold)
            
            Button(action: {
                openFile.toggle()
            }, label: {
                Text("Open")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 35)
                    .background(Color.blue)
                    .clipShape(Capsule())
            })
            
            Button(action: {
                saveFile.toggle()
            }, label: {
                Text("Save")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 35)
                    .background(Color.blue)
                    .clipShape(Capsule())
            })
        }
        .fileImporter(isPresented: self.$openFile, allowedContentTypes: [.pdf]) { (result) in
            do {
                let fileURL = try result.get()
                self.fileName = fileURL.lastPathComponent
            } catch {
                print(error.localizedDescription)
            }
        }
        .fileExporter(isPresented: self.$saveFile, document: DocumentManager(url: Bundle.main.path(forResource: "LiftYouUp", ofType: "m4r")!), contentType: .audio) { (result) in
            do {
                let fileURL = try result.get()
                print(fileURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

struct DocumentManager: FileDocument {
    var url: String
    static var readableContentTypes: [UTType] { [.audio] }
    
    init(url: String)  {
        self.url = url
    }
    
    init(configuration: ReadConfiguration) throws {
        url = ""
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let file = try! FileWrapper(url: URL(fileURLWithPath: url), options: .immediate)
        return file
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
