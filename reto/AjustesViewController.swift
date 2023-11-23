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
    
    @IBAction func aprobarAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AprobarUserViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AprobarUserViewController")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

