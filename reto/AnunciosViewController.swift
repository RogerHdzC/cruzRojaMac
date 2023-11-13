//
//  AnunciosViewController.swift
//  reto
//
//  Created by Administrador on 09/11/23.
//

import Foundation
import UIKit
import FirebaseFirestore

struct Anuncios{
    let descripcion: String
    let fecha: Date
    let hrsMax: String
    let imagen: String
    let tipo: Int
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
                    let titulo = data["titulo"] as! String
                    var fecha: Date?
                    if let timestamp = data["fecha"] as? Timestamp {
                        let fecha = timestamp.dateValue()
                    }
                    let hrsMax = data["hrsMax"] as? String
                    let imagen = data["imagen"] as! String
                    let tipo = data["tipo"] as! Int
                    let descripcion = data["descripcion"] as! String
                    let anuncio = Anuncios(descripcion: descripcion, fecha: fecha ?? Date(), hrsMax: hrsMax ?? "", imagen: imagen, tipo: tipo, titulo: titulo, documentRef: document.reference)
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
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listasAnuncios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anuncioCell = tableView.dequeueReusableCell(withIdentifier: AnuncioTableViewCell.identifier, for: indexPath) as! AnuncioTableViewCell
        let anuncio = listasAnuncios[indexPath.row]
        
        anuncioCell.titleAnuncio.text = anuncio.titulo
        
        anuncioCell.deleteAction = { [weak self] in
            self?.deleteAction(anuncioReference: anuncio.documentRef)
        }
        
        return anuncioCell
    }
    
    func deleteAction(anuncioReference: DocumentReference) {
        db.document(anuncioReference.path).delete { (error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: "Error al eliminar el anuncio", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }else {
                // Eliminar el anuncio del array después de eliminarlo en Firestore
                if let index = self.listasAnuncios.firstIndex(where: { $0.documentRef == anuncioReference }) {
                    self.listasAnuncios.remove(at: index)
                }

                // Recargar la tabla para reflejar los cambios en la interfaz de usuario
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    
}
