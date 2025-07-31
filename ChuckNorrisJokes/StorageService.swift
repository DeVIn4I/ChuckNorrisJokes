//
//  StorageService.swift
//  ChuckNorrisJokes
//
//  Created by Razumov Pavel on 31.07.2025.
//

import Foundation
import RealmSwift

class JokeObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var value: String
    @Persisted var categories: List<String>
    @Persisted var createdAt: Date
    
    convenience init(from joke: Joke) {
        self.init()
        self.id = joke.id
        self.value = joke.value
        self.categories.append(objectsIn: joke.categories)
        self.createdAt = Date()
    }
}

class JokeCategoryObject: Object {
    @Persisted(primaryKey: true) var name: String
    @Persisted var jokes = List<JokeObject>()
}

final class StorageService {
    
    static let shared = StorageService()
    private init() {}
    
    private let realm = try! Realm()
    
    func saveToRealm(_ joke: Joke) {
        let jokeObject = JokeObject(from: joke)
        let categoryNames = joke.categories.isEmpty ? ["no category"] : joke.categories
        
        try! realm.write {
            for name in categoryNames {
                if !jokeObject.categories.contains(name) {
                    jokeObject.categories.append(name)
                }
            }
            
            realm.add(jokeObject, update: .modified)
            
            for name in categoryNames {
                let category = realm.object(ofType: JokeCategoryObject.self, forPrimaryKey: name) ?? JokeCategoryObject()
                if category.name.isEmpty {
                    category.name = name
                }
                
                if !category.jokes.contains(where: { $0.id == jokeObject.id }) {
                    category.jokes.append(jokeObject)
                }
                realm.add(category, update: .modified)
            }
        }
    }
    
    func getDownloadJokes() -> [JokeObject] {
        Array(realm.objects(JokeObject.self).sorted(byKeyPath: "createdAt", ascending: false))
    }
    
    func getAllCategories() -> [JokeCategoryObject] {
        Array(realm.objects(JokeCategoryObject.self).sorted(byKeyPath: "name"))
    }
    
    func getJokes(from category: JokeCategoryObject) -> [JokeObject] {
        Array(realm.objects(JokeObject.self)
            .filter("ANY categories == %@", category.name)
            .sorted(byKeyPath: "createdAt", ascending: false))
    }
    
    func resetRealm() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
