//
//  Ajustes.swift
//  reto
//
//  Created by Administrador on 08/11/23.
//

import Foundation
import UIKit

class AjustesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func updatenameAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdateNameViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateNameViewController")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func updatephotoAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdatePhotoViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdatePhotoViewController")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func updateemailAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdateEmailViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateEmailViewController")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func updatepasswordAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdatePasswordViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdatePasswordViewController")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

