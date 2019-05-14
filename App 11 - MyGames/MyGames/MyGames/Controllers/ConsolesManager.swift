//
//  ConsolesManager.swift
//  MyGames
//
//  Created by Mauro Augusto Diniz on 12/05/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import Foundation
import CoreData

class ConsolesManager {
    static let shared = ConsolesManager()
    
    var consoles: [Console] = []
    
    // criando o contrutor de forma privada para evitar que outra classe consiga criar outra instancia de ConsolesManager
    private init() {
        
    }
    
    func loadConsoles(with context: NSManagedObjectContext) {
        
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            consoles = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        
        // recuperando a plataforma que eu quero excluir
        let console = consoles[index]
        
        // Excluindo o dado do contexto, porém ela ainda não foi persistida
        context.delete(console)
        
        // persistindo a exclusão através do context.save()
        do{
            try context.save()
            consoles.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
}
