//
//  BookingServiceCell.swift
//  StyleOn
//
//  Created by Oscar Barbosa on 11/23/20.
//  Copyright © 2020 Ramses Machado. All rights reserved.
//

import UIKit

class BookingServiceCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var dateHard: UILabel!
    @IBOutlet weak var timeHard: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func set(bookingServicePost:BookingService) {
        
        ImageService.getImage(withURL: bookingServicePost.postURL) { image in
            self.postImage.image = image
        }
        dateHard.text = "Date: "
        timeHard.text = "Time: "
        address.text = bookingServicePost.address
        date.text = bookingServicePost.date
        time.text = bookingServicePost.time
    }
}
