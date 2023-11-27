//
//  AnunciosViewController.swift
//  reto
//
//  Created by Administrador on 09/11/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

struct Anuncios{
    let author: String
    let descripcion: String
    let fecha: Date
    let fechaEvento: String
    let hrsMax: Int
    let imagen: String
    let tipo: Bool
    let titulo: String
    let documentRef: DocumentReference
}

class AnunciosViewController: UIViewController{
    let db = Firestore.firestore()
    var listasAnuncios: [Anuncios] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anunciosCollection = db.collection("anuncios")
        
        anunciosCollection.getDocuments{ [weak self] (querySnapshot, error) in guard let self = self else { return }
            
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    let author = data["author"] as? String
                    let titulo = data["titulo"] as! String
                    var fecha: Date?
                    if let timestamp = data["fecha"] as? Timestamp {
                        fecha = timestamp.dateValue()
                    }
                    let fechaEvento = data["fechaEvento"] as? String
                    let hrsMax = data["hrsMax"] as? Int
                    let imagen = data["imagen"] as? String
                    let tipo = data["tipo"] as! Bool
                    let descripcion = data["descripcion"] as? String
                    let anuncio = Anuncios(author: author ?? "", descripcion: descripcion ?? "", fecha: fecha ?? Date(), fechaEvento: fechaEvento ?? "", hrsMax: hrsMax ?? 0, imagen: imagen ?? "", tipo: tipo, titulo: titulo, documentRef: document.reference)
                    self.listasAnuncios.append(anuncio)
                }
                self.tableView.reloadData()
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AnuncioTableViewCell.nib(), forCellReuseIdentifier: AnuncioTableViewCell.identifier)
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "NuevoAnuncioViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NuevoAnuncioViewController")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AnunciosViewController : UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let anuncioSeleccionado = listasAnuncios[indexPath.row]
        let storyboard = UIStoryboard(name: "DetallesAnuncioViewController", bundle: nil) // Reemplaza "Main" con el nombre de tu storyboard
        if let detalleVC = storyboard.instantiateViewController(withIdentifier: "DetallesAnuncioViewController") as? DetallesAnuncioViewController {
            detalleVC.anuncioSeleccionado = anuncioSeleccionado
            self.navigationController?.pushViewController(detalleVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listasAnuncios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anuncioCell = tableView.dequeueReusableCell(withIdentifier: AnuncioTableViewCell.identifier, for: indexPath) as! AnuncioTableViewCell
        let anuncio = listasAnuncios[indexPath.row]
        
        anuncioCell.titleAnuncio.text = anuncio.titulo
        
        if anuncio.tipo {
            anuncioCell.evento.isHidden = false
        }else {
            anuncioCell.evento.isHidden = true
        }
            
        
        
        anuncioCell.deleteAction = { [weak self] in
            self?.deleteAction(anuncioReference: anuncio.documentRef)
        }
        
        return anuncioCell
    }
    
    func deleteAction(anuncioReference: DocumentReference) {
        let alertController = UIAlertController(title: "Confirmar eliminación", message: "¿Estás seguro de que quieres eliminar este anuncio? Esta acción es irreversible.", preferredStyle: .alert)
        
        // Agregar acciones al UIAlertController para confirmar o cancelar la eliminación
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { (_) in
            // Usuario confirmó la eliminación
            
            let anuncio = self.listasAnuncios.first { $0.documentRef == anuncioReference }
            
            // Verifica si el anuncio tiene una URL de imagen
            if let imageUrl = anuncio?.imagen,
               let fileName = URL(string: imageUrl)?.lastPathComponent.removingPercentEncoding {
                
                // Referencia al almacenamiento (storage)
                let storageRef = Storage.storage().reference().child("anuncios/\(fileName)")

                // Elimina la imagen del almacenamiento
                storageRef.delete { error in
                    if let error = error {
                        print("Error al eliminar la imagen del almacenamiento: \(error)")
                    } else {
                        print("Imagen eliminada del almacenamiento exitosamente.")
                    }
                }
            }

            // Eliminar el anuncio de Firestore
            self.db.document(anuncioReference.path).delete { (error) in
                if let error = error {
                    print("Error: \(error)")
                    let alertController = UIAlertController(title: "Error", message: "Error al eliminar el anuncio", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // Eliminar el anuncio del array después de eliminarlo en Firestore
                    if let index = self.listasAnuncios.firstIndex(where: { $0.documentRef == anuncioReference }) {
                        self.listasAnuncios.remove(at: index)
                    }

                    // Recargar la tabla para reflejar los cambios en la interfaz de usuario
                    self.tableView.reloadData()
                    
                    // Mostrar un mensaje de éxito después de eliminar el anuncio
                    let successAlert = UIAlertController(title: "Éxito", message: "Anuncio eliminado con éxito", preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(successAlert, animated: true, completion: nil)
                }
            }
        }))
        
        // Presentar el UIAlertController de confirmación
        self.present(alertController, animated: true, completion: nil)
    }

    
    
    
}
