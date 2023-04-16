package pl.edu.uj.projobj

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
class AuthController @Autowired constructor(private val authService: AuthService) {
    data class AuthRequest(val username: String, val password: String)

    val ProductList = listOf(
            Product(1, "prod1", 10),
            Product(2, "prod2", 20)
    )

    @PostMapping("/")
    fun auth(@RequestBody req: AuthRequest): ResponseEntity<String> {
        val isAuthenticated = authService.authenticate(req.username, req.password);
        return if (isAuthenticated == null) {
            ResponseEntity.status(HttpStatus.CONFLICT).body("User is already logged in")
        } else if (isAuthenticated) {
            ResponseEntity.ok("Logged in as ${req.username}");
        } else {
            ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid username or password")
        }
    }

    @GetMapping("/product")
    fun getProducts(): ResponseEntity<List<Product>> {
        if (authService.isLoggedIn()) {
            return ResponseEntity.ok(ProductList);
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(emptyList())
    }

    @GetMapping("/product/{id}")
    fun getProduct(@PathVariable id: Int): ResponseEntity<Product> {
        if (authService.isLoggedIn()) {
            return ResponseEntity.ok(ProductList[id-1]);
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null)
    }
}