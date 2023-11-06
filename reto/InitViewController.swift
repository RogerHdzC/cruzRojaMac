//
//  InitViewController.swift
//  reto
//
//  Created by Administrador on 05/10/23.
//

import UIKit
import FirebaseAnalytics

class InitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message":"Integración de Firebase completa"])
    }

    @IBAction func logInAction(_ sender: Any) {
        let viewLogIn = LogInViewController()
        
        self.navigationController?.pushViewController(viewLogIn, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let viewSignUp = SignUpViewController()
        
        self.navigationController?.pushViewController(viewSignUp, animated: true)
    }
    
    
    @IBAction func tableViewNav(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AprobarUserViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AprobarUserViewController")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

