//
//  DatabaseManger.swift
//  Coredata
//
//  Created by Narayanasamy on 13/08/23.
//


import UIKit
import CoreData


class DatabaseManger {
    
    
    private var context: NSManagedObjectContext {
        
        return(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    }
    
    // MARK: - addUser
    
    func addUser(_ user: UserModel) {
        let userEntity = UserEntity(context: context) // User create
        addUpdateUser(usereEntity: userEntity, user: user)
    }

    func updateUser(user: UserModel,userEntity: UserEntity) {
        addUpdateUser(usereEntity: userEntity, user: user)
        
        //Data base main reflect
        
    }
    
    private func addUpdateUser(usereEntity:UserEntity, user: UserModel) {
        
        usereEntity.firstName = user.firstName
        usereEntity.lastName = user.lastName
        usereEntity.email = user.email
        usereEntity.password = user.password
        
    }
    
    func fetchUser() ->  [UserEntity]{
        
        var users:[UserEntity] = []
        
        do {
            users = try context.fetch(UserEntity.fetchRequest())
        } catch {
            print("Fetch user error",error)
        }
        return users
    }
    
    func saveContext() {
        
        do {
            try context.save() //MIMP
        } catch {
            print("Save user error",error)
        }
    }
    func deleteuser(userEntity: UserEntity) {
        
        let imageURL = URL.documentsDirectory.appending(components: userEntity.imageName ?? "").appendingPathExtension("png")
        
        do {
            try  FileManager.default.removeItem(at: imageURL)
            
        } catch {
            print("remove image from DD",error)
        }
        context.delete(userEntity)
        saveContext()  // MIMP
        
    }
}
