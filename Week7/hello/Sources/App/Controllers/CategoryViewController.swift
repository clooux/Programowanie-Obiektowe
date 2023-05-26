import Fluent
import Vapor

struct CategoryViewController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("categories")
        // CRUD routes
        categories.get(use: indexView)
        categories.group("create") { category in
            category.get(use: createView)
            // category.post(use: createPostHandler)
        }
        categories.group(":categoryID") { category in
            category.get(use: readView)
            category.get("update", use: updateView)
            // category.post("edit", use: editPostHandler)
            // category.post("delete", use: deleteHandler)
        }
        
    }

    // GET /categories
    func indexView(req: Request) throws -> EventLoopFuture<View> {
        return Category.query(on: req.db).all().flatMap { categories in
            let context = ["categories": categories]
            return req.view.render("Categories/index", context)
        }
    }

    // GET /users/create
    func createView(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("Categories/create")
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
        guard let categoryID = req.parameters.get("categoryID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Category.find(categoryID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                let context = ["category": category]
                return req.view.render("Categories/read", context)
            }
    }
    

    // GET /users/{userID}/edit
    func updateView(req: Request) throws -> EventLoopFuture<View> {
        guard let categoryID = req.parameters.get("categoryID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Category.find(categoryID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                let context = ["category": category]
                return req.view.render("Categories/update", context)
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

// struct ProductFormData: Content {
//     let name: String
//     let description: String
// }