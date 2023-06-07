//
//  FetchPostRepository.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 7/6/23.
//

import Foundation

protocol FetchPostsRepository {
    func fetchPosts(url: String) async throws -> PostsDecodable
}

class DefaultFetchPostsRepository: FetchPostsRepository {
    
    // Dependencies
    private let apiService: ApiService?
    
    init(apiService: ApiService = DefaultApiService()) {
        self.apiService = apiService
    }
    
    func fetchPosts(url: String) async throws -> PostsDecodable {
        let task = Task { () -> PostsDecodable in
            do {
                guard let data = try await apiService?.getDataFromGetRequest(with: url) else {
                    throw AppError.unExpectedError
                }
                let decodable = try JSONDecoder().decode(PostsDecodable.self, from: data)
                return decodable
            } catch {
                throw error
            }
        }
        
        return try await task.value
    }
}
