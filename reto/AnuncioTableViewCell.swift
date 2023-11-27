//
//  AnuncioTableViewCell.swift
//  reto
//
//  Created by Administrador on 09/11/23.
//

import UIKit

class AnuncioTableViewCell: UITableViewCell {
    
    static let identifier = "AnuncioTableViewCell"
    
    @IBOutlet weak var titleAnuncio: UILabel!
    
    @IBOutlet weak var evento: UILabel!
    var deleteAction: (() -> Void)?
    
    static func nib() -> UINib {
        return UINib(nibName: "AnuncioTableViewCell", bundle: nil)
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
    
    
    @IBAction func deleteAction(_ sender: Any) {
        deleteAction?()
    }
    
}
