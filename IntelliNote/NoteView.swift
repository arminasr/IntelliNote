//
//  NoteView.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-22.
//

import SwiftUI

struct NoteView: View {
    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
        VStack {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
                TextEditor(text: $viewModel.currentNote.text)
                    .border(Color.gray, width: 0.5)
                    .font(.body)
                    .autocapitalization(.words)
                    .padding()
                Button(action: {
                    if !viewModel.currentNote.text.isEmpty {
                        viewModel.saveNote(viewModel.currentNote)
                    }
                },
                label: { Text("✓").padding() })
                .frame(width: 46, height: 46)
                .foregroundColor(Color.white)
                .background(Color.green)
                .clipShape(Circle())
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            })
            HStack(alignment: .center) {
                Button(action: {
                    print("🎤")
                },
                label: { Text("🎤").padding() })
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(12.0)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding()
                Text("Sentiment: \(viewModel.currentNote.sentiment)")
                Button(action: {
                    print("📸")
                },
                label: { Text("📸").padding() })
                .foregroundColor(Color.white)
                .background(Color.orange)
                .cornerRadius(12.0)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .padding()
            }
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(viewModel: NotesViewModel())
    }
}
