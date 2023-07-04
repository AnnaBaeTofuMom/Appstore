//
//  AppSearchViewModel.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import UIKit

import RxSwift
import RxRelay

enum SearchMode {
    case home
    case typing
    case result
}

class AppSearchViewModel {
    
    let searchMode = BehaviorRelay<SearchMode>(value: .home)
    
    let useCase = SearchAppUseCase()
    
    let disposeBag = DisposeBag()
    
    let recentKeywords = BehaviorRelay<[String]>(value: [])
    
    let simillarKeywords = BehaviorRelay<[String]>(value: [])
    
    let typed = BehaviorRelay<String>(value: "")
    
    let searched = PublishRelay<String>()
    
    let searchAction = PublishRelay<Void>()
    
    let cancelAction = PublishRelay<Void>()
    
    let similarIndexAction = PublishRelay<IndexPath>()
    
    let appDetailIndexAction = PublishRelay<IndexPath>()
    
    let appList = BehaviorRelay<[AppData]>(value: [])
    
    let pushToDetail = PublishRelay<AppData>()
    
    init() {
        let keywords = UserDefaults.standard.array(forKey: UserDefaultKey.recent.rawValue) as? [String]
        recentKeywords.accept(keywords ?? [])
        bind()
    }
    
    private func bind() {
        let key = UserDefaultKey.recent.rawValue
        
        UserDefaults.standard.rx.observe([String].self, key)
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.recentKeywords.accept(value ?? [])
            })
            .disposed(by: disposeBag)

        // 유저디폴트에 저장하는 스트림
        searched.subscribe { text in
            guard !text.isEmpty else { return }
            var keywords = UserDefaults.standard.array(forKey: key) as? [String] ?? []
            if !keywords.contains(text) {
                keywords.insert(text, at: 0)
                keywords = Array(keywords.prefix(5))
            }
            UserDefaults.standard.set(keywords, forKey: key)
        }.disposed(by: disposeBag)
        
        // 검색 실행하는 스트림
        self.searchAction.withUnretained(self).subscribe { owner, _ in
            let keyword = owner.typed.value
            owner.useCase.requestSearch(keyword: keyword)
            owner.searched.accept(keyword)
            owner.searchMode.accept(.result)
        }.disposed(by: disposeBag)
        
        // 검색결과 받아오는 스트림
        self.useCase.searchResult.bind(to: self.appList).disposed(by: disposeBag)
        
        similarIndexAction.withUnretained(self).subscribe { owner, indexPath in
            let selectedText = owner.recentKeywords.value[indexPath.row]
            owner.typed.accept(selectedText)
        }.disposed(by: disposeBag)
        
        self.cancelAction.withUnretained(self).subscribe { owner, _ in
            owner.appList.accept([])
            owner.simillarKeywords.accept([])
            owner.searchMode.accept(.home)
        }.disposed(by: disposeBag)
        
        typed.withUnretained(self).subscribe { owner, text in
            let similar = owner.recentKeywords.value.filter { recent in recent.contains(text)
            }
            owner.simillarKeywords.accept(similar)
        }.disposed(by: disposeBag)
        
        appDetailIndexAction.withUnretained(self).subscribe { owner, indexPath in
            let item = owner.appList.value[indexPath.item]
            owner.pushToDetail.accept(item)
        }.disposed(by: disposeBag)
    }
}
