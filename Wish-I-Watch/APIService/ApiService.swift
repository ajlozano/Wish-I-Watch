//
//  ApiService.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 7/6/23.
//

import Foundation

protocol ApiService {
    func getDataFromGetRequest(with url: String) async throws -> Data
}

class DefaultApiService: ApiService {
    func getDataFromGetRequest(with url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw AppError.invalidUrl
        }
        
        let (data,_) = try await URLSession.shared.data(from: url)
        return data
    }
}
