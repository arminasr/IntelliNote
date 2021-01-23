//
//  NoteView.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-22.
//

import SwiftUI

struct NoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Binding var activeSheet: ActiveSheet?
    
    var body: some View {
        VStack {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
                TextEditor(text: $viewModel.currentNote.text)
                    .border(Color.gray, width: 0.5)
                    .font(.body)

                    .disableAutocorrection(true)
                    .padding()
                
                Button(
                    action: {
                        if !viewModel.currentNote.text.isEmpty {
                            viewModel.saveNote(viewModel.currentNote)
                        }
                    },
                    label: { Text("✓").padding() })
                    .frame(width: 46, height: 46)
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            })
            HStack(alignment: .center) {
                Button(
                    action: {
                        activeSheet = .audioPicker
                    },
                    label: {
                        Text("🎤").padding()
                    })
                    .background(Color.blue)
                    .buttonStyle()
                if let language = viewModel.currentNote.language {
                    Text("Language: \(language)")
                }
                
                Button(
                    action: {
                        activeSheet = .imagePicker
                    },
                    label: { Text("📸").padding() })
                    .background(Color.orange)
                    .buttonStyle()
            }
            .animation(.easeInOut)
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(viewModel: NotesViewModel(),
                 activeSheet: .constant(nil))
    }
}
