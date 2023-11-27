//
//  AprobarHorasViewController.swift
//  reto
//
//  Created by Administrador on 16/11/23.
//

import Foundation
import UIKit
import FirebaseFirestore

struct horasVoluntarios {
    let aprobadas: Bool
    let estatus: String
    let evento: String
    let evidencia: String
    let hrs: Int
    let idVoluntario: String
    let horasRef: DocumentReference

}

class AprobarHorasViewController : UIViewController {
    let db = Firestore.firestore()
    var listasHoras: [horasVoluntarios] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let horasCollection = db.collection("horasVoluntarios")
        
        horasCollection.whereField("aprobadas", isEqualTo: false).getDocuments{ [weak self] (querySnapshot, error)
            in guard let self = self else { return }
            
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let aprobadas = data["aprobadas"] as! Bool
                    let estatus = data["estatus"] as! String
                    let evento = data["evento"] as! String
                    let evidencia = data["evidencia"] as? String
                    let hrs = data["hrs"] as! Int
                    let idVoluntario = data["idVoluntario"] as! String
                    let horas = horasVoluntarios(aprobadas: aprobadas, estatus: estatus, evento: evento, evidencia: evidencia ?? "", hrs: hrs, idVoluntario: idVoluntario, horasRef: document.reference)
                    self.listasHoras.append(horas)
                }
                self.tableView.reloadData()
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AprobarHorasTableViewCell.nib(), forCellReuseIdentifier: AprobarHorasTableViewCell.identifier)
    }
}

extension AprobarHorasViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let horaSeleccionado = listasHoras[indexPath.row]
        let storyborad = UIStoryboard(name: "DetallesAprobarHorasViewController", bundle: nil)
        if let detalleVC = storyborad.instantiateViewController(withIdentifier: "DetallesAprobarHorasViewController") as? DetallesAprobarHorasViewController {
            detalleVC.horaSeleccionado = horaSeleccionado
            self.navigationController?.pushViewController(detalleVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listasHoras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let horasCell = tableView.dequeueReusableCell(withIdentifier: AprobarHorasTableViewCell.identifier, for: indexPath) as! AprobarHorasTableViewCell
        let horas = listasHoras[indexPath.row]
        
        let eventoRef = self.db.collection("anuncios").document(horas.evento)

            eventoRef.getDocument { (eventoDoc, error) in

                guard let eventoDoc = eventoDoc, error == nil else {
                    // Manejar el error aquí si es necesario
                    return
                }

                let eventoData = eventoDoc.data()
                let nombreEvento = eventoData?["titulo"] as? String ?? ""
                
                horasCell.eventoLabel.text = nombreEvento
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
            horasCell.nameLabel.text = nombreVoluntario
            horasCell.idLabel.text = ideVoluntario
        }

        horasCell.hrsLabel.text = "\(horas.hrs)"
        
        horasCell.aprobarAction = { [weak self] in
            self?.aprobarAction(horas: horas)
        }
        
        horasCell.rechazarAction = { [weak self] in
            self?.rechazarAction(horas: horas)
        }
        
        
        return horasCell
    }
    
    func aprobarAction(horas: horasVoluntarios) {
        let alertController = UIAlertController(title: "Confirmación", message: "¿Estás seguro de que deseas aprobar estas horas? Esta acción es irreversible.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Agregar acción de aprobar
       let aprobarAction = UIAlertAction(title: "Aprobar", style: .default) { [weak self] (_) in
           // Aquí llamamos a la función que realiza la lógica de aprobar
           self?.actualizarHorasAprobadas(horas: horas)
       }
       alertController.addAction(aprobarAction)
    
        present(alertController, animated: true, completion: nil)

    }
    func rechazarAction(horas: horasVoluntarios){
        let alertController = UIAlertController(title: "Confirmación", message: "¿Estás seguro de que deseas rechazar estas horas? Esta acción es irreversible.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Agregar acción de aprobar
       let aprobarAction = UIAlertAction(title: "Rechazar", style: .default) { [weak self] (_) in
           // Aquí llamamos a la función que realiza la lógica de aprobar
           self?.actualizarHorasRechazadas(horas: horas)
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
            }
            
        }
        if let index = self.listasHoras.firstIndex(where: { $0.horasRef == horas.horasRef }) {
            self.listasHoras.remove(at: index)
        }
        self.tableView.reloadData()
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
        if let index = self.listasHoras.firstIndex(where: { $0.horasRef == horas.horasRef }) {
            self.listasHoras.remove(at: index)
        }
        self.tableView.reloadData()
    }
}
