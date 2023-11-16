//
//  UserHorasTableViewCell.swift
//  reto
//
//  Created by Administrador on 16/11/23.
//

import UIKit

class UserHorasTableViewCell: UITableViewCell {
    
    static let identifier = "UserHorasTableViewCell"
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var hrsLabel: UILabel!
    
    static func nib() -> UINib {
         return UINib(nibName: "UserHorasTableViewCell", bundle: nil)
     }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    func setCellColor(isEven: Bool){
        let colorHex = isEven ? "#EE140A" : "#E56963"  // Cambia los valores hexadecimales según tus necesidades
        backgroundColor = UIColor(hex: colorHex)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
