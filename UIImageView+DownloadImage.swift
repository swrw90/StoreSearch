//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Seth Watson on 10/31/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(url: URL) -> URLSessionDownloadTask{
        let session = URLSession.shared

        //Use URLSession to load url contents into data object
        let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
            if error == nil, let url = url,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                
                //Use image from data object to update UIImage on main thread
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
            }
        })
        downloadTask.resume()
        return downloadTask
    }
}
