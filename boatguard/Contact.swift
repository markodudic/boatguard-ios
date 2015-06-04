//
//  Contact.swift
//  boatguard
//
//  Created by Marko Dudic on 6/3/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import Foundation

var contact: Contact = Contact()

class Contact: NSObject {
    
    var uid       = 0
    var name      = ""
    var lastName   = ""
    var phoneNum  = ""
    var email     = ""

    func setUid(data: Int) {
        uid = data
    }
    func getUid() -> Int {
        return uid
    }
    
    func setName(data: String) {
        name = data
    }
    func getName() -> String {
        return name
    }
    
    func setLastName(data: String) {
        lastName = data
    }
    func getLastName() -> String {
        return lastName
    }
    
    func setPhoneNum(data: String) {
        phoneNum = data
    }
    func getPhoneNum() -> String {
        return phoneNum
    }
    
    func setEmail(data: String) {
        email = data
    }
    func getEmail() -> String {
        return email
    }
    
}
