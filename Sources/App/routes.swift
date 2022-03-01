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
    
    app.post("edituser", use: authController.editUserProfile)
    
    let goodsController = GoodsController()
    
    app.post("catalogdata", use: goodsController.getCategory)
    
    app.post("productbyid", use: goodsController.getProductById)
    
    createSomeData()
}

func createSomeData(){
    let careteker = GoodsCaretaker()
    let productFirst = Product(id: 111, name: "Notebook ASUS", price: 3000, description: "Super fast notebook")
    let productSecond = Product(id: 222, name: "Iphone", price: 2000, description: "Great phone")
    let productThierd = Product(id: 333, name: "Notebook Lenovo", price: 2400, description: "Sale")
    let category = ProductCategory(id: 123, goods: [productFirst, productSecond, productThierd])
    
    var allCategories = careteker.retrieveGoodsCategories()
    let existCategory = allCategories.first(where: { $0.id == category.id })
    if existCategory == nil {
        allCategories.append(category)
        careteker.save(goodsCategories: allCategories)
    }
}
