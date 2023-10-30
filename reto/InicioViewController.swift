//
//  InicioViewController.swift
//  reto
//
//  Created by Administrador on 30/10/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

enum ProviderType: String{
    case basic
}

class InicioViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    private let email: String
    private let provider: ProviderType
    
    init(email: String, provider: ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName: "InicioViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = email

        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message": "Integración de Firebase completa"])
    }
    
    @IBAction func logOutButtonAction(_ sender: Any) {
        switch provider {
        case .basic:
            do{
                try Auth.auth().signOut()
                navigationController?.popViewController(animated: true)
            } catch {
                //
                
            }
            
        }
    }
}
