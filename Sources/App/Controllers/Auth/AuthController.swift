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
    
    func handleLoginError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<LoginResponse> {
        let response = LoginResponse(
            result: 0,
            errorMessage: message
        )
        return request.eventLoop.future(response)
    }
    
    // MARK: - ProfileResponse
    func signUp(_ req: Request) -> EventLoopFuture<ProfileResponse> {
        guard let body = try? req.content.decode(SignUpRequest.self) else {
            return handleProfileError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard !body.password.isEmpty,
              body.password.count >= 8 else {
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
    
    func createNewUser(from req: SignUpRequest) -> UserProfile? {
        let user = User(login: req.login, password: req.password)
        let userProfile = UserProfile(user: user,
                                      name: req.name,
                                      lastname: req.lastname,
                                      email: req.email,
                                      gender: req.gender,
                                      creditCard: req.creditCard,
                                      bio: req.bio)
        let caretaker = UserProfilesCaretaker()
        
        var allUsers = caretaker.retrieveUserProfiles()
        let isNotExist = allUsers.filter{ $0.email == userProfile.email || $0.user.login == userProfile.user.login}.isEmpty
        //Save
        if isNotExist {
            allUsers.append(userProfile)
            caretaker.save(profiles: allUsers)
            print(allUsers)
            return userProfile
        }
        return nil
    }
    
    func editProfile(_ req: Request) -> EventLoopFuture<ProfileResponse> {
        guard let body = try? req.content.decode(ProfileRequest.self) else {
            return handleProfileError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard !body.user.password.isEmpty,
              body.user.password.count >= 8 else {
                  return handleProfileError(by: req, with: "Пароль должен быть больше 8ми символов!")
              }
        
        print(body)
        //   let editUser = editUser(from: body)
        let response = ProfileResponse(
            result: 1,
            //       userId: editUser.user.id,
            userMessage: "Изменения прошли успешно!",
            errorMessage: nil
        )
        return req.eventLoop.future(response)
    }
    
    //    func editUser(from req: ProfileRequest) -> User {
    //        let user = User(login: req.login, password: req.password)
    //        let userProfile = UserProfile(user: user,
    //                                      name: req.name,
    //                                      lastname: req.lastname,
    //                                      email: req.email,
    //                                      gender: req.gender,
    //                                      creditCard: req.creditCard,
    //                                      bio: req.bio)
    //        return userProfile
    //    }
    
    func handleProfileError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<ProfileResponse> {
        let response = ProfileResponse(
            result: 0,
            errorMessage: message
        )
        return request.eventLoop.future(response)
    }
}
