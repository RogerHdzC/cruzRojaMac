//
//  UpdateEmailViewController.swift
//  reto
//
//  Created by Administrador on 15/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UpdateEmailViewController: UIViewController {
    let db = Firestore.firestore()

    @IBOutlet weak var updateText: UILabel!
    @IBOutlet weak var updateLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Mostrar el correo electrónico actual del usuario
        if let currentUserEmail = Auth.auth().currentUser?.email {
            updateText.text = "Correo Electrónico Actual: \(currentUserEmail)"
        }
    }

    @IBAction func updateEmail(_ sender: Any) {
        // Validar si se proporciona un nuevo correo electrónico
        guard let newEmail = updateLabel.text, !newEmail.isEmpty else {
            // Manejar el caso en que el campo de actualización esté vacío
            print("Por favor, ingrese un nuevo correo electrónico.")
            return
        }

        // Crear un alertController con un campo de texto seguro para la contraseña
        let alertController = UIAlertController(title: "Confirmación", message: "Por favor, ingrese su contraseña para continuar", preferredStyle: .alert)

        alertController.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "Contraseña"
            passwordTextField.isSecureTextEntry = true
        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let confirmAction = UIAlertAction(title: "Confirmar", style: .default) { [weak self] (_) in
            // Acción de confirmar presionada, obtener la contraseña ingresada
            if let password = alertController.textFields?.first?.text {
                self?.reauthenticateAndSendVerificationEmail(newEmail: newEmail, password: password)
            }
        }

        alertController.addAction(confirmAction)

        present(alertController, animated: true, completion: nil)
    }

    private func reauthenticateAndSendVerificationEmail(newEmail: String, password: String) {
        // Reautenticar al usuario antes de verificar y actualizar el correo electrónico
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: password)

        user?.reauthenticate(with: credential) { [weak self] (_, error) in
            if let error = error {
                print("Error de reautenticación: \(error.localizedDescription)")
                // Manejar el error de reautenticación
            } else {
                // Enviar un correo electrónico de verificación a la nueva dirección de correo electrónico
                user?.updateEmail(to: newEmail) { [weak self] (error) in
                    if let error = error {
                        print("Error al enviar el correo electrónico de verificación: \(error.localizedDescription)")
                        // Manejar el error de envío del correo de verificación
                    } else {
                        print("Correo electrónico de verificación enviado exitosamente a \(newEmail)")
                        // Manejar el éxito del envío del correo de verificación
                        
                        // Mostrar un mensaje al usuario para que revise su correo electrónico
                        self?.showVerificationMessage()
                    }
                }
            }
        }
    }

    private func showVerificationMessage() {
        let alertController = UIAlertController(
            title: "Verificación de Correo Electrónico",
            message: "Se ha enviado un correo electrónico de verificación a la nueva dirección. Por favor, revise su correo electrónico y haga clic en el enlace de verificación para completar el proceso.",
            preferredStyle: .alert
        )

        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okayAction)

        present(alertController, animated: true, completion: nil)
    }
}
