//
//  MenuViewController.swift
//  reto
//
//  Created by Administrador on 08/11/23.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func ajustesAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AjustesViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AjustesViewController")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func anunciosAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AnunciosViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AnunciosViewController")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func dashboardAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DashboardViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
