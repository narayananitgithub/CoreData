//
//  UserCell.swift
//  Coredata
//
//  Created by Narayanasamy on 13/08/23.
//

import UIKit

class Usercell: UITableViewCell {
    
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var firstNamelbl: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: UserEntity? {
        didSet {
            userConfiguration()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func userConfiguration() {
        
        guard let user else { return }
        
        firstNamelbl.text = (user.firstName ?? "") + "" + (user.lastName ?? "")// tittle
        emailLabel.text = "Email:\(user.email ?? "")" // subtittle
        
        let imageURL = URL.documentsDirectory.appending(components: user.imageName ?? "").appendingPathExtension("png")
        profileImgView.image = UIImage(contentsOfFile: imageURL.path ?? "")
        
        
        
    }
    
}
