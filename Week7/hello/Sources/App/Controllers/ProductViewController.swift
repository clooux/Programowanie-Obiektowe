import Fluent
import Vapor

struct ProductViewController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("products")

        products.get(use: indexView)
        products.group("create") { product in
            product.get(use: createView)
            product.post(use: createHandler)
        }
        products.group(":productID") { product in
            product.get(use: readView)
            product.get("update", use: updateView)
            product.post("update", use: updateHandler)
            product.post("delete", use: deleteHandler)
        }
        
    }

    func indexView(req: Request) throws -> EventLoopFuture<View> {
        return Product.query(on: req.db).with(\.$category).all().flatMap { products in
            let context = ["products": products]
            return req.view.render("Products/index", context)
        }
    }

    func createView(req: Request) throws -> EventLoopFuture<View> {
        return Category.query(on: req.db).all().flatMap { categories in
            let context = ["categories": categories]
            return req.view.render("Products/create", context)
        }
    }

    func createHandler(req: Request) throws -> EventLoopFuture<Response> {
        let data = try req.content.decode(ProductFormData.self)
        let product = Product(name: data.name, price: data.price, categoryID: data.categoryID)
        
        return product.save(on: req.db).flatMap {
            return req.eventLoop.makeSucceededFuture(req.redirect(to: "/products"))
        }
    }

    func readView(req: Request) throws -> EventLoopFuture<View> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Product.query(on: req.db)
            .filter(\.$id == productID)
            .with(\.$category)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                let context = ["product": product]
                return req.view.render("Products/read", context)
            }
    }
    
    func updateView(req: Request) throws -> EventLoopFuture<View> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        let categories = Category.query(on: req.db).all()

        let product = Product.find(productID, on: req.db).unwrap(or: Abort(.notFound))
            
        return product.and(categories).flatMap { product, categories in
                let context = UpdateViewModel(product: product, categories: categories)
                return req.view.render("Products/update", context)
        } 
    }

    func updateHandler(req: Request) throws -> EventLoopFuture<Response> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let updatedData = try req.content.decode(ProductFormData.self)
        
        return Product.find(productID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.name = updatedData.name
                product.price = updatedData.price
                product.$category.id = updatedData.categoryID
                
                return product.save(on: req.db).flatMap {
                    return req.eventLoop.makeSucceededFuture(req.redirect(to: "/products/\(productID)"))
                }
        }
    }


    func deleteHandler(req: Request) throws -> EventLoopFuture<Response> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return Product.find(productID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                return product.delete(on: req.db).flatMap {
                    return req.eventLoop.makeSucceededFuture(req.redirect(to: "/products"))
                }
        }
    }
}

struct ProductFormData: Content {
    let name: String
    let price: Int
    let categoryID: UUID
}

struct UpdateViewModel: Encodable {
    let product: Product
    let categories: [Category]
}