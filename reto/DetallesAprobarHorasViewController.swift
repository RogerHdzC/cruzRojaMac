//
//  DetallesAprobarHorasViewController.swift
//  reto
//
//  Created by Administrador on 22/11/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class DetallesAprobarHorasViewController : UIViewController {
    let db = Firestore.firestore()
    var horaSeleccionado: horasVoluntarios?
    
    @IBOutlet weak var nombreVoluntario: UILabel!
    @IBOutlet weak var idVoluntario: UILabel!
    @IBOutlet weak var nombreEvento: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var horasAprobar: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let horas = horaSeleccionado else {
            return
        }
        
        let eventoRef = self.db.collection("anuncios").document(horas.evento)

            eventoRef.getDocument { (eventoDoc, error) in

                guard let eventoDoc = eventoDoc, error == nil else {
                    // Manejar el error aquí si es necesario
                    return
                }

                let eventoData = eventoDoc.data()
                let nameEvento = eventoData?["titulo"] as? String ?? ""
                
                self.nombreEvento.text = nameEvento
            }

        let voluntarioRef = self.db.collection("users").document(horas.idVoluntario)

        voluntarioRef.getDocument { (voluntario, error) in

            guard let voluntario = voluntario, error == nil else {
                // Manejar el error aquí si es necesario
                return
            }

            let voluntarioData = voluntario.data()
            let nombreVoluntario = voluntarioData?["nombre"] as? String ?? ""
            let ideVoluntario = voluntarioData?["matricula"] as? String ?? ""
            self.nombreVoluntario.text = "Voluntario: \(nombreVoluntario)"
            self.idVoluntario.text = ideVoluntario
        }

        self.horasAprobar.text = "Horas Aprobar \(horas.hrs)"
        
        if let imageUrl = URL(string: horas.evidencia) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl){
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func aprobarHoras(_ sender: Any) {
        let alertController = UIAlertController(title: "Confirmación", message: "¿Estás seguro de que deseas aprobar estas horas? Esta acción es irreversible.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Agregar acción de aprobar
       let aprobarAction = UIAlertAction(title: "Aprobar", style: .default) { [weak self] (_) in
           // Aquí llamamos a la función que realiza la lógica de aprobar
           if let horasSeleccionado = self?.horaSeleccionado {
               self?.actualizarHorasAprobadas(horas: horasSeleccionado)
           }
       }
       alertController.addAction(aprobarAction)
    
        present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func rechazarHoras(_ sender: Any) {
        let alertController = UIAlertController(title: "Confirmación", message: "¿Estás seguro de que deseas rechazar estas horas? Esta acción es irreversible.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Agregar acción de aprobar
       let aprobarAction = UIAlertAction(title: "Rechazar", style: .default) { [weak self] (_) in
           // Aquí llamamos a la función que realiza la lógica de aprobar
           if let horasSeleccionado = self?.horaSeleccionado {
               self?.actualizarHorasRechazadas(horas: horasSeleccionado)
           }
       }
       alertController.addAction(aprobarAction)
    
        present(alertController, animated: true, completion: nil)

    }
        
    func actualizarHorasRechazadas(horas: horasVoluntarios) {
        let updateData: [String: Any] = [
            "estatus": "rechazadas",
            "aprobadas": true
        ]
        
        horas.horasRef.updateData(updateData) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully update")
                self.redirigirAOtroStoryboard()

            }
            
        }
    }
    
    func actualizarHorasAprobadas(horas: horasVoluntarios) {
        // Actualizar el estatus, aprobadas y la cantidad de horas en la colección horasVoluntarios
        let updateData: [String: Any] = [
            "estatus": "aprobadas",
            "aprobadas": true
            // Puedes agregar más campos según sea necesario
        ]
        
        horas.horasRef.updateData(updateData) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                self.redirigirAOtroStoryboard()

            }
        }
        
        // Obtener las horas acumuladas actuales del voluntario
        let voluntarioRef = db.collection("users").document(horas.idVoluntario)
        
        voluntarioRef.getDocument { (voluntario, error) in
            guard let voluntario = voluntario, error == nil else {
                // Manejar el error aquí si es necesario
                return
            }
            
            var voluntarioData = voluntario.data()
            var horasAcumuladas = voluntarioData?["hrsAcumuladas"] as? Int ?? 0
            
            // Sumar las nuevas horas a las horas acumuladas
            horasAcumuladas += horas.hrs
            
            // Actualizar las horas acumuladas en la colección users
            voluntarioData?["hrsAcumuladas"] = horasAcumuladas
            
            voluntarioRef.setData(voluntarioData!) { error in
                if let error = error {
                    print("Error updating volunteer document: \(error)")
                } else {
                    print("Volunteer document successfully updated")
                }
            }
        }
    }
    
    func redirigirAOtroStoryboard() {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
