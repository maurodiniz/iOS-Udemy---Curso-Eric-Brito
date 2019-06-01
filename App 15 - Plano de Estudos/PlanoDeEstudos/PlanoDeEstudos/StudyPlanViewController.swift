//
//  StudyViewController.swift
//  PlanoDeEstudos
//
//  Created by Eric Brito
//  Copyright © 2017 Eric Brito. All rights reserved.

import UIKit
import UserNotifications // framework necessario para fazer uso de notificações

class StudyPlanViewController: UIViewController {

    @IBOutlet weak var tfCourse: UITextField!
    @IBOutlet weak var tfSection: UITextField!
    @IBOutlet weak var dpDate: UIDatePicker!
    
    let sm = StudyManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dpDate.minimumDate = Date()
    }

    @IBAction func schedule(_ sender: UIButton) {
        let id = String(Date().timeIntervalSince1970)
        let studyPlan = StudyPlan(course: tfCourse.text!, section: tfSection.text!, date: dpDate.date, done: false, id: id)
        
        let content = UNMutableNotificationContent()
        content.title = "Lembrete"
        content.subtitle = "Matéria: \(studyPlan.course)"
        content.body = "Estudar \(studyPlan.section)"
        content.categoryIdentifier = "Lembrete"
        
        // criando trigger que será usado para definir o momento que a notificação será disparada. Existem basicamente 3 tipos: intervalo de tempo(daqui a x segundos), data especifica(dia x), localização
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        let dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: dpDate.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        //criando requisição de notificação e adicionando a notificação na central de notificações
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        sm.addPlan(studyPlan)
        
        navigationController?.popViewController(animated: true)
    }
    
}
