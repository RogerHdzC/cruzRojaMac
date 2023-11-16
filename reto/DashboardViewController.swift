//
//  DashboardViewController.swift
//  reto
//
//  Created by Administrador on 09/11/23.
//

import Foundation
import UIKit
import FirebaseFirestore

struct UserServicio{
    let nombre: String
    let ID: String
    let horas: Int
    let documentRef: DocumentReference
    let rol: DocumentReference
}

class DashboardViewController : UIViewController {
    let db = Firestore.firestore()
    var listaUsers: [UserServicio] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userCollection = db.collection("users")
        
        let voluntarioRef = db.collection("roles").document("voluntario")
        
        userCollection.whereField("rol", isEqualTo: voluntarioRef).getDocuments{ [weak self] (querySnapshot, error) in guard let self = self else { return }
            
            if let error = error {
                print("Error fetching documents: \(error)")
            }else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let nombre = data["nombre"] as! String
                    let ID = data["id"] as! String
                    let horas = data["hrsAcumuladas"] as? Int
                    let rol =   data["rol"] as! DocumentReference
                    
                    let user = UserServicio(nombre: nombre, ID: ID, horas: horas ?? 0, documentRef: document.reference, rol: rol)
                    
                    self.listaUsers.append(user)
                }
                
                if self.listaUsers.count >= 2 {
                    self.listaUsers.sort {$0.horas > $1.horas }
                }
                
                self.tableView.reloadData()
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserHorasTableViewCell.nib(), forCellReuseIdentifier: UserHorasTableViewCell.identifier)
    }
}

extension DashboardViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: UserHorasTableViewCell.identifier, for: indexPath) as! UserHorasTableViewCell
        
        let user = listaUsers[indexPath.row]
        
        userCell.nameLabel.text = user.nombre 
        userCell.idLabel.text = user.ID
        userCell.hrsLabel.text = "\(user.horas)"
        
        userCell.setCellColor(isEven: indexPath.row % 2 == 0)
        
        return userCell
    }
    
}
