//
//  HttpPostClient.swift
//  Data
//
//  Created by joao camargo on 21/11/20.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL,with data: Data?, completion: @escaping(Result<Data,HttpError>)->Void)
}
