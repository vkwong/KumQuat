class User {
    
    var id: Int
    var username: String?
    var email: String?
    var password: String?
    
    init(id: Int, username: String?, email: String?, password: String?) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
    }
}
