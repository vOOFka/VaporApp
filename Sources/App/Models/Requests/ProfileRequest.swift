//
//  ProfileRequest.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

struct ProfileRequest: Content {
    let userProfile: UserProfile
}
