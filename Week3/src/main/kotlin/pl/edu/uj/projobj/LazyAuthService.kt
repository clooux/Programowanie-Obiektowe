package pl.edu.uj.projobj

import org.springframework.stereotype.Service


@Service
class LazyAuthService {
    private var loggedIn: Boolean = false

    companion object {
        val instance: LazyAuthService by lazy {
            LazyAuthService()
        }
    }
    fun authenticate(username: String, password: String): Boolean? {
        if (instance.loggedIn) {
            return null
        }
        if (!username.isNullOrEmpty() and !password.isNullOrEmpty()) {
            instance.loggedIn = true
            return true
        }
        return false
    }

    fun isLoggedIn(): Boolean {
        return instance.loggedIn
    }

    fun logout() {
        instance.loggedIn = false
    }
}