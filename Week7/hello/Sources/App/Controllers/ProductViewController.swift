import Fluent
import Vapor

struct ProductViewController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("products")
        // CRUD routes
        products.get(use: indexView)
        products.group("create") { product in
            product.get(use: createView)
            // product.post(use: createPostHandler)
        }
        products.group(":productID") { product in
            product.get(use: readView)
            product.get("update", use: updateView)
            // product.post("edit", use: editPostHandler)
            // product.post("delete", use: deleteHandler)
        }
        
    }

    // GET /products
    func indexView(req: Request) throws -> EventLoopFuture<View> {
        return Product.query(on: req.db).all().flatMap { products in
            let context = ["products": products]
            return req.view.render("Products/index", context)
        }
    }

    // GET /users/create
    func createView(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("Products/create")
    }

    // POST /users/create
    // func createPostHandler(req: Request) throws -> EventLoopFuture<Response> {
    //     let data = try req.content.decode(UserFormData.self)
    //     let user = User(name: data.name, email: data.email)
        
    //     return user.save(on: req.db).flatMap {
    //         return req.eventLoop.makeSucceededFuture(req.redirect(to: "/users"))
    //     }
    // }

    // GET /users/{userID}
    func readView(req: Request) throws -> EventLoopFuture<View> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Product.find(productID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                let context = ["product": product]
                return req.view.render("Products/read", context)
            }
    }
    

    // GET /users/{userID}/edit
    func updateView(req: Request) throws -> EventLoopFuture<View> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Product.find(productID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                let context = ["product": product]
                return req.view.render("Products/update", context)
            } 
    }

    // POST /users/{userID}/edit
    // func editPostHandler(req: Request) throws -> EventLoopFuture<Response> {
    //     guard let userID = req.parameters.get("userID", as: UUID.self) else {
    //         throw Abort(.badRequest)
    //     }
        
    //     let updatedData = try req.content.decode(UserFormData.self)
        
    //     return User.find(userID, on: req.db).flatMap { user in
    //         guard let user = user else {
    //             throw Abort(.notFound)
    //         }
            
    //         user.name = updatedData.name
    //         user.email = updatedData.email
            
    //         return user.save(on: req.db).flatMap {
    //             return req.eventLoop.makeSucceededFuture(req.redirect(to: "/users/\(userID)"))
    //         }
    //     }
    // }

    // POST /users/{userID}/delete
    // func deleteHandler(req: Request) throws -> EventLoopFuture<Response> {
    //     guard let userID = req.parameters.get("userID", as: UUID.self) else {
    //         throw Abort(.badRequest)
    //     }
        
    //     return User.find(userID, on: req.db).flatMap { user in
    //         guard let user = user else {
    //             throw Abort(.notFound)
    //         }
            
    //         return user.delete(on: req.db).flatMap {
    //             return req.eventLoop.makeSucceededFuture(req.redirect(to: "/users"))
    //         }
    //     }
    // }
}

struct ProductFormData: Content {
    let name: String
    let description: String
}