//
//  dbHandler.swift
//  database_demo
//
//  function:
//      insertData()
//      readUsers()
//      update()
//
//  Created by Richard Kong on 11/19/18.
//  Copyright © 2018 Richard Kong. All rights reserved.
//

import Foundation
import SQLite3

class DBHandler: NSObject {
    static var DATABASE_NAME: String = "kumquatDB.sqlite"
    static var TBL_USER: String = " Users"
    static var TBL_POST: String = " Posts"
    static var TBL_VOTE: String = " Votes"
    
    static var USERNAME: String = " username"
    static var PASSWORD: String = " password"
    static var EMAIL: String = " email"
    
    static var AUTHOR: String = "author"
    static var CONTENT: String = "content"
    static var DORM: String = "dorm"
    static var COLLEGE: String = "college"
    static var LOCATION_SHARED: String = "locationShared"
    static var IS_ANON: String = "isAnon"
    static var PARENT_POST: String = "parent_post"
    
    static var POST: String = " post"
    static var USER: String = " user"
    static var SCORE: String = " score"
    
    static var CREATE_USERS_TABLE: String = "CREATE TABLE IF NOT EXISTS" + TBL_USER + " (id INTEGER PRIMARY KEY AUTOINCREMENT," + USERNAME + " TEXT UNIQUE NOT NULL," + PASSWORD + " TEXT NOT NULL," + EMAIL + " TEXT UNIQUE NOT NULL);"
    static var CREATE_POSTS_TABLE: String = "CREATE TABLE IF NOT EXISTS" + TBL_POST + " (id INTEGER PRIMARY KEY AUTOINCREMENT," + AUTHOR + " STRING REFERENCES" + TBL_USER + "(id)," + CONTENT + " STRING NOT NULL," + DORM + " STRING NOT NULL," + COLLEGE + " STRING NOT NULL," + LOCATION_SHARED + " BOOLEAN," + IS_ANON + " BOOLEAN," + PARENT_POST + " INTEGER" + ");"
    static var CREATE_VOTES_TABLE: String = "CREATE TABLE IF NOT EXISTS" + TBL_VOTE + "(" + POST + "INTEGER PRIMARY KEY REFERENCES" + TBL_POST + " (id)," + USER + " INTEGER REFERENCES" + TBL_USER + " (id)," + SCORE + " INTEGER);"

    override init() {
        super.init()
        createDataBase()
        createTable()
    }
    
    // define database
    var db: OpaquePointer? = nil
    
    // create database
    func createDataBase(){
        //path
        guard let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else{
            return
        }
        print("\(path)")
        
        let filePath = (path as NSString).appendingPathComponent(DBHandler.DATABASE_NAME)
        guard let cFilePath = filePath.cString (using: String.Encoding.utf8) else{
            return
        }
        
        sqlite3_open(cFilePath, &db)
    }
    
    // create table
    func createTable(){
        if execSQL(sql: DBHandler.CREATE_USERS_TABLE) && execSQL(sql: DBHandler.CREATE_POSTS_TABLE) && execSQL(sql: DBHandler.CREATE_VOTES_TABLE) {
            print("Kumquat db Users, Posts, and Votes tables are all set, woohoo!")
        } else {
            print("fail to create database table")
        }
    }
    
    func execSQL(sql: String)->Bool{
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK{
            return false
        }
        return true
    }
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    func insertData(username: String, password: String, email: String)->Bool{
        //let arr = readUsers(condition: username)
        
        //if arr.isEmpty {
        
            let sql = "INSERT INTO" + DBHandler.TBL_USER + " (" + DBHandler.USERNAME + "," + DBHandler.PASSWORD + "," + DBHandler.EMAIL + ") VALUES (?, ?, ?);"

            guard let csql = sql.cString(using: String.Encoding.utf8) else{
                return false
            }
            
            var stmt: OpaquePointer? = nil
            
            // compile sql
            if  sqlite3_prepare_v2(db, csql, -1, &stmt, nil) != SQLITE_OK{
                return false
            }
            
            sqlite3_bind_text(stmt, 1, username.cString(using: String.Encoding.utf8), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 2, password.cString(using: String.Encoding.utf8), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 3, email.cString(using: String.Encoding.utf8), -1, SQLITE_TRANSIENT)
            
            if sqlite3_step(stmt) != SQLITE_DONE{
                return false
            }
            
            // close
            sqlite3_finalize(stmt)
            
            return true
        //}
        //else {
        //    print("Username has existed!")
        //    return false
        //}
    }
    
