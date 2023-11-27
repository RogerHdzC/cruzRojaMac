//
//  MenuViewController.swift
//  reto
//
//  Created by Administrador on 08/11/23.
//

import Foundation
import UIKit
import FirebaseAuth

class MenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Ocultar la barra de navegación
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Mostrar la barra de navegación cuando se va a otro controlador de vista
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    @IBAction func ajustesAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AprobarUserViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AprobarUserViewController")
        
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
    
    
    @IBAction func serivicioAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AprobarHorasViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AprobarHorasViewController")
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func cerrarSesion(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            // Después de cerrar sesión, puedes redirigir al usuario a la pantalla de inicio de sesión o a otra vista según tus necesidades.
            navigationController?.popToRootViewController(animated: true)
        } catch let error as NSError {
            print("Error al cerrar sesión: \(error.localizedDescription)")
        }
    }
}
