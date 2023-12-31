//
//  SignUpViewController.swift
//  reto
//
//  Created by Administrador on 05/10/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    let db=Firestore.firestore()

    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var ojoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message":"Integración de Firebase completa"])
        
        ojoButton.setTitle("", for: .normal)
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

    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        let rolRef = Firestore.firestore().collection("roles").document("admin")
        let estado = "pendiente"
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let repassword = repasswordTextField.text ?? ""
        let nombre = nombreTextField.text ?? ""
        let passwordPattern = "^(?=.*[0-9].*[0-9])(?=.*[!@#\\$%^&*])(?=\\S+$).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
        let isPasswordValid = passwordTest.evaluate(with: password)
        
        // Mostrar un indicador de actividad
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .blue
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if !nombre.isEmpty {
            if !password.isEmpty {
                if !email.isEmpty {
                    if isPasswordValid {
                        if password == repassword {
                            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                
                                // Ocultar el indicador de actividad
                                activityIndicator.stopAnimating()
                                activityIndicator.removeFromSuperview()
                                
                                if error != nil {
                                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error registrando el usuario", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                } else if let uid = authResult?.user.uid {
                                    let userData = [
                                        "email": email,
                                        "Nombre": nombre,
                                        "rol": rolRef,
                                        "estado": estado
                                    ]
                                    
                                    self.db.collection("users").document(uid).setData(userData) { error in
                                        if error != nil {
                                            let alertController = UIAlertController(title: "Error", message: "Error al guardar los datos", preferredStyle: .alert)
                                            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                            
                                            self.present(alertController, animated: true, completion: nil)
                                        } else {
                                            self.navigationController?.pushViewController(ConfirmacionViewController(email: email), animated: true)
                                        }
                                    }
                                } else {
                                    let alertController = UIAlertController(title: "Error", message: "Error al obtener el ID del usuario", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }else{
                            // Ocultar el indicador de actividad
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                            
                            let alertController = UIAlertController(title: "Error", message: "Las contraseñas deben coincidir", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }else {
                        // Ocultar el indicador de actividad
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()

                        let alertController = UIAlertController(title: "Error", message: "La contraseña no cumple con los requisitos: debe tener al menos 8 caracteres, 2 números y un carácter especial.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else {
                    // Ocultar el indicador de actividad
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()

                    let alertController = UIAlertController(title: "Error", message: "El campo de correo electrónico es obligatorio", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }else {
                // Ocultar el indicador de actividad
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()

                let alertController = UIAlertController(title: "Error", message: "El campo de contraseña es obligatorio", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            // Ocultar el indicador de actividad
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()

            let alertController = UIAlertController(title: "Error", message: "El campo de nombre es obligatorio", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func logInAction(_ sender: Any) {
        let viewLogIn = LogInViewController()
        
        self.navigationController?.pushViewController(viewLogIn, animated: true)
    }
    
    // Método para ocultar el teclado cuando se toca en otra parte de la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func ojoButton(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "ojo" : "ojocerrado"
        self.ojoButton.setImage(UIImage(named: imageName), for:.normal)
    }
    
}

