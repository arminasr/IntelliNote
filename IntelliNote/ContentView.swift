//
//  ContentView.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-20.
//

import SwiftUI

struct ContentView: View {
    @State private var text = "tekstux"
    @State private var notes = ["note 1", "another note", "awesome note", "not so awesome note", "the best note"]
    
    private var columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 1)
    
    var body: some View {
        VStack {
            TextField("Take your note", text: $text)
                .background(Color.red)
             ScrollView {
                 LazyVGrid(columns: columns) {
                    ForEach(notes, id: \.self) { note in
                        Text(note)
                    }
                 }
                 .font(.headline)
             }
            .background(Color.yellow)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
