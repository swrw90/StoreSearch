//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Seth Watson on 10/25/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    //    MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("awake from nib")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
