//
//  SearchAppUseCase.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import Foundation

import RxRelay

class SearchAppUseCase {
    let repository = SearchRepository()
    let searchResult = PublishRelay<[AppData]>()
    let error = PublishRelay<Error>()
    
    func requestSearch(keyword: String) {
        repository.requestApps(keyword: keyword) { response in
            switch response {
            case .success(let apps):
                self.searchResult.accept(apps)
            case .failure(let error):
                self.error.accept(error)
            }
        }
    }
}
