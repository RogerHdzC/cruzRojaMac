//
//  RecuperarContraseñaViewController.swift
//  reto
//
//  Created by Administrador on 06/11/23.
//

import Foundation
import UIKit
import FirebaseAnalytics
import FirebaseAuth

class RecuperarContraseñaViewController: UIViewController {
    
    

    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message":"Integración de Firebase completa"])
    }

    @IBAction func enviarInstruccionesAction(_ sender: Any) {
        guard let email = emailText.text, !email.isEmpty else {
                // Validación: Asegúrate de que se haya ingresado un correo electrónico
                // Puedes mostrar una alerta al usuario si el campo está vacío
                return
            }

            // Envía las instrucciones de recuperación de contraseña al correo electrónico
            Auth.auth().sendPasswordReset(withEmail: email) { [weak self] (error) in
                guard let self = self else { return }
                
                if let error = error {
                    // Maneja errores de recuperación de contraseña
                    print("Error al enviar instrucciones de recuperación: \(error.localizedDescription)")
                    // Puedes mostrar una alerta al usuario para informar sobre el error
                    let alertController = UIAlertController(title: "Error", message: "Error al enviar instrucciones de recuperación", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // Instrucciones de recuperación enviadas con éxito
                    print("Instrucciones de recuperación enviadas con éxito")
                    // Puedes mostrar una alerta o mensaje de éxito al usuario
                    let alertController = UIAlertController(title: "Éxito", message: "Instrucciones de recuperación enviadas con éxito", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
    }
    
    
    // Método para ocultar el teclado cuando se toca en otra parte de la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
