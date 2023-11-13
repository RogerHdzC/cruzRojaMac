//
//  SignUpViewController.swift
//  reto
//
//  Created by Administrador on 05/10/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    let db=Firestore.firestore()

    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message":"Integración de Firebase completa"])
    }

    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        let rolRef = Firestore.firestore().collection("roles").document("admin")
        let estado = "pendiente"
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let repassword = repasswordTextField.text ?? ""
        let nombre = nombreTextField.text ?? ""
        let passwordPattern = "^(?=.*[0-9].*[0-9])(?=.*[!@#\\$%^&*])(?=\\S+$).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
        let isPasswordValid = passwordTest.evaluate(with: password)
        
        
        if !email.isEmpty && !password.isEmpty {
            if isPasswordValid {
                if password == repassword {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        
                        if error != nil {
                            let alertController = UIAlertController(title: "Error", message: "Se ha producido un error registrando el usuario", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                        } else if let uid = authResult?.user.uid {
                            let userData = [
                                "email": email,
                                "Nombre": nombre,
                                "rol": rolRef,
                                "estado": estado
                            ]
                            
                            self.db.collection("users").document(uid).setData(userData) { error in
                                if error != nil {
                                    let alertController = UIAlertController(title: "Error", message: "Error al guardar los datos", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                } else {
                                    self.navigationController?.pushViewController(ConfirmacionViewController(email: email), animated: true)
                                }
                            }
                        } else {
                            let alertController = UIAlertController(title: "Error", message: "Error al obtener el ID del usuario", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }else{
                    let alertController = UIAlertController(title: "Error", message: "Las contraseñas deben coincidir", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }else {
                let alertController = UIAlertController(title: "Error", message: "La contraseña no cumple con los requisitos: debe tener al menos 8 caracteres, 2 números y un carácter especial.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Los campos de correo electrónico y contraseña son obligatorios", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func logInAction(_ sender: Any) {
        let viewLogIn = LogInViewController()
        
        self.navigationController?.pushViewController(viewLogIn, animated: true)
    }
    
    // Método para ocultar el teclado cuando se toca en otra parte de la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

