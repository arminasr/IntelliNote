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
    @State var activeSheet: ActiveSheet?
    
    init(viewModel: NotesViewModel) {
        self.viewModel = viewModel
    }
    
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
                        loadAudio(with: url)
                    }
                case .imagePicker:
                    ImagePicker { image in
                        loadImage(image)
                    }
                }
            }
            ActivityIndicator(isAnimating: $viewModel.isLoading, style: .large)
        }
        .disabled(viewModel.isLoading)
    }
    
    func loadImage(_ image: UIImage) {
        viewModel.recognizeText(from: image)
    }
    
    func loadAudio(with url: URL) {
        viewModel.recognizeText(from: url)
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(viewModel: NotesViewModel())
    }
}
