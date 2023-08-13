//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Paul Hudson on 25/01/2022.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

class Favorites: ObservableObject {
    private var resorts: Set<String>
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedFavorites")

    init() {
        do {
            let data = try Data(contentsOf: savePath)
            resorts = try JSONDecoder().decode(Set<String>.self, from: data)
        } catch {
           resorts = []
        }
    }

    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(resorts)
            try data.write(to: savePath, options: [.completeFileProtection, .atomic])
        } catch {
            print("Failed to save data.")
        }
    }
}
