//
//  LocalNotesStore.swift
//  Lounit
//
//  Created by Codex on 2026/6/9.
//

import UIKit

enum LocalNotesStore {
    private struct StoredNote: Codable {
        let id: String
        let ownerMail: String
        let createdAt: TimeInterval
        let text: String
        let imageFileNames: [String]
    }

    private static let storageKey = "lounit.notes.localEntries"
    private static let notesDirectoryName = "LocalNotes"

    static func save(text: String, image: UIImage) throws {
        let noteID = UUID().uuidString
        let imageFileName = "\(noteID).jpg"
        try saveImage(image, fileName: imageFileName)

        let note = StoredNote(
            id: noteID,
            ownerMail: currentOwnerMail,
            createdAt: Date().timeIntervalSince1970,
            text: text,
            imageFileNames: [imageFileName]
        )

        var notes = loadStoredNotes()
        notes.insert(note, at: 0)
        try saveStoredNotes(notes)
    }

    static func entries() -> [NotesEntry] {
        loadStoredNotes()
            .filter { $0.ownerMail == currentOwnerMail }
            .map { note in
                NotesEntry(
                    date: dateString(from: Date(timeIntervalSince1970: note.createdAt)),
                    text: note.text,
                    imageFileURLs: note.imageFileNames.map { notesDirectoryURL.appendingPathComponent($0) }
                )
            }
    }

    private static var currentOwnerMail: String {
        AuthSession.currentMail ?? "guest"
    }

    private static var notesDirectoryURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(notesDirectoryName, isDirectory: true)
    }

    private static func saveImage(_ image: UIImage, fileName: String) throws {
        try FileManager.default.createDirectory(
            at: notesDirectoryURL,
            withIntermediateDirectories: true
        )

        guard let imageData = image.jpegData(compressionQuality: 0.86) else {
            throw NSError(
                domain: "LocalNotesStore",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Unable to encode note image."]
            )
        }

        try imageData.write(to: notesDirectoryURL.appendingPathComponent(fileName), options: .atomic)
    }

    private static func loadStoredNotes() -> [StoredNote] {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let notes = try? JSONDecoder().decode([StoredNote].self, from: data)
        else {
            return []
        }
        return notes
    }

    private static func saveStoredNotes(_ notes: [StoredNote]) throws {
        let data = try JSONEncoder().encode(notes)
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private static func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}
