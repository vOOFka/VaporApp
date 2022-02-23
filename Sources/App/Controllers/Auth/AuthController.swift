//
//  AuthController.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

final class AuthController {
    // MARK: - LoginResponse
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
    
    func handleLoginError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<LoginResponse> {
        let response = LoginResponse(
            result: 0,
            errorMessage: message
        )
        return request.eventLoop.future(response)
    }
    
    // MARK: - SignUpResponse
    func signUp(_ req: Request) -> EventLoopFuture<SignUpResponse> {
        guard let body = try? req.content.decode(SignUpRequest.self) else {
            return handleSignUpError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard !body.password.isEmpty,
              body.password.count >= 8 else {
                  return handleSignUpError(by: req, with: "Пароль должен быть больше 8ми символов!")
              }
        
        print(body)
        let newUser = createNewUser(from: body)
        let response = SignUpResponse(
            result: 1,
            userId: newUser.user.id,
            userMessage: "Регистрация прошла успешно!",
            errorMessage: nil
        )
        return req.eventLoop.future(response)
    }
    
    func createNewUser(from req: SignUpRequest) -> UserProfile {
        let user = User(login: req.login, password: req.password)
        let userProfile = UserProfile(user: user,
                                      name: req.name,
                                      lastname: req.lastname,
                                      email: req.email,
                                      gender: req.gender,
                                      creditCard: req.creditCard,
                                      bio: req.bio)
        return userProfile
    }
    
    func handleSignUpError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<SignUpResponse> {
        let response = SignUpResponse(
            result: 0,
            errorMessage: message
        )
        return request.eventLoop.future(response)
    }
}
