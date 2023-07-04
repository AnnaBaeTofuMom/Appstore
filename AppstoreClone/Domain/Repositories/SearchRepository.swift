//
//  SearchRepository.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import Foundation

import Moya

enum SearchTarget {
    case searchApp(term: String)
}

extension SearchTarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://itunes.apple.com/") else {
            fatalError("fatal error - invalid api url")
        }
        return url
    }

    var path: String {
        switch self {
        case .searchApp:
            return "search"
        }
    }

    var method: Moya.Method {
        switch self {
        case .searchApp:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .searchApp(let term):
            let parameters: [String: Any] = ["term": "\(term)",
                                             "entity": "software",
                                             "country": "KR"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }

    var headers: [String: String]? {
        return [:]
    }
}

final class SearchRepository {
    
    let provider: MoyaProvider<SearchTarget>
    init() { provider = MoyaProvider<SearchTarget>()
    }
    
}

extension SearchRepository {
    func requestApps(keyword: String, completion: @escaping (Result<[AppData], Error>) -> Void) {
        provider.request(.searchApp(term: keyword)) { result in
            switch result {
            case .success(let response):
                guard let apps = try? JSONDecoder().decode(SearchDTO.self, from: response.data) else { return }
                completion(.success(apps.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
