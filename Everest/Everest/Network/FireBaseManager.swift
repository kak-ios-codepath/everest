//
//  FireBaseManager.swift
//  Karma
//
//  Created by user on 10/13/17.
//  Copyright © 2017 YSH. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftyJSON
import GoogleSignIn

class FireBaseManager {
    
    static let shared = FireBaseManager()
    
    static var UID:String = ""
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    // MARK: - Authentication related functions
    func registerNewUserWithEmail(name: String, email: String, password: String, completion: @escaping (User?, NSError?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                completion(nil, nil)
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { (error) in
                }
            } else {
                completion(nil, error as NSError?)
            }
        })
    }
    
    func loginUserWithEmail(email: String, password: String, completion: @escaping (User?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                if let uid = Auth.auth().currentUser?.uid {
                    FireBaseManager.UID = uid
                    self.createUserFromFirebase(user: user!, firebaseUID: uid, completion: { (user1, error) in
                        completion(user1, error)
                    })
                } else {
                    completion(nil, "Unable to login user" as? Error)
                }
                
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
                    
                    //check if user exists on Firebase
                    self.createUserFromFirebase(user: user!, firebaseUID: uid, completion: { (user1, error) in
                        completion(user1, error)
                    })
                } else {
                    completion(nil, "Unable to login user" as? Error)
                }
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
        ref.child("users/\(FireBaseManager.UID)/providerUid").setValue(user.providerUid)
        ref.child("users/\(FireBaseManager.UID)/providerId").setValue(user.providerId)
        if let photoUrl = user.profilePhotoUrl {
            ref.child("users/\(FireBaseManager.UID)/profilePhotoUrl").setValue(photoUrl)
        }
        ref.child("users/\(FireBaseManager.UID)/isAnonymous").setValue(user.isAnonymous)
        ref.child("users/\(FireBaseManager.UID)/createdDate").setValue(user.createdDate)
        ref.child("users/\(FireBaseManager.UID)/score").setValue(user.score)
//        if let momentIds = user.momentIds {
//            ref.child("users/\(FireBaseManager.UID)/momentIds").setValue(momentIds)
//        }
        if let actions = user.actions {
            ref.child("users/\(FireBaseManager.UID)/actions").setValue(actions)
        }
        
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
                .queryLimited(toFirst: Constants.LENGTH_OF_FETCHED_LIST)
                /*.observe(.value, with: { (snapshotVec) -> Void in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })*/
                .observeSingleEvent(of: .value, with: { (snapshotVec) in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })

        } else {
            ref.child("moments")
                .queryLimited(toFirst: Constants.LENGTH_OF_FETCHED_LIST)
                /*.observe(.value, with: { (snapshotVec) -> Void in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })*/
                .observeSingleEvent(of: .value, with: { (snapshotVec) in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })
        }
    }
    
    func fetchMomentsForAnAct (startAtMomentId: String?, actId: String, completion: @escaping ([Moment]?, Error?) -> ()) {
        if let startAtMomentId = startAtMomentId {
            ref.child("moments")
                .queryStarting(atValue: startAtMomentId)
                .queryOrdered(byChild: "actId")
                .queryEqual(toValue: actId)
                .queryLimited(toFirst: Constants.LENGTH_OF_FETCHED_LIST)
                .observeSingleEvent(of: .value, with: { (snapshotVec) in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })
                /*.observe(.value, with: { (snapshotVec) -> Void in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })*/
        } else {
            ref.child("moments")
                .queryOrdered(byChild: "actId")
                .queryEqual(toValue: actId)
                .queryLimited(toFirst: Constants.LENGTH_OF_FETCHED_LIST)
                .observeSingleEvent(of: .value, with: { (snapshotVec) in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })
                /*.observe(.value, with: { (snapshotVec) -> Void in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })*/
        }
    }
    
    func fetchMomentsForUser (startAtMomentId: String?, userId: String, completion: @escaping ([Moment]?, Error?) -> ()) {
        if let startAtMomentId = startAtMomentId {
            ref.child("moments")
                .queryStarting(atValue: startAtMomentId)
                .queryOrdered(byChild: "actId")
                .queryEqual(toValue: userId)
                .queryLimited(toFirst: Constants.LENGTH_OF_FETCHED_LIST)
                .observeSingleEvent(of: .value, with: { (snapshotVec) in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })
                /*.observe(.value, with: { (snapshotVec) -> Void in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })*/
        } else {
            ref.child("moments")
                .queryOrdered(byChild: "userId")
                .queryEqual(toValue: userId)
                .queryLimited(toFirst: Constants.LENGTH_OF_FETCHED_LIST)
                .observeSingleEvent(of: .value, with: { (snapshotVec) in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })
                /*.observe(.value, with: { (snapshotVec) -> Void in
                    if let momentsDictionary = snapshotVec.value as? NSDictionary {
                        let moments = momentsDictionary.flatMap { Moment(moment: JSON($1)) }
                        completion(moments, nil)
                    } else {
                        completion(nil, "failed to get moments timeline" as? Error)
                    }
                })*/
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
    
    func deleteMoment(actId: String, momentId: String) {
        ref.child("moments/\(momentId)").setValue("")
        ref.child("users/\(FireBaseManager.UID)/actions/\(actId)/momentIds/\(momentId)").setValue("")
    }
    
    func updateMoment(actId: String, moment: Moment, newMoment: Bool) {
        var MomentId = ""
        if newMoment {
            MomentId = ref.child("moments").childByAutoId().key
            ref.child("moments/\(MomentId)/id").setValue(MomentId)
            ref.child("users/\(FireBaseManager.UID)/actions/\(actId)/momentIds/\(MomentId)").setValue(true)
        } else {
            MomentId = moment.id
        }
        
        ref.child("moments/\(MomentId)/title").setValue(moment.title)
        ref.child("moments/\(MomentId)/details").setValue(moment.details)
        ref.child("moments/\(MomentId)/timestamp").setValue(moment.timestamp)
        ref.child("moments/\(MomentId)/actId").setValue(moment.actId)
        ref.child("moments/\(MomentId)/userId").setValue(moment.userId)
        if let photoUrl = moment.profilePhotoUrl {
            ref.child("moments/\(MomentId)/profilePhotoUrl").setValue(photoUrl)
        }
        ref.child("moments/\(MomentId)/userName").setValue(moment.userName)
        if let picUrls = moment.picUrls {
            ref.child("moments/\(MomentId)/picUrls").setValue(picUrls)
        }
        if let geoLocation = moment.geoLocation {
            ref.child("moments/\(MomentId)/geoLocation").setValue(geoLocation)
        }
        if let location = moment.location {
            ref.child("moments/\(MomentId)/location").setValue(location)
        }
        self.ref.child("moments/\(MomentId)/likes").setValue(0)
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
    func fetchAvailableCategories(completion: @escaping ([Category]?, Error?) -> ()) {
        ref.child("actsPicker")
            .observe(.value, with: { (snapshotVec) -> Void in
                if let actsDictionary = snapshotVec.value as? NSDictionary {
                    let categoryArray = actsDictionary.flatMap { Category(categoryTitle: $0 as! String, category: $1 as! NSDictionary) }
                    completion(categoryArray, nil)
                } else {
                    completion(nil, "failed to get available Acts" as? Error)
                }
            })
    }

    func fetchCategoryImageUrl(title: String, completion: @escaping (String?, Error?) -> () ) {
        ref.child("categoryImageUrl/\(title)").observeSingleEvent(of: .value , with: { (snapshot) in
            if let title = snapshot.value as? String {
                completion(title, nil)
            } else {
                completion(nil, "failed to get category Image's URL" as? Error)
            }
        })
    }
    
    func fetchAvailableActs(category: String, completion: @escaping ([Act]?, Error?) -> ()) {
        ref.child("actsPicker/\(category)")
            .observe(.value, with: { (snapshotVec) -> Void in
                if let actsDictionary = snapshotVec.value as? NSDictionary {
                    let actArray = actsDictionary.flatMap { Act(id: $0 as! String, category: category, title: $1 as! String, score: ACT_DEFAULT_SCORE) }
                    completion(actArray, nil)
                } else {
                    completion(nil, "failed to get available Acts" as? Error)
                }
            })
    }
    
    func updateAction(action: Action) {
        ref.child("acts/\(action.id)/members/\(FireBaseManager.UID)").setValue(true)
        
        ref.child("users/\(FireBaseManager.UID)/actions/\(action.id)/id").setValue(action.id)
        ref.child("users/\(FireBaseManager.UID)/actions/\(action.id)/createdAt").setValue(action.createdAt)
        ref.child("users/\(FireBaseManager.UID)/actions/\(action.id)/status").setValue(action.status)
        //  ref.child("users/\(FireBaseManager.UID)/actions/\(action.id)/actTitle").setValue(action.actTitle)
        
        //    ref.child("users/\(FireBaseManager.UID)/actions/\(action.id)/momentId").setValue(action.momentId)
    }
    
    func updateActionStatus(id: String, status: String) {
//        ref.child("users/\(FireBaseManager.UID)/actions/\(id)/id").setValue(id)
        ref.child("users/\(FireBaseManager.UID)/actions/\(id)/status").setValue(status)
    }
    
    // MARK: - Utility functions
    func createUserFromFirebase(user: Firebase.User, firebaseUID: String, completion: @escaping (User?, Error?) -> ()){
        //check if user exists on Firebase
        self.getUser(userID: user.uid, completion: { (user1, error) in
            if user1 != nil {
                //TODO: check if existing user record needs update
                completion(user1, nil)
            } else {//user doesn't exist
                let userInfo = user.providerData[0]
                var name: String = ""
                var email: String = ""
                var phone: String?
                var photoUrl: String?
                
                if userInfo.displayName != nil {
                    name = userInfo.displayName!
                }
                if userInfo.email != nil {
                    email = userInfo.email!
                }
                if userInfo.phoneNumber != nil {
                    phone = userInfo.phoneNumber!
                }
                if userInfo.photoURL != nil {
                    photoUrl = userInfo.photoURL!.absoluteString
                }
                let currentUser = User(id: firebaseUID, providerUid: userInfo.uid, providerId: userInfo.providerID, name: name, email: email, phone: phone, profilePhotoUrl: photoUrl, isAnonymous: user.isAnonymous, createdDate: "\(Date())", actions: nil, score: 0)
                
                self.updateUser(user: currentUser)
                completion(currentUser, nil)
            }
        })
    }
    
    // MARK: - File storage functions
    
    func uploadImage(image: UIImage, completion: @escaping (String, String?, Error?) -> ()) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else { return }
        uploadImage(data: imageData) { (path, url, error) in
            completion(path, url, error)
        }
    }
    
    func uploadImage(data: Data, completion: @escaping (String, String?, Error?) -> ()) {
        let imagePath = Auth.auth().currentUser!.uid +
        "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        self.storageRef.child(imagePath).putData(data, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading: \(error)")
                completion(imagePath, nil, error)
            } else {
                completion(imagePath, metadata?.downloadURL()?.absoluteString, nil)
            }
        }
    }
    
    func downloadImage(path: String, completion: @escaping (String?, Error?) -> ()) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "file:\(documentsDirectory)/"+path
        guard let fileURL = URL.init(string: filePath) else { return }
        storageRef.child(path).write(toFile: fileURL, completion: { (url, error) in
            if let error = error {
                print("Error downloading:\(error)")
                completion(nil, error)
            } else if let imagePath = url?.path {
                //self.imageView.image = UIImage.init(contentsOfFile: imagePath)
                completion(imagePath, nil)
            }
        })
    }
    
}
