//
//  Utilities.swift
//  Quick News Tests
//
//  Created by Chatsopon Deepateep on 14/6/2565 BE.
//

import Foundation

/// return the document directory url
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

/// return the subfolder in document directory url If it never existed, create a new one.
func getDirectoryInDocuments(folder name: String) -> URL? {
    var isdirectory : ObjCBool = true
    let docDirectory = getDocumentsDirectory()
    let directory = docDirectory.appendingPathComponent(name)
    if !FileManager.default.fileExists(atPath: directory.path, isDirectory: &isdirectory) {
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
    }
    return directory
}

var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.doesRelativeDateFormatting = true
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
