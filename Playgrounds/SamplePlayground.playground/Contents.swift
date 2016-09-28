//: Playground - noun: a place where people can play

// CREDITS: https://designcode.io/swiftapp-learning

import UIKit


//## Constants & Variables
let theName = "Arthur" // <- try to change

var theAge = 23
theAge = 24



//## Value Types - type not needed
let myName: String = "Arthur" // String optional
let myAge = 23      // Int
let isOld = true    // Bool

// different types can’t be mixed
let label = "the width is "
let width = 100
let widthLabel = label + String(width)



//## Arrays
var colors = ["red", "green", "blue"]
colors[0] // red
colors.append("orange") // add
colors.removeAtIndex(1) // remove



//## Control Flow
// set conditions before running something, loop and duplicate stuff.
if myAge > 30 {
    print("I'm old")
} else {
    print("I'm not old")
}

// Shorter:
myAge > 30 ? print("I'm old") : print("I'm not old")

// for many if statements
switch myAge {
    case 30...100: "I'm old"
    case 18...29:  "I'm an adult"
    case 0...17:   "I'm young"
    default:       "Not sure"
}

// loops
for color in colors {
    print("This color is \(color)") // prints 3 times
}



//## Functions
// re-usable task, re-use the same element or group of elements across the project
func pointToRetina(point: Int) -> Int {
    return point * 2
}
pointToRetina(320) // Returns 640




//## Structs & Classes
// create profile instead of just performing tasks
struct UserStruct {
    var name: String
    var age: Int
    var job: String
}

var user = UserStruct(name: "Arthur", age: 23, job: "Student")
user.name // Get value Arthur

// struct automatically provides an default initializer for all properties, the class don’t.
class UserClass {
    var name: String
    var age: Int
    var job: String
    
    init(name: String, age: Int, job: String) {
        self.name = name
        self.age = age
        self.job = job
    }
}

//A struct is a value type. It gets copied if you pass it around. Now we have two separate objects. userB is a duplicate of userA. If you change a property of userB, userA won’t change.
var structUserA = UserStruct(name: "Arthur", age: 23, job: "Student")
var structUserB = structUserA
structUserB.name = "Peter"
structUserA.name // Arthur

// A class is a reference type. That means it gets referenced if you pass it around. If we change the name of userB, userA also change.
var classUserA = UserClass(name: "Arthur", age: 23, job: "Student")
var classUserB = classUserA
classUserA.name = "Peter"
classUserA.name // Peter



//## Comments

// Single line

/* This is a comment
 written over multiple lines */

// MARK: Section



//## Naming Convention

/*
For variables and functions, we’re going to use camel case starting with a lowercase.

name
userName
changeColor()
 
*/

/*
 For Classes and Structs we’ll capitalize the first letter. Notice that ViewController.swift is a Class.
 
 ViewController
 UserProfile
 Comment
 
 */

/*
 Avoid using abbreviations. Your code has to be readable by anyone. It has to read like English.
 
 var u = UserProfile()
 
 What the hell is “u”? Just like in design, don’t make your code ambiguous. Make it clear, clean and functional.
 
 */



//## Optionals

/*
 data often returns no value -> hard to work with
 
 Optionals introduced to make code safer,
 mark (?) to variable that may return no value.
*/

var answer: String? // can have sometimes no value
UILabel().text = answer

var hasAlwaysAnswer: String! // we are sure it has answer

/* to avoid breaking code, sometimes use Optional binding */
if let sureAnswer = answer {
    UILabel().text = sureAnswer
}

/* or shorter */
UILabel().text = answer ?? "" // if answer has value, use, otherwise empty string