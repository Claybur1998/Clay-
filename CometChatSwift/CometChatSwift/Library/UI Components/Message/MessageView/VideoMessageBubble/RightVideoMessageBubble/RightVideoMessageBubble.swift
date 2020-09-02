
//  RightVideoMessageBubble.swift
//  CometChatUIKit
//  Created by CometChat Inc. on 20/09/19.
//  Copyright ©  2019 CometChat Inc. All rights reserved.

// MARK: - Importing Frameworks.

import UIKit
import CometChatPro
import AVFoundation
import CoreMedia

/*  ----------------------------------------------------------------------------------------- */

class RightVideoMessageBubble: UITableViewCell {
    
     // MARK: - Declaration of IBInspectable
    
    @IBOutlet weak var replybutton: UIButton!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var activityIndicator: CCActivityIndicator!
    @IBOutlet weak var receipt: UIImageView!
    @IBOutlet weak var receiptStack: UIStackView!
    
    
    // MARK: - Declaration of Variables
    var indexPath: IndexPath?
    var selectionColor: UIColor {
        set {
            let view = UIView()
            view.backgroundColor = newValue
            self.selectedBackgroundView = view
        }
        get {
            return self.selectedBackgroundView?.backgroundColor ?? UIColor.clear
        }
    }
    
    var mediaMessage: MediaMessage! {
        didSet {
            receiptStack.isHidden = true
            if mediaMessage.sentAt == 0 {
                timeStamp.text = NSLocalizedString("SENDING", comment: "")
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            }else{
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                timeStamp.text = String().setMessageTime(time: mediaMessage.sentAt)
            }
            if mediaMessage.readAt > 0 && mediaMessage.receiverType == .user {
            receipt.image = #imageLiteral(resourceName: "read")
            timeStamp.text = String().setMessageTime(time: Int(mediaMessage?.readAt ?? 0))
            }else if mediaMessage.deliveredAt > 0 {
            receipt.image = #imageLiteral(resourceName: "delivered")
            timeStamp.text = String().setMessageTime(time: Int(mediaMessage?.deliveredAt ?? 0))
            }else if mediaMessage.sentAt > 0 {
            receipt.image = #imageLiteral(resourceName: "sent")
            timeStamp.text = String().setMessageTime(time: Int(mediaMessage?.sentAt ?? 0))
            }else if mediaMessage.sentAt == 0 {
               receipt.image = #imageLiteral(resourceName: "wait")
               timeStamp.text = NSLocalizedString("SENDING", comment: "")
            }
            parseThumbnailForVideo(forMessage: mediaMessage)
            
            if mediaMessage?.replyCount != 0 {
                  replybutton.isHidden = false
                if mediaMessage?.replyCount == 1 {
                    replybutton.setTitle("1 reply", for: .normal)
                }else{
                    if let replies = mediaMessage?.replyCount {
                        replybutton.setTitle("\(replies) replies", for: .normal)
                    }
                }
            }else{
                replybutton.isHidden = true
            }
        }
    }
    
     // MARK: - Initialization of required Methods
    @IBAction func didReplyButtonPressed(_ sender: Any) {
        if let message = mediaMessage, let indexpath = indexPath {
            CometChatThreadedMessageList.threadDelegate?.startThread(forMessage: message, indexPath: indexpath)
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 13.0, *) {
            selectionColor = .systemBackground
        } else {
            selectionColor = .white
        }
        
    }
    
     override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
          
       }

    
    
    /**
    This method used to set the image for RightVideoMessageBubble class
    - Parameter image: This specifies a `URL` for  the Avatar.
    - Author: CometChat Team
    - Copyright:  ©  2019 CometChat Inc.
    */
    public func set(Image: UIImageView, forURL url: String) {
        let url = URL(string: url)
        Image.cf.setImage(with: url)
    }
    
    private func parseThumbnailForVideo(forMessage: MediaMessage?) {
           imageMessage.image = nil
           if let metaData = forMessage?.metaData , let injected = metaData["@injected"] as? [String : Any], let cometChatExtension =  injected["extensions"] as? [String : Any], let thumbnailGenerationDictionary = cometChatExtension["thumbnail-generation"] as? [String : Any] {
               if let url = URL(string: thumbnailGenerationDictionary["url_medium"] as? String ?? "") {
                self.imageMessage.cf.setImage(with: url)
               }
           }else{
            imageMessage.image = UIImage(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
           }
       }
}
