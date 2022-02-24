//
//  AuthController.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

final class AuthController {
    // MARK: - AuthResponse
    func login(_ req: Request) -> EventLoopFuture<LoginResponse> {
        guard let body = try? req.content.decode(LoginReqest.self) else {
            return handleLoginError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        print(body)
        let response = LoginResponse(
            result: 1,
            user: nil,
            errorMessage: nil
        )
        return req.eventLoop.future(response)
    }
    
    func logout(_ req: Request) -> EventLoopFuture<LoginResponse> {
        guard let body = try? req.content.decode(LoginReqest.self) else {
            return handleLoginError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        print(body)
        let response = LoginResponse(
            result: 1,
            user: nil,
            errorMessage: nil
        )
        return req.eventLoop.future(response)
    }
    
    private func handleLoginError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<LoginResponse> {
        let response = LoginResponse(
            result: 0,
            errorMessage: message
        )
        return request.eventLoop.future(response)
    }
    
    // MARK: - ProfileResponse
    func signUp(_ req: Request) -> EventLoopFuture<ProfileResponse> {
        guard let body = try? req.content.decode(ProfileRequest.self) else {
            return handleProfileError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard !body.userProfile.user.password.isEmpty,
              body.userProfile.user.password.count >= 8 else {
                  return handleProfileError(by: req, with: "Пароль должен быть больше 8ми символов!")
              }
        
        guard let newUser = createNewUser(from: body) else {
            return handleProfileError(by: req, with: "Такой пользователь уже существует.")
        }
        
        print(body)
        let response = ProfileResponse(
            result: 1,
            userId: newUser.user.id,
            userMessage: "Регистрация прошла успешно!",
            errorMessage: nil
        )
        return req.eventLoop.future(response)
    }
    
    private func createNewUser(from req: ProfileRequest) -> UserProfile? {
        let id = abs(Int(UUID().uuidString.hash))
        var user = req.userProfile.user
        let userProfile = req.userProfile
        user.id = id
        let caretaker = UserProfilesCaretaker()
        
        var allUsersProfiles = caretaker.retrieveUserProfiles()
        let isNotExist = allUsersProfiles.filter {
            $0.email == userProfile.email ||
            $0.user.login == userProfile.user.login ||
            $0.user.id == userProfile.user.id
        }.isEmpty
        //Save
        if isNotExist {
            allUsersProfiles.append(userProfile)
            caretaker.save(profiles: allUsersProfiles)
            //print(allUsersProfiles)
            return userProfile
        }
        return nil
    }
    
    func editProfile(_ req: Request) -> EventLoopFuture<ProfileResponse> {
        guard let body = try? req.content.decode(ProfileRequest.self) else {
            return handleProfileError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard !body.userProfile.user.password.isEmpty,
              body.userProfile.user.password.count >= 8 else {
                  return handleProfileError(by: req, with: "Пароль должен быть больше 8ми символов!")
              }
        
        guard let editUser = editUser(from: body) else {
            return handleProfileError(by: req, with: "Такой пользователь не существует.")
        }
        
        print(body)
        let response = ProfileResponse(
            result: 1,
            userId: editUser.id,
            userMessage: "Изменения прошли успешно!",
            errorMessage: nil
        )
        return req.eventLoop.future(response)
    }
    
    private func editUser(from req: ProfileRequest) -> User? {
        let userProfile = req.userProfile
        let caretaker = UserProfilesCaretaker()
        
        let allUsersProfiles = caretaker.retrieveUserProfiles()
        let userForEdit = allUsersProfiles.first(where: { $0.user.id == userProfile.user.id })
        var otherUsers = allUsersProfiles.filter{ $0.user.id != userProfile.user.id }
        //Edit
        if userForEdit != nil {
            otherUsers.append(userProfile)
            caretaker.save(profiles: otherUsers)
            //print(otherUsers)
            return userProfile.user
        }
        return nil
    }
    
    private func handleProfileError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<ProfileResponse> {
        let response = ProfileResponse(
            result: 0,
            errorMessage: message
        )
        return request.eventLoop.future(response)
    }
}
