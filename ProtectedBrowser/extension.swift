//
//  extension.swift
//  ProtectedBrowser
//
//  Created by Joyson  on 18/06/20.
//  Copyright © 2020 mobishala. All rights reserved.
//

import Foundation
import UIKit
extension URL {
    static func httpURL(withString string: String) -> URL? {
        let urlString: String
        
        if (string.starts(with: "http://") || string.starts(with: "https://")) {
            urlString = string
        } else {
            urlString = "http://" + string
        }
        
        return URL(string: urlString)
    }
}
extension UIViewController{
func presentAlertWithTitle(title: String, message: String, options: [AlertOptions], completion: @escaping (String) -> Void) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for (index, option) in options.enumerated() {
        alertController.addAction(UIAlertAction.init(title: option.rawValue, style: .default, handler: { (action) in
            completion(options[index].rawValue)
        }))
    }
    self.present(alertController, animated: true, completion: nil)
}
}
