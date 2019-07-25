//
//  instructorsCell.swift
//  SimprokDigitalTest
//
//  Created by md760 on 7/15/19.
//  Copyright © 2019 md760. All rights reserved.
//

import UIKit

final class InstructorsCell: UICollectionViewCell {

    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var heartButton: UIButton!
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var starImage: UIImageView!
    
    var model: InstructorsModel? {
        didSet {
            guard let data = model else { return }
            starImage.tintColor = .yellow
            loginLabel.text = data.login
            typeLabel.text = data.type
            idLabel.text = String(data.id ?? 0.0)
            if data.siteAdmin ?? false {
                heartButton.backgroundColor = #colorLiteral(red: 0.2392107546, green: 0.3341486156, blue: 0.6612624526, alpha: 1)
                heartButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                heartButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                heartButton.tintColor = #colorLiteral(red: 0.2392107546, green: 0.3341486156, blue: 0.6612624526, alpha: 1)
            }
            let url = URL(string: data.avatarUrl ?? "http://ohno.fr/")
            profileImage.downloadedFrom(url: url!)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        idLabel.text = nil
        loginLabel.text = nil
        typeLabel.text = nil
    }
}
