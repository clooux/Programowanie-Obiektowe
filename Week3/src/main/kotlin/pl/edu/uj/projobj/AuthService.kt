package pl.edu.uj.projobj

import org.springframework.stereotype.Service


@Service
class AuthService {
    private var loggedIn: Boolean = false

    fun authenticate(username: String, password: String): Boolean {
        if (username.isNullOrEmpty() and password.isNullOrEmpty()) {
            loggedIn = true
            return true
        }
        return false
    }

    fun isLoggedIn(): Boolean {
        return loggedIn
    }
}