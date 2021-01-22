//
//  NoteRow.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-22.
//

import SwiftUI

struct NoteRow: View {
    var note: Note
    
    var body: some View {
        Text(note.text)
    }
}

struct NoteRow_Previews: PreviewProvider {
    static var previews: some View {
        NoteRow(note: Note())
    }
}
