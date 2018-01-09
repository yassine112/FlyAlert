//
//  MKTableViewCell.swift
//  comboBox
//
//  Created by Fly on 04/01/2018.
//  Copyright © 2018 Fly. All rights reserved.
//

import UIKit

public class MKTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
