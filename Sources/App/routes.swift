import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    let authController = AuthController()

    app.post("login", use: authController.login)
    
    app.post("logout", use: authController.logout)
        
    app.post("signup", use: authController.signUp)
    
    app.post("editprofile", use: authController.editProfile)
    
    let goodsController = GoodsController()
    
    app.post("catalogdata", use: goodsController.getCategory)
}
