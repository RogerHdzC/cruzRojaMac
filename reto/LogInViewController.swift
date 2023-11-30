//
//  LogInViewController.swift
//  reto
//
//  Created by Administrador on 05/10/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message":"Integración de Firebase completa"])
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
    
    
    @IBAction func crearCuentaAction(_ sender: Any) {
        
        let view = SignUpViewController()

        self.navigationController?.pushViewController(view, animated: true)
        
    }
    
    @IBAction func logInButtonAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            // Manejar el caso en que el campo de email esté vacío
            let alertController = UIAlertController(title: "Error", message: "El correo y la contraseña son obligatorios", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            // Manejar el caso en que el campo de contraseña esté vacío
            let alertController = UIAlertController(title: "Error", message: "El correo y la contraseña son obligatorios", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if(!email.isEmpty && !password.isEmpty){
            // Mostrar un indicador de actividad
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .blue
            activityIndicator.center = view.center
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()

            DispatchQueue.global(qos: .userInitiated).async {
                
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
                    guard let self = self else {return}
                    
                    DispatchQueue.main.async {
                        // Ocultar el indicador de actividad
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                        
                        if error != nil {
                            
                            let alertController = UIAlertController(title: "Error", message: "Correo o contraseña incorrectos", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                            
                            self.present(alertController, animated: true, completion: nil)
                        } else if let user = authResult?.user {
                            self.verifyUserRoleAndState(user, email: email)
                        }
                    }
                }
            }
        }
    }
    
    func verifyUserRoleAndState(_ user: User, email: String){
        let userRef = Firestore.firestore().collection("users").document(user.uid)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let userData = document.data() {
                    let userState = userData["estado"] as? String
                    if let rolRef = userData["rol"] as? DocumentReference {
                        rolRef.getDocument { (rolDocument, error) in
                            if let rolDocument = rolDocument, rolDocument.exists {
                                if let rolData = rolDocument.data() {
                                    if let userRole = rolData["id"] as? String {
                                        if userRole == "admin" {
                                            if userState == "aprobado" {
                                                let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
                                                let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
                                                
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            } else {
                                                let alertController = UIAlertController(title: "Error", message: "Aún no has sido aprobado", preferredStyle: .alert)
                                                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                                
                                                self.present(alertController, animated: true, completion: nil)
                                            }
                                        } else {
                                            let alertController = UIAlertController(title: "Error", message: "No eres un administrador", preferredStyle: .alert)
                                            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                            
                                            self.present(alertController, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Error", message: "Correo o contraseña incorrectos", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    // Método para ocultar el teclado cuando se toca en otra parte de la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func olvidarContrasenaAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RecuperarContrasenaViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RecuperarContrasenaViewController")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

