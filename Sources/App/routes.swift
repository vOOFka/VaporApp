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
    
    let profilesController = ProfilesController()
    
    app.post("signup", use: profilesController.signUp)
    
    app.post("editprofile", use: profilesController.editUserProfile)
    
    let goodsController = GoodsController()
    
    app.post("catalogdata", use: goodsController.getCategory)
    
    app.post("productbyid", use: goodsController.getProductById)
    
    let feedbacksController = FeedbacksController()
    
    app.post("getfeedbacks", use: feedbacksController.getProductFeedbacks)
    
    app.post("addfeedback", use: feedbacksController.addFeedback)
    
    app.post("removefeedback", use: feedbacksController.removeFeedback)
    
    createSomeData()
}

func createSomeData(){
    let usersCaretaker = UsersCaretaker()
    let exampleProfile = UserProfile(name: "Test",
                                     lastname: "Testov",
                                     email: "test@test.ru",
                                     gender: "m",
                                     creditCard: "1234-4444-5555-6666",
                                     bio: "I was born in Great Britan...")
    let exampleUser = User(id: 123, login: "Test", password: "qwerty123", userProfile: exampleProfile)
    
    var allUsers = usersCaretaker.retrieveUsers()
    let existUser = allUsers.first(where: { $0.id == exampleUser.id })
    
    if existUser == nil {
        allUsers.append(exampleUser)
        usersCaretaker.save(users: allUsers)
    }
    
    let goodsCareteker = GoodsCaretaker()
    
    let feedbacks = [Feedback(id: 444, userId: 123, comment: "Отличный товар!"),
                     Feedback(id: 555, userId: 321, comment: "Very well product!"),
                     Feedback(id: 666, userId: 567, comment: "Nice!")]
    
    let productFirst = Product(id: 111, name: "Notebook ASUS", price: 3000, description: "Super fast notebook", feedbacks: feedbacks)
    let productSecond = Product(id: 222, name: "Iphone", price: 2000, description: "Great phone", feedbacks: feedbacks)
    let productThierd = Product(id: 333, name: "Notebook Lenovo", price: 2400, description: "Sale", feedbacks: feedbacks)
    let productFourth = Product(id: 444, name: "Ipad", price: 1400, description: "Gift ++", feedbacks: feedbacks)
    let category = ProductCategory(id: 321, goods: [productFirst, productSecond, productThierd, productFourth])
    
    var allCategories = goodsCareteker.retrieveGoodsCategories()
    let existCategory = allCategories.first(where: { $0.id == category.id })
    
    if existCategory == nil {
        allCategories.append(category)
        goodsCareteker.save(goodsCategories: allCategories)
    }
    //    allCategories.removeAll()
    //    goodsCareteker.save(goodsCategories: allCategories)
}
