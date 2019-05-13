//
//  LoginTest.swift
//  InfinityChess2018
//
//  Created by Administrator on 13/05/2019.
//

import Foundation
import UIKit


class PlayFabLogin {
    
    let username : String
    let password : String
    let fc = FirstVC()
    
    let hud = JGProgressHUD(style: .dark)
    
    init(username : String, password : String) {
        self.username = username
        self.password = password
    }
    
    func hello() -> Void {
        fc.checkForLogin()
        
    }
}

class LoginFB: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fc = FirstVC()
        
        fc.checkForLogin()
        
        
    }
    
}
