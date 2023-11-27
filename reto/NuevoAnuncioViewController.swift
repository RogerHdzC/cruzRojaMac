//
//  NuevoAnuncioViewController.swift
//  reto
//
//  Created by Administrador on 13/11/23.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class NuevoAnuncioViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let db = Firestore.firestore()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var anuncioTitle: UITextField!
    @IBOutlet weak var esEvento: UISwitch!
    @IBOutlet weak var horasMax: UITextField!
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var horasLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageView.image == nil {
            guard let urlString = UserDefaults.standard.value(forKey: "url") as? String, let url = URL(string: urlString) else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.imageView.image = image
                }
            })
            task.resume()
        }
    }
    
    
    @IBAction func uploadFlyer(_ sender: Any) {
        
        imageView.image = nil

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true,completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        // GENERA ID PARA EL NOMBRE DEL ARCHIVO
        let uniqueIdentifier = UUID().uuidString
        let fileName = "anuncios/\(uniqueIdentifier).png"
        // Subir datos de imagen a Firebase Storage
        storage.child(fileName).putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error al subir imagen a Firebase Storage: \(error.localizedDescription)")
                return
            }
            
            // Obtener la URL de descarga
            self.storage.child(fileName).downloadURL { (url, error) in
                if let error = error as? StorageError {
                    switch error {
                    case .objectNotFound:
                        print("Objeto no encontrado en Firebase Storage.")
                    case .unauthorized:
                        print("Acceso no autorizado a Firebase Storage.")
                    default:
                        print("Error al obtener la URL de descarga: \(error.localizedDescription)")
                    }
                    return
                }
                
                guard let url = url else {
                    print("La URL de descarga es nula.")
                    return
                }
                
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                
                UserDefaults.standard.set(urlString, forKey: "url")
                print("URL guardada en UserDefaults: \(urlString)")
            }
        }
        //SAVE URL
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Método para ocultar el teclado cuando se toca en otra parte de la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func uploadAction(_ sender: Any) {
        
        let currentUser = Auth.auth().currentUser
        let author = "/users/\(currentUser!.uid)"
        let title = anuncioTitle.text ?? ""
        let hrsMax = Int(horasMax.text ?? "") ?? 0
        let description = descripcion.text ?? ""
        let imageUrlString = UserDefaults.standard.value(forKey: "url") as? String ?? ""
        print("URL recuperada desde UserDefaults: \(imageUrlString)")
        _ = URL(string: imageUrlString)
        let currentDate = date.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fechaEvento = dateFormatter.string(from: currentDate)
        let isEvent = esEvento.isOn
        let docId = UUID().uuidString
        let fechaCreacion = Date()
        
        let anuncioData = [
            "author":author,
            "descripcion": description,
            "fechaEvento":fechaEvento,
            "hrsMax":hrsMax,
            "imagen":imageUrlString,
            "tipo":isEvent,
            "titulo":title,
            "fecha":fechaCreacion
            
        ] as [String : Any]
        
        self.db.collection("anuncios").document(docId).setData(anuncioData) { error in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: "No se cargo", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                UserDefaults.standard.removeObject(forKey: "url")

                let alertController = UIAlertController(title: "Exito", message: "Anuncio creado con éxito", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (_) in
                    // Navegar a la vista deseada después de hacer clic en "Aceptar"
                        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
                        self.navigationController?.pushViewController(vc, animated: true)
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        if (sender as AnyObject).isOn {
                // Si el interruptor está encendido (es un evento), muestra el label y el campo de horas máximas
                horasLabel.isHidden = false
                horasMax.isHidden = false
                fechaLabel.isHidden = false
                date.isHidden = false
            } else {
                // Si el interruptor está apagado (no es un evento), oculta el label y el campo de horas máximas
                horasLabel.isHidden = true
                horasMax.isHidden = true
                fechaLabel.isHidden = true
                date.isHidden = true
            }
    }
}
