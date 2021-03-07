//
//  DatabaseManager.swift
//  movie-app
//
//  Created by ismailyildirim on 7.03.2021.
//

import Foundation
import UIKit
import CoreData

protocol DatabaseManagerProtocol {
    func add(id:Int, isFavorite:Bool, onSuccess: ((Bool)-> Void))
    func get(id:Int, onSuccess: ((Bool) -> Void))
    func getAll(onSuccess: ([Int]) -> ())
    
}
class DatabaseManager: DatabaseManagerProtocol {
    
    static let shared: DatabaseManagerProtocol = DatabaseManager()
    
    func add(id:Int, isFavorite:Bool, onSuccess: ((Bool)-> Void)){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        
        if isFavorite {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            do {
                let fetchResult = try managedContext.fetch(fetchRequest)
                for item in fetchResult as! [NSManagedObject] {
                    if item.value(forKey: "id") as? Int == id {
                        managedContext.delete(item)
                        onSuccess(true)
                        return
                    }
                }
            }catch let err{
                print(err)
            }
        }else{
            item.setValue(id, forKey: "id")
            do {
                try managedContext.save()
                onSuccess(true)
            }catch let err {
                onSuccess(false)
                print(err)
            }
        }
        
    }
    
    func get(id: Int, onSuccess: ((Bool) -> Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        do {
            let fetchResult = try managedContext.fetch(fetchRequest)
            for item in fetchResult as! [NSManagedObject] {
                if item.value(forKey: "id") as? Int == id {
                    onSuccess(true)
                    return
                }
            }
            onSuccess(false)
        }catch let err{
            print(err)
        }
    }
    
    func getAll(onSuccess: ([Int]) -> ()){
        var result:[Int] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        do {
            let fetchResult = try managedContext.fetch(fetchRequest)
            for item in fetchResult as! [NSManagedObject] {
                if let res = item.value(forKey: "id") as? Int {
                    result.append(res)
                }
            }
            onSuccess(result)
            
        }catch let err{
            print(err)
        }
        
    }
    
        func removeAll() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try managedContext.execute(request)
    
            } catch let err {
                print(err)
            }
        }
}
