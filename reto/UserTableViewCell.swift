//
//  UserTableViewCell.swift
//  reto
//
//  Created by Administrador on 06/11/23.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "UserTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var approveAction: (() -> Void)?
    
    static func nib() -> UINib {
        return UINib(nibName: "UserTableViewCell", bundle: nil)
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
        approveAction?()

    }
}
