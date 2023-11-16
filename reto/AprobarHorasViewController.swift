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
                    evento.getDocument{ (evetoDoc, error) in
                        
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
        return horasCell
    }
    
    func aprobarAction(){}
    func rechazarAction(){}
}
