
//  RightTextMessageBubble.swift
//  CometChatUIKit
//  Created by CometChat Inc. on 20/09/19.
//  Copyright ©  2020 CometChat Inc. All rights reserved.


// MARK: - Importing Frameworks.

import UIKit
import CometChatPro



/*  ----------------------------------------------------------------------------------------- */

class RightTextMessageBubble: UITableViewCell {
    
    // MARK: - Declaration of IBInspectable
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var replybutton: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var receipt: UIImageView!
    @IBOutlet weak var receiptStack: UIStackView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
   
    
    // MARK: - Declaration of Variables
    let systemLanguage = Locale.preferredLanguages.first
    weak var selectionColor: UIColor? {
        set {
            let view = UIView()
            view.backgroundColor = newValue
            self.selectedBackgroundView = view
        }
        get {
            return self.selectedBackgroundView?.backgroundColor ?? UIColor.white
        }
    }
    var indexPath: IndexPath?
    weak var textMessage: TextMessage? {
        didSet {
            if let textmessage  = textMessage {
                self.receiptStack.isHidden = true
                self.parseProfanityFilter(forMessage: textmessage)
                
                if textmessage.readAt > 0 {
                    receipt.image = #imageLiteral(resourceName: "read")
                    timeStamp.text = String().setMessageTime(time: Int(textMessage?.readAt ?? 0))
                }else if textmessage.deliveredAt > 0 {
                    receipt.image = #imageLiteral(resourceName: "delivered")
                    timeStamp.text = String().setMessageTime(time: Int(textMessage?.deliveredAt ?? 0))
                }else if textmessage.sentAt > 0 {
                    receipt.image = #imageLiteral(resourceName: "sent")
                    timeStamp.text = String().setMessageTime(time: Int(textMessage?.sentAt ?? 0))
                }else if textmessage.sentAt == 0 {
                    receipt.image = #imageLiteral(resourceName: "wait")
                    timeStamp.text = NSLocalizedString("SENDING", comment: "")
                }
            }
            receipt.contentMode = .scaleAspectFit
            message.textColor = .white
            
            if textMessage?.replyCount != 0 {
                replybutton.isHidden = false
                if textMessage?.replyCount == 1 {
                    replybutton.setTitle("1 reply", for: .normal)
                }else{
                    if let replies = textMessage?.replyCount {
                        replybutton.setTitle("\(replies) replies", for: .normal)
                    }
                }
            }else{
                replybutton.isHidden = true
            }
            
        }
    }
    
    weak var deletedMessage: BaseMessage? {
        didSet {
            receipt.isHidden = true
            self.replybutton.isHidden = true
            switch deletedMessage?.messageType {
            case .text:  message.text = NSLocalizedString("YOU_DELETED_THIS_MESSAGE", comment: "")
            case .image: message.text = NSLocalizedString("YOU_DELETED_THIS_IMAGE", comment: "")
            case .video: message.text = NSLocalizedString("YOU_DELETED_THIS_VIDEO", comment: "")
            case .audio: message.text =  NSLocalizedString("YOU_DELETED_THIS_AUDIO", comment: "")
            case .file:  message.text = NSLocalizedString("YOU_DELETED_THIS_FILE", comment: "")
            case .custom: message.text = NSLocalizedString("YOU_DELETED_THIS_CUSTOM_MESSAGE", comment: "")
            case .groupMember: break
            @unknown default: break }
            message.textColor = .darkGray
            message.font = UIFont (name: "SFProDisplay-RegularItalic", size: 17)
            timeStamp.text = String().setMessageTime(time: Int(deletedMessage?.sentAt ?? 0))
        }
    }
    
    
     func parseProfanityFilter(forMessage: TextMessage){
        if let metaData = textMessage?.metaData , let injected = metaData["@injected"] as? [String : Any], let cometChatExtension =  injected["extensions"] as? [String : Any], let profanityFilterDictionary = cometChatExtension["profanity-filter"] as? [String : Any] {
            
            if let profanity = profanityFilterDictionary["profanity"] as? String, let filteredMessage = profanityFilterDictionary["message_clean"] as? String {
                
                if profanity == "yes" {
                    message.text = filteredMessage
                }else{
                    message.text = forMessage.text
                }
            }else{
                message.text = forMessage.text
            }
        }else{
            
            if forMessage.text.containsOnlyEmojis() {
                if forMessage.text.count == 1 {
                   message.font = UIFont (name: "SFProDisplay-Regular", size: 51)
                }else if forMessage.text.count == 2 {
                   message.font = UIFont (name: "SFProDisplay-Regular", size: 34)
                }else if forMessage.text.count == 3{
                   message.font = UIFont (name: "SFProDisplay-Regular", size: 25)
                }else{
                   message.font = UIFont (name: "SFProDisplay-Regular", size: 17)
                }
                print("contains only emoji: \(forMessage.text.count)")
            }else{
               message.font = UIFont (name: "SFProDisplay-Regular", size: 17)
            }
            self.message.text = forMessage.text
        }
    }

    
    // MARK: - Initialization of required Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 13.0, *) {
            selectionColor = .systemBackground
        } else {
            selectionColor = .white
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if #available(iOS 13.0, *) {
            
        } else {
            messageView.backgroundColor =  #colorLiteral(red: 0.2, green: 0.6, blue: 1, alpha: 1)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if #available(iOS 13.0, *) {
            
        } else {
            messageView.backgroundColor =  #colorLiteral(red: 0.2, green: 0.6, blue: 1, alpha: 1)
        }
        
    }
    
    @IBAction func didReplyButtonPressed(_ sender: Any) {
         if let message = textMessage, let indexpath = indexPath {
             CometChatThreadedMessageList.threadDelegate?.startThread(forMessage: message, indexPath: indexpath)
         }
     }
    
}

/*  ----------------------------------------------------------------------------------------- */
