//
//  StudyManager.swift
//  PlanoDeEstudos
//
//  Created by Mauro Augusto Diniz on 30/05/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation
import UserNotifications

class StudyManager {
    static let shared = StudyManager()
    
    // ud que irá persistir e recuperar os planos que o usuario criou
    let ud = UserDefaults.standard
    
    // studyPlans irá armazenar todos os planos de estudo
    var studyPlans: [StudyPlan] = []
    
    private init() {
        // se existir a informação no userDefaults para a chave definida e conseguir decodificar isso num array de StudyPlan
        if let data = ud.data(forKey: "studyPlans"), let plans = try? JSONDecoder().decode([StudyPlan].self, from: data) {
            
            self.studyPlans = plans
        } else {
            
        }
    }
    
    // Persistindo os planos de estudo
    func savePlans() {
        if let data = try? JSONEncoder().encode(studyPlans) {
            ud.set(data, forKey: "studyPlans")
        }
    }
    
    // adicionando um plano de estudo na lista e já salvando no userDefaults
    func addPlan(_ studyPlan: StudyPlan) {
        studyPlans.append(studyPlan)
        savePlans()
    }
    
    // removendo um plano pelo indice
    func removePlan(at index: Int) {
        // caso a notificação que está sendo apagada tenha alguma notificação pendente, removo da lista de notificações
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [studyPlans[index].id])
        
        studyPlans.remove(at: index)
        savePlans()
    }
    
    // marcando plano como concluido
    func setPlanDone(id: String) {
        if let studyPlan = studyPlans.first(where: { $0.id == id}) {
            
            studyPlan.done = true
            savePlans()
        }
    }
}
