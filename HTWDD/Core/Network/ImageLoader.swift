//
//  ImageLoader.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 12.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private var cache = NSCache<NSURL, UIImage>()
    
    func loadImage(`for` url: URL) -> Observable<UIImage?> {
        let nsURL = url as NSURL
        if let saved = cache.object(forKey: nsURL) {
            return Observable.just(saved)
        }
        let req = URLRequest(url: url)
        return URLSession.shared.rx.data(request: req)
            .map { [weak self] data -> UIImage? in
                guard let image = UIImage(data: data) else {
                    return nil
                }
                self?.cache.setObject(image, forKey: nsURL)
                return image
            }
    }
    
}

private var disposableKey: UInt8 = 0

extension UIImageView {
    fileprivate var disposable: Disposable? {
        get { return objc_getAssociatedObject(self, &disposableKey) as? Disposable }
        set { objc_setAssociatedObject(self, &disposableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension HTWNamespace where Base: UIImageView {
    
    func loadImage(url: URL?, loading: UIImage, fallback: UIImage) {
        self.base.image = loading
        self.base.disposable?.dispose()
        guard let url = url else {
            self.base.image = fallback
            return
        }
        self.base.disposable = ImageLoader.shared
            .loadImage(for: url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak base] image in
                base?.image = image ?? fallback
            }, onError: { [weak base] _ in
                base?.image = fallback
            })
    }
    
}
