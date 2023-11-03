//
//  LogInViewController.swift
//  reto
//
//  Created by Administrador on 05/10/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message":"Integración de Firebase completa"])
    }

    
    @IBAction func logInButtonAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            // Manejar el caso en que el campo de email esté vacío
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            // Manejar el caso en que el campo de contraseña esté vacío
            return
        }
        
        if(!email.isEmpty && !password.isEmpty){
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
                guard let self = self else {return}
                
                if let error = error {
                    
                    let alertController = UIAlertController(title: "Error", message: "Credenciales inválidas o usuario no aprobado", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                } else if let user = authResult?.user {
                    self.verifyUserRoleAndState(user, email: email)
                }
            }
        }
    }
    
    func verifyUserRoleAndState(_ user: User, email: String){
        let userRef = Firestore.firestore().collection("users").document(user.uid)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let userData = document.data() {
                    let userState = userData["estado"] as? String
                    if let rolRef = userData["rol"] as? DocumentReference {
                        rolRef.getDocument { (rolDocument, error) in
                            if let rolDocument = rolDocument, rolDocument.exists {
                                if let rolData = rolDocument.data() {
                                    if let userRole = rolData["id"] as? String {
                                        if userRole == "admin" {
                                            if userState == "aprobado" {
                                                
                                                self.navigationController?.pushViewController(InicioViewController(email: email, provider: ProviderType.basic), animated: true)
                                            } else {
                                                let alertController = UIAlertController(title: "Error", message: "Aún no has sido aprobado", preferredStyle: .alert)
                                                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                                
                                                self.present(alertController, animated: true, completion: nil)
                                            }
                                        } else {
                                            let alertController = UIAlertController(title: "Error", message: "No eres un administrador", preferredStyle: .alert)
                                            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                            
                                            self.present(alertController, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Error", message: "Credenciales inválidas", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    // Método para ocultar el teclado cuando se toca en otra parte de la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

