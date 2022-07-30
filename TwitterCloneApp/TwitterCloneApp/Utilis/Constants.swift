//
//  Constants.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/30/22.
//

import Firebase
// accesses info from gogleservice-info.plist, creating url string and it put's data to the right place, we create user child from main database, and create another child of users with uid of user
// create some shorthand constants that allow us to access our database information
let STORAGE_REF = Storage.storage().reference() // reference to storage profile image
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images") // child

let DB_REF = Database.database().reference() // reference to database
let REF_USERS = DB_REF.child("users")// reference to the user of database
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets") // add user tweets for fetching tweets to profile tweets in profile controller
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
