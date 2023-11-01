//
//  ConfirmacionViewController.swift
//  reto
//
//  Created by Administrador on 30/10/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

enum ProvideType: String{
    case basic
}

class ConfirmacionViewController: UIViewController{
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    private let email: String
    
    init(email: String){
        self.email = email
        super.init(nibName: "ConfirmacionViewController", bundle: nil)
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = email
    }
    
    
    @IBAction func logInAction(_ sender: Any) {
        
        let viewLogIn = LogInViewController()
        
        self.navigationController?.pushViewController(viewLogIn, animated: true)
        
    }
    
    
}
