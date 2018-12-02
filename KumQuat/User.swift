class User {
    
    var id: Int
    var username: String?
    var email: String?
    var password: String?
    var currentDorm: String?
    var currentCollege: String?
    
    init(id: Int, username: String?, email: String?, password: String?, dorm: String?, college: String?) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.currentDorm = dorm
        self.currentCollege = college
    }
}
