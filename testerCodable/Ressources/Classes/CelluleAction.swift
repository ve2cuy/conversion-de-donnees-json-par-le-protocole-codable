//
//  CelluleAction.swift
//  testerCodable
//
//  Created by Alain on 17-10-25.
//  Copyright © 2017 Alain. All rights reserved.
//

import UIKit

class CelluleAction: UITableViewCell {

    @IBOutlet weak var actionValeur: UILabel!
    @IBOutlet weak var actionTitre: UILabel!
    @IBOutlet weak var actionCode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
