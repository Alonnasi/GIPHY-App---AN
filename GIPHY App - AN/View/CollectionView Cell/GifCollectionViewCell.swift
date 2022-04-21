//
//  GifCollectionViewCell.swift
//  GIPHY App - AN
//
//  Created by Alon Nasi on 18  2022.
//

import UIKit
import SwiftyGif

class GifCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setupCell(gifUrl: String) {
        guard let url = URL(string: gifUrl) else {
            return
        }
        cellImageView.setGifFromURL(url)
    }
    
}
