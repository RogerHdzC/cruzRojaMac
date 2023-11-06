//
//  AprobarUserViewController.swift
//  reto
//
//  Created by Administrador on 03/11/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseFirestore

struct UserAprobar {
    let nombre: String
    let email: String
    let estado: String
    let rol: DocumentReference
}

class AprobarUserViewController: UIViewController{
    let db = Firestore.firestore()
    var pendingUsers: [UserAprobar] = []

    
    @IBOutlet weak var tableView: UITableView!
    
    var strings: [String] = ["Alpha", "Beta", "Unlimited", "Revised"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message": "Integración de Firebase completa"])
        
        let usersCollection = db.collection("users")

        usersCollection.whereField("estado", isEqualTo: "pendiente").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let nombre = data["Nombre"] as! String
                    let email = data["email"] as! String

                    let user = UserAprobar(nombre: nombre, email: email, estado: "pendiente", rol: document.reference)
                    self.pendingUsers.append(user)
                }
                self.tableView.reloadData()
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserTableViewCell.nib(), forCellReuseIdentifier: UserTableViewCell.identifier)
    }



}

extension AprobarUserViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        let user = pendingUsers[indexPath.row]

        cell.nameLabel.text =  user.nombre
        cell.emailLabel.text = user.email
        
        // Pasa la referencia del usuario al botón de aprobación
        cell.approveAction = { [weak self] in
            self?.approveUser(userReference: user.rol)
        }
        
        return cell
    }
    func approveUser(userReference: DocumentReference) {
        db.document(userReference.path).updateData(["estado": "aprobado"]) { (error) in
            if let error = error {
                print("Error updating user status: \(error)")
            } else {
                // Actualiza la tabla o vista después de la aprobación
            }
        }
    }
    
}