    //adds a new post to the database
    func createPost(author: String, content: String, dorm: String, college: String, locationShared: Bool, isAnon: Bool, parent_post: Int) -> Bool {
        
        let sql = """
            INSERT INTO \(DBHandler.TBL_POST)
            (\(DBHandler.AUTHOR), \(DBHandler.CONTENT), \(DBHandler.DORM), \(DBHandler.COLLEGE), \(DBHandler.LOCATION_SHARED), \(DBHandler.IS_ANON), \(DBHandler.PARENT_POST))
            VALUES (?, ?, ?, ?, ?, ?, ?);
        """
    
        
        guard let csql = sql.cString(using: String.Encoding.utf8) else{
            print("fail 1")
            return false
        }
        
        var stmt: OpaquePointer? = nil
        
        // prepare sql
        if  sqlite3_prepare_v2(db, csql, -1, &stmt, nil) != SQLITE_OK{
            print("fail 2")
            return false
        }
        
        //convert booleans to ints
        let sharedLocationInt: Int32 = locationShared ? 1:0
        let isAnonInt: Int32 = isAnon ? 1:0
        
        //bind parameters
        sqlite3_bind_text(stmt, 1, author.cString(using: String.Encoding.utf8), -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, content.cString(using: String.Encoding.utf8), -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, dorm.cString(using: String.Encoding.utf8), -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 4, college.cString(using: String.Encoding.utf8), -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 5, sharedLocationInt)
        sqlite3_bind_int(stmt, 6, isAnonInt)
        sqlite3_bind_int64(stmt, 7, Int64(parent_post))
        
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            print("fail 3")
            return false
        }
        
        // close
        sqlite3_finalize(stmt)
        
