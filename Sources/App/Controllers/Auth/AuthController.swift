//
//  AuthController.swift
//  
//
//  Created by Home on 23.02.2022.
//

import Vapor

class AuthController {
    func signUp(_ req: Request) -> EventLoopFuture<SignUpResponse> {
        guard let body = try? req.content.decode(SignUpRequest.self) else {
            let response = SignUpResponse(
                result: 0,
                userId: nil,
                userMessage: "Регистрация не прошла!",
                errorMessage: "Поправь прицел и повтори бросок!"
            )
            return req.eventLoop.future(response)
        }
        
        print(body)
        
        let response = SignUpResponse(
            result: 1,
            userId: abs(Int(UUID().uuidString.hash)),
            userMessage: "Регистрация прошла успешно!",
            errorMessage: nil
        )        
        return req.eventLoop.future(response)
    }
}
