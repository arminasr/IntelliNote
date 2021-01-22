//
//  NotesView.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-20.
//

import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    init(viewModel: NotesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                NoteView(viewModel: viewModel, showingImagePicker: $showingImagePicker)
                List {
                    ForEach(viewModel.notes) { note in
                        NoteRow(note: note)
                    }
                    .onDelete(perform: viewModel.deleteNote)
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            ActivityIndicator(isAnimating: $viewModel.isLoading, style: .large)
        }
        .disabled(viewModel.isLoading)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        viewModel.recognizeText(from: inputImage)
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(viewModel: NotesViewModel())
    }
}
