//
//  AprobarHorasTableViewCell.swift
//  reto
//
//  Created by Administrador on 16/11/23.
//

import UIKit

class AprobarHorasTableViewCell: UITableViewCell {

    static let identifier = "AprobarHorasTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var hrsLabel: UILabel!
    @IBOutlet weak var eventoLabel: UILabel!
    
    var aprobarAction: (() -> Void)?
    var rechazarAction: (() -> Void)?
    
    static func nib() -> UINib {
        return UINib(nibName: "AprobarHorasTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func aprobarAction(_ sender: Any) {
        aprobarAction?()
    }
    
    
    @IBAction func rechazarAction(_ sender: Any) {
        rechazarAction?()
    }
    
}
