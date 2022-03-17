//
//  AuthController.swift
//
//
//  Created by Home on 23.02.2022.
//

import Vapor

final class AuthController {
    // MARK: - Login response
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
    // MARK: - Logout response
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
        if let logoutUser = logoutUser {
            return logoutUser
        }
        return nil
    }
    // MARK: - Handle errors
    private func handleAuthError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<AuthResponse> {
        let response = AuthResponse(
            result: 0,
            errorMessage: message
        )
        return request.eventLoop.future(response)
    }
}
