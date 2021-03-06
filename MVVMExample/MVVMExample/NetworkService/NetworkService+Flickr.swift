//
//  NetworkService+Flickr.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/25/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation
import MVVM
import RxSwift

extension NetworkService {
    
    func search(withKeyword keyword: String, page: Int) -> Single<FlickrSearchResponse?>{
        let parameters: [String: Any] = [
                   "method": "flickr.photos.search",
                   "api_key": "dc4c20e9d107a9adfa54917799e44650", // please provide your API key
                   "format": "json",
                   "nojsoncallback": 1,
                   "page": page,
                   "per_page": 10,
                   "text": keyword
               ]
        
        return Single.create { single in
            self.request(withService: APIService.searchFlickr(parameters: parameters), withHash: true, usingCache: true)
                .map({ (jsonData) -> FlickrSearchResponse? in
                    if let dictionary = jsonData.dictionaryObject,
                        let flickrSearchResponse = FlickrSearchResponse(JSON: dictionary) {
                        return flickrSearchResponse
                    }
                    return nil
                }).subscribe(onSuccess: { (flickrSearchResponse) in
                    if let response = flickrSearchResponse {
                        single(.success(response))
                    } else {
                        single(.success(nil))
                    }
                }) { (error) in
                    single(.error(error))
            } => self.tmpBag
            
            return Disposables.create { self.tmpBag = DisposeBag() }
        }
        
    }
    
}
