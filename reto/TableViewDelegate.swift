//
//  TableViewDelegate.swift
//  reto
//
//  Created by Administrador on 03/11/23.
//

import Foundation
import UIKit

final class TableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let model = house[indexPath.row]
        print("CELL: \(model.title)")
    }

}
