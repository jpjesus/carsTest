//
//  AutoAPI.swift
//  autoSample
//
//  Created by Jesus Alberto on 10/6/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import Moya

let apiURL = "http://api-aws-eu-qa-1.auto1-test.com/"
let apiKey = "coding-puzzle-client-449cc9d."

enum AutoAPI {
    case getManufacturer(page: Int, pageSize: Int)
    case getType(manufacturerId: Int)
}

extension AutoAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: apiURL) else {
            fatalError("base url not configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getManufacturer(_,_):
            return "v1/cart-types/manufacturer"
        case .getType:
            return "v1/cart-types/main-types"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getManufacturer(_,_), .getType:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getManufacturer(_,_), .getType:
            guard let url = Bundle.main.url(forResource: "taxiList", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    
    var task: Task {
        switch self {
        case .getManufacturer(let page,let pageSize):
            var params: [String: Any] = [:]
            params ["page"] = page
            params ["pageSize"] = pageSize
            params ["wa_key"] = apiKey
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getType(let manufacturerId):
            var params: [String: Any] = [:]
            params["manufacture"] = manufacturerId
            params ["page"] = 0
            params ["pageSize"] = 10
            params ["wa_key"] = apiKey
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}

