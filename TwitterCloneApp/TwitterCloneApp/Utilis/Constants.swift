//
//  Constants.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/30/22.
//

import Firebase
// accesses info from gogleservice-info.plist, creating url string and it put's data to the right place, we create user child from main database, and create another child of users with uid of user
// create some shorthand constants that allow us to access our database information
let DB_REF = Database.database().reference() // reference to database
let REF_USERS = DB_REF.child("users") // reference to the user of database 
