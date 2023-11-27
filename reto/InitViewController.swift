//
//  InitViewController.swift
//  reto
//
//  Created by Administrador on 05/10/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseFirestore

class InitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message":"Integración de Firebase completa"])
        reiniciarHrsAcumuladasSiEsPrimerDiaDelMes()
    }

    @IBAction func logInAction(_ sender: Any) {
        let viewLogIn = LogInViewController()
        
        self.navigationController?.pushViewController(viewLogIn, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let viewSignUp = SignUpViewController()
        
        self.navigationController?.pushViewController(viewSignUp, animated: true)
    }
    
    @IBAction func ajustes(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func reiniciarHrsAcumuladasSiEsPrimerDiaDelMes() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Obtén el día actual del mes
        let dayOfMonth = calendar.component(.day, from: currentDate)
        
        // Verifica si es el primer día del mes
        if dayOfMonth == 1 {
            // Lógica para reiniciar las hrsAcumuladas
            
            // Aquí deberías obtener la colección de usuarios desde Firestore
            // y luego iterar sobre los documentos para actualizar el campo hrsAcumuladas
            
            let db = Firestore.firestore()
            let usersCollection = db.collection("users")
            
            usersCollection.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error al obtener documentos: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No hay documentos en la colección.")
                    return
                }
                
                for document in documents {
                    // Actualizar el campo hrsAcumuladas a 0 para cada documento
                    let documentRef = usersCollection.document(document.documentID)
                    documentRef.updateData(["hrsAcumuladas": 0]) { error in
                        if let error = error {
                            print("Error al actualizar hrsAcumuladas: \(error.localizedDescription)")
                        } else {
                            print("hrsAcumuladas reiniciadas con éxito para el usuario \(document.documentID)")
                        }
                    }
                }
            }
        }
    }

    
}

