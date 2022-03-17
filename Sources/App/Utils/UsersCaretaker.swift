//
//  UsersCaretaker.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Foundation

final class UsersCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "Users"
    
    func save(users: [User]) {
        do {
            let data = try self.encoder.encode(users)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([User].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}
