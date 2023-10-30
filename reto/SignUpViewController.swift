//
//  SignUpViewController.swift
//  reto
//
//  Created by Administrador on 05/10/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth


class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message":"Integración de Firebase completa"])
    }

    
    @IBAction func signUpButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { 
                result, error in
                
                if let result = result, error == nil {
                    
                    self.navigationController?.pushViewController(ConfirmacionViewController(email: result.user.email!), animated: true)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error registrando el usuario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func logInAction(_ sender: Any) {
        let viewLogIn = LogInViewController()
        
        self.navigationController?.pushViewController(viewLogIn, animated: true)
    }
}

