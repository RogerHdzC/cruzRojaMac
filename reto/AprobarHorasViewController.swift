//
//  AprobarHorasViewController.swift
//  reto
//
//  Created by Administrador on 16/11/23.
//

import Foundation
import UIKit
import FirebaseFirestore

struct horasVoluntarios {
    let aprobadas: String
    let evento: DocumentReference
    let nombreEvento: String
    let fecha: Date
    let hrs: Int
    let idVoluntario: DocumentReference
    let nombreVolunario: String
    let imagen: String

}

class AprobarHorasViewController : UIViewController {
    let db = Firestore.firestore()
    var listasHoras: [horasVoluntarios] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let horasCollection = db.collection("horasVoluntarios")
        
        horasCollection.whereField("aprobadas", isEqualTo: "pendientes").getDocuments{ [weak self] (querySnapshot, error)
            in guard let self = self else { return }
            
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let aprobadas = data["aprobadas"] as! String
                    let evento = data["evento"] as! DocumentReference
                    evento.getDocument{ (eventoDoc, error) in
                        let eventoData = eventoDoc!.data()
                    }
                    let idVoluntario = data["idVoluntario"] as! DocumentReference
                    idVoluntario.getDocument{ (voluntario, error) in
                        let voluntarioData = voluntario!.data()
                    }
                }
            }
        }
    }
}

extension AprobarHorasViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listasHoras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let horasCell = tableView.dequeueReusableCell(withIdentifier: AprobarHorasTableViewCell.identifier, for: indexPath) as! AprobarHorasTableViewCell
        let horas = listasHoras[indexPath.row]
        
        horasCell.nameLabel.text = "Test"
        horasCell.eventoLabel.text = "Test"
        horasCell.idLabel.text = "test"
        horasCell.hrsLabel.text="0"
        
        
        return horasCell
    }
    
    func aprobarAction(){}
    func rechazarAction(){}
}
