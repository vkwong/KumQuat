class Post {
    
    var id: Int
    var author: String?
    var content: String?
    var dorm: String?
    var college: String?
    var locationShared: Bool
    var isAnon: Bool
    var parent_post: Int
    
    init(id: Int, author: String?, content: String?, dorm: String?, college: String?, locationShared: Bool, isAnon: Bool, parent_post: Int) {
        self.id = id
        self.author = author
        self.content = content
        self.dorm = dorm
        self.college = college
        self.locationShared = locationShared
        self.isAnon = isAnon
        self.parent_post = parent_post
    }
}
