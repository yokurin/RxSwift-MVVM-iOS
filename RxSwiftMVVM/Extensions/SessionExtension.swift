//
//  SessionExtension.swift
//  RxSwiftMVVM
//
//  Created by Tsubasa Hayashi on 2019/04/29.
//  Copyright © 2019 Tsubasa Hayashi. All rights reserved.
//

import Foundation
import RxSwift
import APIKit

extension Session: ReactiveCompatible {}

extension Reactive where Base: Session {
    func send<T: Request>(_ request: T) -> Single<T.Response> {
        return Single<T.Response>.create { [weak base] observer -> Disposable in
            #if DEBUG
            print("------------ Start API Request ------------")
            print("url == \(request.baseURL.absoluteString)\(request.path)")
            if let parameters = request.parameters {
                print("parameters == \(parameters)")
            }
            if let body = request.bodyParameters as? MultipartFormDataBodyParameters {
                print("body parameters")
                body.parts.forEach {
                    print("\($0.name) == \($0.inputStream)")
                }
            }
            print("-------------------------------------------")
            #endif
            let task = base?.send(request) { result in
                switch result {
                case .success(let value):
                    #if DEBUG
                    print("------------ Success API Request ------------")
                    print("\(value)")
                    print("---------------------------------------------")
                    #endif

                    observer(.success(value))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create { task?.cancel() }
        }
    }
}
