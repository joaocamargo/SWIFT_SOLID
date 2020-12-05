//
//  HttpClientSpy.swift
//  DataTests
//
//  Created by joao camargo on 30/11/20.
//

import Foundation
import Data


public class HttpClientSpy: HttpPostClient {
    var urls = [URL]()
    var data: Data?
    var completion: ((Result<Data,HttpError>) -> Void)?
    
    public func post(to url: URL,with data: Data?, completion: @escaping(Result<Data?,HttpError>)-> Void) {
        self.urls.append(url)
        self.data = data
        self.completion = completion
    }
    
    func completeWithError(_ error: HttpError){
        completion?(.failure(error))
    }
    
    func completeWithData(data: Data){
        completion?(.success(data))
    }
}
