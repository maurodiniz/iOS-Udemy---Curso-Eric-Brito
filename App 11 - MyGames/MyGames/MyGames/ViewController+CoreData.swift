//
//  ViewController+CoreData.swift
//  MyGames
//
//  Created by Mauro Augusto Diniz on 08/05/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// extensão criada para ajudar a puxar o contexto sem ter que acessar o AppDelegate toda hora
extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
}
