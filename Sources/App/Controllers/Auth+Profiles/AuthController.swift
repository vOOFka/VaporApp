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
        let caretaker = UsersCaretaker()
        
        let allUsers = caretaker.retrieveUsers()
        let authUser = allUsers.first(where: { $0.login == loginFromRequest })
        //CheckPassword
        if let authUser = authUser,
           authUser.password == req.password {
            return authUser
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
        let caretaker = UsersCaretaker()
        
        let allUsers = caretaker.retrieveUsers()
        let logoutUser = allUsers.first(where: { $0.id == Int(req.userId) })
        //CheckPassword
        if let logoutUser = logoutUser {
            return logoutUser
        }
        return nil
    }
    
    // MARK: - ProfileResponse
    func signUp(_ req: Request) -> EventLoopFuture<ProfileResponse> {
        guard let body = try? req.content.decode(ProfileRequest.self) else {
            return handleProfileError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard !body.user.password.isEmpty,
              body.user.password.count >= 8 else {
                  return handleProfileError(by: req, with: "Пароль должен быть больше 8ми символов!")
        }
        
        guard let newUser = createNewUser(from: body) else {
            return handleProfileError(by: req, with: "Такой пользователь уже существует.")
        }
        
        print(body)
        let response = ProfileResponse(
            result: 1,
            userId: newUser.id,
            userMessage: "Регистрация прошла успешно!",
            errorMessage: nil
        )
        return req.eventLoop.future(response)
    }
    
    private func createNewUser(from req: ProfileRequest) -> User? {
        var user = req.user
        user.id = abs(Int(UUID().uuidString.hash))
        let caretaker = UsersCaretaker()
        
        var allUsers = caretaker.retrieveUsers()
        let isNotExist = allUsers.filter {
            $0.userProfile.email == user.userProfile.email ||
            $0.login == user.login ||
            $0.id == user.id
        }.isEmpty
        //Save
        if isNotExist {
            allUsers.append(user)
            caretaker.save(users: allUsers)
            return user
        }
        return nil
    }
    
    func editUserProfile(_ req: Request) -> EventLoopFuture<ProfileResponse> {
        guard let body = try? req.content.decode(ProfileRequest.self) else {
            return handleProfileError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard !body.user.password.isEmpty,
              body.user.password.count >= 8 else {
                  return handleProfileError(by: req, with: "Пароль должен быть больше 8ми символов!")
        }
        
        guard let editUser = getEditUser(from: body) else {
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
    
    private func getEditUser(from req: ProfileRequest) -> User? {
        let user = req.user
        let caretaker = UsersCaretaker()
        
        let allUsers = caretaker.retrieveUsers()
        let userForEdit = allUsers.first(where: { $0.id == user.id })
        var otherUsers = allUsers.filter{ $0.id != user.id }
        //Edit
        if userForEdit != nil {
            otherUsers.append(user)
            caretaker.save(users: otherUsers)
            return user
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
