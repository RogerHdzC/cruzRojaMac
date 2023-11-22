//
//  UpdateNameViewController.swift
//  reto
//
//  Created by Administrador on 15/11/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UpdateNameViewController: UIViewController {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userRef = self.db.collection("users").document(user?.uid ?? "")

        userRef.getDocument { (user, error) in

            guard let user = user, error == nil else {
                // Manejar el error aquí si es necesario
                return
            }

            let userData = user.data()
            let nombreUser = userData?["Nombre"] as! String
            self.nameLabel.text = "Nombre de Usuario: \(nombreUser)"
        }
    }
    
    
    @IBAction func updateName(_ sender: Any) {
        // Obtener el nuevo nombre del UITextField
               guard let newName = nameText.text, !newName.isEmpty else {
                   // Manejar el caso en el que el nuevo nombre esté vacío
                   return
               }

               // Actualizar el nombre en Firestore
               let userRef = self.db.collection("users").document(user?.uid ?? "")
               userRef.updateData(["Nombre": newName]) { error in
                   if let error = error {
                       print("Error updating user document: \(error)")
                       // Manejar el error aquí si es necesario
                   } else {
                       print("User document successfully updated with new name: \(newName)")
                       // Actualizar la etiqueta nameLabel
                       self.nameLabel.text = "Nombre de Usuario: \(newName)"
                       let storyboard = UIStoryboard(name: "AjustesViewController", bundle: nil)
                       let vc = storyboard.instantiateViewController(withIdentifier: "AjustesViewController")
                       
                       self.navigationController?.pushViewController(vc, animated: true)
                   }
               }
    }
    
    
}
