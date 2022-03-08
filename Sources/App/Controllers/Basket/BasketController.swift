//
//  BasketController.swift
//  
//
//  Created by Home on 08.03.2022.
//

import Vapor

final class BasketController {
    // MARK: - Basket response
    func payBasket(_ req: Request) -> EventLoopFuture<BaseResponse> {
        guard let body = try? req.content.decode(BasketRequest.self) else {
            return handleBasketError(by: req, with: "Поправь прицел и повтори бросок!")
        }
        
        guard checkUser(from: body) != nil else {
            return handleBasketError(by: req, with: "Пользователь не авторизован/ не зарегистрирован!")
        }
        
        guard !body.productsIds.isEmpty else {
            return handleBasketError(by: req, with: "Козина не может быть пустой!")
        }
        
        guard 1...6000 ~= body.totalSumma else {
            return handleBasketError(by: req, with: "Лимит транзакции ограничен 6000 попугаев")
        }
        
        print(body)
        let response = BaseResponse(
            result: 1,
            errorMessage: nil
        )
        return req.eventLoop.future(response)
    }
    
    private func checkUser(from req: BasketRequest) -> User? {
        let caretaker = UsersCaretaker()
        
        let allUsers = caretaker.retrieveUsers()
        let logoutUser = allUsers.first(where: { $0.id == Int(req.userId) })
        if let logoutUser = logoutUser {
            return logoutUser
        }
        return nil
    }

    // MARK: - Handle errors
    private func handleBasketError(by request: Request, with message: String = "Unknown error") -> EventLoopFuture<BaseResponse> {
        let response = BaseResponse(
            result: 0,
            errorMessage: message
        )
        return request.eventLoop.future(response)
    }
}

