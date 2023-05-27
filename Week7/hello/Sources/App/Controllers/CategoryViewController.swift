import Fluent
import Vapor

struct CategoryViewController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("categories")

        categories.get(use: indexView)
        categories.group("create") { category in
            category.get(use: createView)
            category.post(use: createHandler)
        }
        categories.group(":categoryID") { category in
            category.get(use: readView)
            category.get("update", use: updateView)
            category.post("update", use: updateHandler)
            category.post("delete", use: deleteHandler)
        }
        
    }

    func indexView(req: Request) throws -> EventLoopFuture<View> {
        return Category.query(on: req.db).all().flatMap { categories in
            let context = ["categories": categories]
            return req.view.render("Categories/index", context)
        }
    }

    func createView(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("Categories/create")
    }

    func createHandler(req: Request) throws -> EventLoopFuture<Response> {
        let data = try req.content.decode(CategoryFormData.self)
        let category = Category(name: data.name, description: data.description)
        
        return category.save(on: req.db).flatMap {
            return req.eventLoop.makeSucceededFuture(req.redirect(to: "/categories"))
        }
    }

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

    func updateHandler(req: Request) throws -> EventLoopFuture<Response> {
        guard let categoryID = req.parameters.get("categoryID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let updatedData = try req.content.decode(CategoryFormData.self)
        
        return Category.find(categoryID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                category.name = updatedData.name
                category.description = updatedData.description
                
                return category.save(on: req.db).flatMap {
                    return req.eventLoop.makeSucceededFuture(req.redirect(to: "/categories/\(categoryID)"))
                }
        }
    }

    func deleteHandler(req: Request) throws -> EventLoopFuture<Response> {
        guard let categoryID = req.parameters.get("categoryID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Category.find(categoryID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                return category.delete(on: req.db).flatMap {
                    return req.eventLoop.makeSucceededFuture(req.redirect(to: "/categories"))
                }
        }
    }
}

struct CategoryFormData: Content {
    let name: String
    let description: String
}