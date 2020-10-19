//
//  UserSessionCaretaker.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import Foundation

class UserSessionCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "userSessionCaretakerKey"
    
    func save(session: UserSession) {
        do {
            let data = try encoder.encode(session)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load() -> UserSession {
        
        guard let data = UserDefaults.standard.data(forKey: key) else { return UserSession() }
        
        do {
            return try decoder.decode(UserSession.self, from: data)
        } catch {
            print(error.localizedDescription)
            return UserSession()
        }
        
    }
}
