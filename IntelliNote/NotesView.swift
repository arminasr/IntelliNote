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
            NoteView(viewModel: viewModel)
            List {
                ForEach(viewModel.notes) { note in
                    NoteRow(note: note)
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
