//
//  UserProfilesCaretaker.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Foundation

final class UserProfilesCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "UserProfiles"
    
    func save(profiles: [UserProfile]) {
        do {
            let data = try self.encoder.encode(profiles)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveUserProfiles() -> [UserProfile] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([UserProfile].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}
