//
//  NotesView.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-20.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case imagePicker, audioPicker
    
    var id: Int {
        hashValue
    }
}

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        ZStack {
            VStack {
                NoteView(viewModel: viewModel,
                         activeSheet: $activeSheet)
                List {
                    ForEach(viewModel.notes) { note in
                        NoteRow(note: note)
                    }
                    .onDelete(perform: viewModel.deleteNote)
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .audioPicker:
                    PickerView { url in
                        viewModel.recognizeText(from: url)
                    }
                case .imagePicker:
                    ImagePicker { image in
                        viewModel.recognizeText(from: image)
                    }
                }
            }
            ActivityIndicator(isAnimating: $viewModel.isLoading, style: .large)
        }
        .disabled(viewModel.isLoading)
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(viewModel: NotesViewModel())
    }
}