        return true
        
    }
    
    //returns an array containing every single post in the Post table (for testing purposes only)
    func getAllPosts() -> [Post] {
        let sql = "SELECT * FROM \(DBHandler.TBL_POST)"
        var posts = [Post]()
        
        //sqlite3_stmt pointer
        var stmt:OpaquePointer? = nil
        
        // compiler
        let prepare_result = sqlite3_prepare(self.db, sql, -1, &stmt, nil)
        if prepare_result != SQLITE_OK {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(self.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(sql)"
                print(msg)
            }
        }
        
        //store results of each row 
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let author = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 1)))
            let content = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 2)))
            let dorm = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 3)))
            let college = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 4)))
            let locationShared = sqlite3_column_int(stmt, 5)
            let isAnon = sqlite3_column_int(stmt, 6)
            let parent_post = sqlite3_column_int(stmt, 7)
            
            //convert ints to booleans
            let locationSharedBool = (locationShared == 1) ? true:false
            let isAnonBool = (isAnon == 1) ? true:false
            
            //create post and add it to the array
            let post = Post(id: Int(id), author: author, content: content, dorm: dorm, college: college, locationShared: locationSharedBool, isAnon: isAnonBool, parent_post: Int(parent_post))
            posts.append(post)
        }
        
        //finalize
        sqlite3_finalize(stmt)
        
        return posts
    }
    
    //retrieve all the posts associated with a dorm
    func getAllDormPosts(dorm: String) -> [Post] {
        let sql = "SELECT * FROM \(DBHandler.TBL_POST) WHERE \(DBHandler.DORM)=(?)"
        var posts = [Post]()
        
        //sqlite3_stmt pointer
        var stmt:OpaquePointer? = nil
        
        // compiler
        let prepare_result = sqlite3_prepare(self.db, sql, -1, &stmt, nil)
        if prepare_result != SQLITE_OK {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(self.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(sql)"
                print(msg)
            }
        }
        
        sqlite3_bind_text(stmt, 1, dorm.cString(using: String.Encoding.utf8), -1, SQLITE_TRANSIENT)
        
        //store results of each row
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let author = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 1)))
            let content = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 2)))
            let dorm = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 3)))
            let college = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 4)))
            let locationShared = sqlite3_column_int(stmt, 5)
            let isAnon = sqlite3_column_int(stmt, 6)
            let parent_post = sqlite3_column_int(stmt, 7)
            
            //convert ints to booleans
            let locationSharedBool = (locationShared == 1) ? true:false
            let isAnonBool = (isAnon == 1) ? true:false
            
            //create post and add it to the array
            let post = Post(id: Int(id), author: author, content: content, dorm: dorm, college: college, locationShared: locationSharedBool, isAnon: isAnonBool, parent_post: Int(parent_post))
            posts.append(post)
        }

        sqlite3_finalize(stmt)
        
        return posts
    }
    
    //retrieve all the posts associated with a college
    func getAllCollegePosts(college: String) -> [Post] {
        let sql = "SELECT * FROM \(DBHandler.TBL_POST) WHERE \(DBHandler.COLLEGE)=(?)"
        var posts = [Post]()
        
        //sqlite3_stmt pointer
        var stmt:OpaquePointer? = nil
        
        // compiler
        let prepare_result = sqlite3_prepare(self.db, sql, -1, &stmt, nil)
        if prepare_result != SQLITE_OK {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(self.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(sql)"
                print(msg)
            }
        }
        
        sqlite3_bind_text(stmt, 1, college.cString(using: String.Encoding.utf8), -1, SQLITE_TRANSIENT)
        
        //store results of each row
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let author = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 1)))
            let content = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 2)))
            let dorm = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 3)))
            let college = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 4)))
            let locationShared = sqlite3_column_int(stmt, 5)
            let isAnon = sqlite3_column_int(stmt, 6)
            let parent_post = sqlite3_column_int(stmt, 7)
            
            //convert ints to booleans
            let locationSharedBool = (locationShared == 1) ? true:false
            let isAnonBool = (isAnon == 1) ? true:false
            
            //create post and add it to the array
            let post = Post(id: Int(id), author: author, content: content, dorm: dorm, college: college, locationShared: locationSharedBool, isAnon: isAnonBool, parent_post: Int(parent_post))
            posts.append(post)
        }
        
        sqlite3_finalize(stmt)
        
        return posts
    }
    
    func readUsers(condition: String) -> [User] {
        let sql = "SELECT * FROM" + DBHandler.TBL_USER + " WHERE" + DBHandler.USERNAME + " = '\(condition)';";
        
        var userArr = [User]()

        //sqlite3_stmt pointer
        var stmt:OpaquePointer? = nil
        
        // compiler
        let prepare_result = sqlite3_prepare(self.db, sql, -1, &stmt, nil)
        if prepare_result != SQLITE_OK {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(self.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(sql)"
                print(msg)
            }
        }
        
        //step
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let username = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 1)))
            let password = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 2)))
            let email = String.init(cString: UnsafePointer(sqlite3_column_text(stmt, 3)))
            
            let user = User(id: Int(id), username: username, email: email, password: password)
            userArr.append(user)
        }
        
        //finalize
        sqlite3_finalize(stmt)
        
        return userArr
    }
    
    func update(password: String ,condition: String) -> Bool {
        let sql = "UPDATE" + DBHandler.TBL_USER + " set" + DBHandler.PASSWORD + " = '\(password)'" + " WHERE" + DBHandler.USERNAME + " = '\(condition)';"

        var stmt:OpaquePointer? = nil
        
        let prepare_result = sqlite3_prepare(self.db, sql, -1, &stmt, nil)
        if prepare_result != SQLITE_OK {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(self.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(sql)"
                print(msg)
            }
        }
        
        let step_result = sqlite3_step(stmt)
        
        if step_result != SQLITE_OK && step_result != SQLITE_DONE {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(db)) != nil {
                let msg = "SQLiteDB - failed to execute SQL:\(sql)"
                print(msg)
            }
            return false
        }
        
        sqlite3_finalize(stmt)
        return true
    }
    
    

}
