//  CometChatSharedMediaItem.swift
//  CometChatUIKit
//  Created by CometChat Inc. on 20/09/19.
//  Copyright ©  2019 CometChat Inc. All rights reserved.


// MARK: - Importing Frameworks.

import UIKit
import AVFoundation
import CoreMedia
import CometChatPro

/*  ----------------------------------------------------------------------------------------- */


class CometChatStickerKeyboardItem: UICollectionViewCell {
    
    // MARK: - Declaration of Outlets.
    @IBOutlet weak var stickerIcon: UIImageView!
    var stickerSet: CometChatStickerSet! {
        didSet {
            if let url = URL(string: stickerSet.thumbnail ?? "") {
                stickerIcon.cf.setImage(with: url)
               
            }
        }
        
    }
    var sticker: CometChatSticker! {
        didSet {
            if let url = URL(string: sticker.url ?? "") {
                stickerIcon.cf.setImage(with: url)
            
            }
        }
    }
  // MARK: - Required Instance Methods.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
    }
    
}

/*  ----------------------------------------------------------------------------------------- */
