//
//  NotesView.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-20.
//

import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel
    
    init(viewModel: NotesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            TextField("Take a note",
                      text: $viewModel.currentNote.text,
                      onCommit: {
                        viewModel.saveNote(viewModel.currentNote)
                      })
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .topLeading)
                .background(Color.red)
            List {
                ForEach(viewModel.notes) { note in
                    Text(note.title)
                }
                .onDelete(perform: viewModel.deleteNote)
            }
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(viewModel: NotesViewModel())
    }
}
