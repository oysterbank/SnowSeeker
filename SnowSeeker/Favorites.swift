//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Kris Laratta on 12/26/22.
//

import SwiftUI

class Favorites: ObservableObject {
    // the resorts the user has favorited
    private var resorts: Set<String>
    
    // the key we're using to read/write to UserDefaults
    private let saveKey = "Favorites"
    
    init() {
        // load our saved data
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                resorts = decoded
                return
            }
        }
        
        // still here? use an empty array
        resorts = []
    }
    
    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    // adds the resort to our set, updates all views, and saves the changes
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    // removes the resort from our set, updates all views, and saves the changes
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        // write out our data
        if let encoded = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
