//
//  AuthController.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

final class AuthController {
    // MARK: - AuthResponse
    func login(_ req: Request) -> EventLoopFuture<AuthResponse> {
        guard let body = try? req.content.decode(LoginRequest.self) else {
            return handleAuthError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard !body.password.isEmpty,
              body.password.count >= 8 else {
                  return handleAuthError(by: req, with: "Пароль должен быть больше 8ми символов!")
        }
        
        guard let authUser = checkLoginUser(from: body) else {
            return handleAuthError(by: req, with: "Неверный логин/пароль.")
        }
        
        print(body)
        let response = AuthResponse(
            result: 1,
            user: authUser,
            userMessage: "Пользователь успешно авторизован!",
            errorMessage: nil
        )
        return req.eventLoop.future(response)
    }
    
    private func checkLoginUser(from req: LoginRequest) -> User? {
        let loginFromRequest = req.login
        let caretaker = UserProfilesCaretaker()
        
        let allUsersProfiles = caretaker.retrieveUserProfiles()
        let authUser = allUsersProfiles.first(where: { $0.user.login == loginFromRequest })
        //CheckPassword
        if let authUser = authUser,
           authUser.user.password == req.password {
            return authUser.user
        }
        return nil
    }
    
    private func handleAuthError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<AuthResponse> {
        let response = AuthResponse(
            result: 0,
            errorMessage: message
        )
        return request.eventLoop.future(response)
    }
    
    func logout(_ req: Request) -> EventLoopFuture<AuthResponse> {
        guard let body = try? req.content.decode(LogoutRequest.self) else {
            return handleAuthError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard !body.userId.isEmpty else {
            return handleAuthError(by: req, with: "ID не должен быть пустым!")
        }
        
        guard let logoutUser = checkLogotUser(from: body) else {
            return handleAuthError(by: req, with: "Пользователь не авторизован/ не зарегистрирован!")
        }
        
        print(body)
        let response = AuthResponse(
            result: 1,
            user: logoutUser,
            userMessage: "Пользователь успешно разлогинен!",
            errorMessage: nil)
        return req.eventLoop.future(response)
    }
    
    private func checkLogotUser(from req: LogoutRequest) -> User? {
        let caretaker = UserProfilesCaretaker()
        
        let allUsersProfiles = caretaker.retrieveUserProfiles()
        let logoutUser = allUsersProfiles.first(where: { $0.user.id == Int(req.userId) })
        //CheckPassword
        if let logoutUser = logoutUser {
            return logoutUser.user
        }
        return nil
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
        var userProfile = req.userProfile
        userProfile.user.id = id
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
