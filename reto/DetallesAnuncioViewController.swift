//
//  DetallesAnuncioViewController.swift
//  reto
//
//  Created by Administrador on 15/11/23.
//

import Foundation
import UIKit

class DetallesAnuncioViewController : UIViewController {
    
    var anuncioSeleccionado: Anuncios?

    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var eventoLabel: UILabel!
    @IBOutlet weak var horasMaxLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var horMaxNoEditLabel: UILabel!
    @IBOutlet weak var fechaEventoEdit: UILabel!
    @IBOutlet weak var fechaEventoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let anuncio = anuncioSeleccionado else {                  // Manejar el caso en el que no hay anuncio seleccionado
          return
        }
        
        tituloLabel.text = anuncio.titulo
        descriptionLabel.text = anuncio.descripcion
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Puedes ajustar el formato según tus necesidades
        let fechaCreacion = dateFormatter.string(from: anuncio.fecha)
        fechaLabel.text = fechaCreacion
        if anuncio.tipo {
            eventoLabel.text = "Es un envento"
            horMaxNoEditLabel.isHidden = false
            horasMaxLabel.isHidden = false
            horasMaxLabel.text = "\(anuncio.hrsMax)"
            fechaEventoLabel.isHidden = false
            fechaEventoEdit.text = anuncio.fechaEvento
        } else{
            eventoLabel.text = "No es un evento"
            horMaxNoEditLabel.isHidden = true
            horasMaxLabel.isHidden = true
            fechaEventoEdit.isHidden = true
            fechaEventoLabel.isHidden = true
        }
        
        if let imageUrl = URL(string: anuncio.imagen) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl){
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
    }
}
