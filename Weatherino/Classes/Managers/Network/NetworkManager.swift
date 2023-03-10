//
//  NetworkManager.swift
//  DS-New
//
//  Created by Eugeniy on 07.04.2021.
//

import Alamofire

final class NetworkManager: Manager {

}


// MARK: - Public Methods

extension NetworkManager {

    func request<T: Decodable>(for type: T.Type, endpoint: EndPoint, completion: @escaping (Result<T, ErrorModel>) -> Void) {
        AF.request(endpoint).responseDecodable(of: T.self, completionHandler: { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(ErrorModel(error)))
            }
        })
    }

}
