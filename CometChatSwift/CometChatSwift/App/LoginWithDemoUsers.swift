//
//  ViewController.swift
//  Demo
//
//  Created by CometChat Inc. on 16/12/19.
//  Copyright © 2020 CometChat Inc. All rights reserved.
//

import UIKit
import CometChatPro

class LoginWithDemoUsers: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var superHero1View: UIView!
    @IBOutlet weak var superHero2View: UIView!
    @IBOutlet weak var superHero3View: UIView!
    @IBOutlet weak var superHero4View: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
      
    }
    

    
    fileprivate func addObservers(){
        let tapOnSuperHero1 = UITapGestureRecognizer(target: self, action: #selector(LoginWithSuperHero1(tapGestureRecognizer:)))
        superHero1View.isUserInteractionEnabled = true
        superHero1View.addGestureRecognizer(tapOnSuperHero1)
        
        let tapOnSuperHero2 = UITapGestureRecognizer(target: self, action: #selector(LoginWithSuperHero2(tapGestureRecognizer:)))
        superHero2View.isUserInteractionEnabled = true
        superHero2View.addGestureRecognizer(tapOnSuperHero2)
        
        let tapOnSuperHero3 = UITapGestureRecognizer(target: self, action: #selector(LoginWithSuperHero3(tapGestureRecognizer:)))
        superHero3View.isUserInteractionEnabled = true
        superHero3View.addGestureRecognizer(tapOnSuperHero3)
        
        let tapOnSuperHero4 = UITapGestureRecognizer(target: self, action: #selector(LoginWithSuperHero4(tapGestureRecognizer:)))
        superHero4View.isUserInteractionEnabled = true
        superHero4View.addGestureRecognizer(tapOnSuperHero4)
    }
    
    @objc func LoginWithSuperHero1(tapGestureRecognizer: UITapGestureRecognizer)
    {
        loginWithUID(UID: "superhero1")
    }
    
    @objc func LoginWithSuperHero2(tapGestureRecognizer: UITapGestureRecognizer)
    {
        loginWithUID(UID: "superhero2")
    }
    
    @objc func LoginWithSuperHero3(tapGestureRecognizer: UITapGestureRecognizer)
    {
        loginWithUID(UID: "superhero3")
    }
    
    @objc func LoginWithSuperHero4(tapGestureRecognizer: UITapGestureRecognizer)
    {
        loginWithUID(UID: "superhero4")
    }
    
    
    private func loginWithUID(UID:String){
        
        activityIndicator.startAnimating()
        if(Constants.authKey.contains(NSLocalizedString("Enter", comment: "")) || Constants.authKey.contains(NSLocalizedString("ENTER", comment: "")) || Constants.authKey.contains("NULL") || Constants.authKey.contains("null") || Constants.authKey.count == 0){
            showAlert(title: NSLocalizedString("Warning!", comment: ""), msg: NSLocalizedString("Please fill the APP-ID and AUTH-KEY in Constants.swift file.", comment: ""))
        }else{
            
            CometChat.login(UID: UID, apiKey: Constants.authKey, onSuccess: { (current_user) in
                let userID:String = current_user.uid!
                print("current_user: \(current_user.stringValue())")
                UserDefaults.standard.set(userID, forKey: "LoggedInUserUID")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
                    let navigationController: UINavigationController = UINavigationController(rootViewController: mainVC)
                    navigationController.modalPresentationStyle = .fullScreen
                    navigationController.title = "CometChat KitchenSink"
                    navigationController.navigationBar.prefersLargeTitles = true
                    if #available(iOS 13.0, *) {
                        let navBarAppearance = UINavigationBarAppearance()
                        navBarAppearance.configureWithOpaqueBackground()
                        navBarAppearance.titleTextAttributes = [ .foregroundColor:  UIColor.label,.font: UIFont.boldSystemFont(ofSize: 20) as Any]
                        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label, .font: UIFont.boldSystemFont(ofSize: 30) as Any]
                        navBarAppearance.shadowColor = .clear
                        navBarAppearance.backgroundColor = .systemBackground
                        navigationController.navigationBar.standardAppearance = navBarAppearance
                        navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
                        self.navigationController?.navigationBar.isTranslucent = false
                    }
                    self.present(navigationController, animated: true, completion: nil)
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    DispatchQueue.main.async {
                        if error.errorCode.isLocalized {
                            CometChatSnackBoard.display(message:  error.errorCode.localized() , mode: .error, duration: .short)
                        }else{
                            CometChatSnackBoard.display(message:  error.errorDescription , mode: .error, duration: .short)
                        }
                    }
                }
                print("login errorDescription \(error.errorDescription)")
                print("login errorCode \(error.errorCode)")
            }
        }
    }
}

