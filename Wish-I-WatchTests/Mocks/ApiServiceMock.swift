//
//  ApiServiceMock.swift
//  Wish-I-WatchTests
//
//  Created by Toni Lozano Fernández on 7/6/23.
//

import Foundation
@testable import Wish_I_Watch

class MockFailureApiService: ApiService {
    func getDataFromGetRequest(with url: String) async throws -> Data {
        throw AppError.missingData
    }
}

class MockSuccessApiService: ApiService {
    func getDataFromGetRequest(with url: String) async throws -> Data {
        return PostsMock.makePostJsonMock()
    }
}

class MockEmptySearchApiService: ApiService {
    func getDataFromGetRequest(with url: String) async throws -> Data {
        return PostsMock.makePostEmptyResultJsonMock()
    }
}
