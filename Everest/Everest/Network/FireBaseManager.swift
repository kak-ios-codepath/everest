//
//  FireBaseManager.swift
//  Karma
//
//  Created by user on 10/13/17.
//  Copyright © 2017 YSH. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON
import GoogleSignIn

class FireBaseManager {
  
  static let shared = FireBaseManager()
  static var UID:String = ""
  let ref = Database.database().reference()
  let LENGTH_OF_FETCHED_LIST: UInt = 20
  
// MARK: - Authentication related functions
    func registerNewUserWithEmail(name: String, email: String, password: String, completion: @escaping (User?, Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
              if error == nil {
                    completion(nil, nil)
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges { (error) in
                    }
              } else {
                    completion(nil, error)
              }
        })
    }
  
    func loginUserWithEmail(email: String, password: String, completion: @escaping (User?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
              if error == nil {
                    if let uid = Auth.auth().currentUser?.uid {
                        FireBaseManager.UID = uid
                    }
                    completion(nil, nil)
              } else {
                    completion(nil, error)
              }
        }
    }
  
  // TODO:- We need to add logic here for the case of having an existing account with email. We need to merge the two accounts under one account
  func loginUserWithFacebook (accessToken:String, completion: @escaping (User?, Error?) -> ()) {
    let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
    Auth.auth().signIn(with: credential) { (user, error) in
        if error == nil {
            if let uid = Auth.auth().currentUser?.uid {
                FireBaseManager.UID = uid
            }
            completion(nil, nil)
        } else {
            completion(nil, error)
        }
    }
  }
  
  func logoutUser(completion: (Error?) -> () ) {
    do {
      try Auth.auth().signOut()
    }
    catch {
      completion("error: we couldn't sign out" as? Error)
    }
    completion(nil)
  }
  
// MARK: - User Data Model related functions
  func updateUser(user: User) {
    ref.child("users/\(FireBaseManager.UID)/id").setValue(FireBaseManager.UID)
    ref.child("users/\(FireBaseManager.UID)/name").setValue(user.name)
    ref.child("users/\(FireBaseManager.UID)/email").setValue(user.email)
    if let phone = user.phone {
      ref.child("users/\(FireBaseManager.UID)/phone").setValue(phone)
    }
    ref.child("users/\(FireBaseManager.UID)/anonymous").setValue(user.anonymous)
    ref.child("users/\(FireBaseManager.UID)/createdDate").setValue(user.createdDate)
    ref.child("users/\(FireBaseManager.UID)/score").setValue(user.score)
  }
  
  func getUser(userID: String, completion: @escaping (User?, Error?) -> ()) {
    ref.child("users/\(userID)").observeSingleEvent(of: .value , with: { (snapshot) in
      guard let userDictionary = snapshot.value as? [String: Any] else {
        completion(nil, "Unable to get user dictionary" as? Error)
        return
      }
      completion(User(user: JSON(userDictionary)), nil)
    }) { (error) in
      completion(nil, error)
    }
  }
  
  func updateScore(incrementBy: Int) {
    ref.child("users/\(FireBaseManager.UID)/score").observeSingleEvent(of: .value, with: { (snapshot) in
      // Get user score value
      if let value = snapshot.value as? Int {
        self.ref.child("users/\(FireBaseManager.UID)/score").setValue(value + incrementBy)
      }
    }) { (error) in
      print(error.localizedDescription)
    }
  }
  
// MARK: - Moment Data Model related functions
  func getMomentsTimeLine (startAtMomentId: String?, completion: @escaping ([Moment]?, Error?) -> ()) {
    if let startAtMomentId = startAtMomentId {
      ref.child("moments")
        .queryStarting(atValue: startAtMomentId)
        .queryLimited(toFirst: LENGTH_OF_FETCHED_LIST)
        .observe(.value, with: { (snapshotVec) -> Void in
          if let momentsDictionary = snapshotVec.value as? NSDictionary {
            let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
            completion(moments, nil)
          } else {
            completion(nil, "failed to get moments timeline" as? Error)
          }
        })
    } else {
      ref.child("moments")
        .queryLimited(toFirst: LENGTH_OF_FETCHED_LIST)
        .observe(.value, with: { (snapshotVec) -> Void in
          if let momentsDictionary = snapshotVec.value as? NSDictionary {
            let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
            completion(moments, nil)
          } else {
            completion(nil, "failed to get moments timeline" as? Error)
          }
      })
    }
  }
  
  func updateMomentLikes(momentId: String, incrementBy: Int) {
    ref.child("moments/\(momentId)/likes").observeSingleEvent(of: .value, with: { (snapshot) in
      if let value = snapshot.value as? Int {
        self.ref.child("moments/\(momentId)/likes").setValue(value + incrementBy)
      }
    }) { (error) in
      print(error.localizedDescription)
    }
  }
  
  func updateMoment(moment: Moment) {
    let newMoment = ref.child("moments").childByAutoId()
    
    ref.child("users/\(FireBaseManager.UID)/moments/\(newMoment.key)").setValue(true)
    
    ref.child("moments/\(newMoment.key)/id").setValue(newMoment.key)
    ref.child("moments/\(newMoment.key)/title").setValue(moment.title)
    ref.child("moments/\(newMoment.key)/details").setValue(moment.details)
    ref.child("moments/\(newMoment.key)/timestamp").setValue(moment.timestamp)
    ref.child("moments/\(newMoment.key)/actId").setValue(moment.actId)
    ref.child("moments/\(newMoment.key)/userId").setValue(moment.userId)
    if let picUrls = moment.picUrls {
      ref.child("moments/\(newMoment.key)/picUrls").setValue(picUrls)
    }
    if let geoLocation = moment.geoLocation {
      ref.child("moments/\(newMoment.key)/geoLocation").setValue(geoLocation)
    }
    if let location = moment.location {
      ref.child("moments/\(newMoment.key)/location").setValue(location)
    }
    self.ref.child("moments/\(newMoment.key)/likes").setValue(0)
  }
  
  func getMoment(momentId: String, completion: @escaping (Moment?, Error?) -> ()) {
    ref.child("moments/\(momentId)").observeSingleEvent(of: .value , with: { (snapshot) in
      guard let momentDictionary = snapshot.value as? [String: Any] else {
        completion(nil, "Unable to fetch a moment dictionary" as? Error)
        return
      }
      completion(Moment(moment: JSON(momentDictionary)), nil)
    }) { (error) in
      completion(nil, error)
    }
  }
  
// MARK: - Action Data Model related functions
  func updateAction(action: Action) {
    ref.child("acts/\(action.categoryId)/\(action.id)/members/\(FireBaseManager.UID)").setValue(true)

    ref.child("users/\(FireBaseManager.UID)/actions/\(action.id)/createdAt").setValue(action.createdAt)
    ref.child("users/\(FireBaseManager.UID)/actions/\(action.id)/status").setValue(action.status)
    ref.child("users/\(FireBaseManager.UID)/actions/\(action.id)/momentId").setValue(action.momentId)
  }
}
