//
//  ProfilesController.swift
//
//
//  Created by Home on 02.03.2022.
//

import Vapor

final class ProfilesController {
    // MARK: - SignUp response
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
        if isNotExist {
            allUsers.append(user)
            caretaker.save(users: allUsers)
            return user
        }
        return nil
    }
    // MARK: - Edit profile response
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
    // MARK: - Handle errors
    private func handleProfileError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<ProfileResponse> {
        let response = ProfileResponse(
            result: 0,
            errorMessage: message
        )
        return request.eventLoop.future(response)
    }
}
