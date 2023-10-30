//
//  LogInViewController.swift
//  reto
//
//  Created by Administrador on 05/10/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

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
            
            Auth.auth().signIn(withEmail: email, password: password) {
                result, error in
                
                if let result = result, error == nil {
                    
                    self.navigationController?.pushViewController(InicioViewController(email: result.user.email!, provider: .basic), animated: true)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error iniciando sesión el usuario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    
}

