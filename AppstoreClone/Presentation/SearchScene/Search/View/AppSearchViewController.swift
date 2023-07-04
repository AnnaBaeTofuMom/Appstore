//
//  AppSearchViewController.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class AppSearchViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let headerView = RecentSearchHeaderView()
    
    let viewModel = AppSearchViewModel()
    
    let tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorColor = .clear
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    private func configure() {
        view.backgroundColor = .white
        [headerView,tableView].forEach { view.addSubview($0) }
        
        configureSearchBar()
        configureNavigationBar()
        configureTableView()
        makeConstraints()
        
        bindInput()
        bindOutput()
    }
    
    private func bindInput() {
        self.navigationItem.searchController?
            .searchBar
            .rx.text
            .orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.viewModel.typed.accept(text)
                owner.viewModel.searchMode.accept(.typing)
            })
            .disposed(by: disposeBag)
        
        self.navigationItem.searchController?
            .searchBar
            .rx.searchButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.viewModel.searchMode.accept(.result)
                owner.viewModel.searchAction.accept(())
            })
            .disposed(by: disposeBag)
        
        self.navigationItem.searchController?
            .searchBar
            .rx.cancelButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.viewModel.searchMode.accept(.home)
                owner.viewModel.cancelAction.accept(())
            })
            .disposed(by: disposeBag)

        self.tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                owner.viewModel.similarIndexAction.accept(indexPath)
                let text = owner.viewModel.recentKeywords.value[indexPath.row]
                owner.navigationItem.searchController?.searchBar.text = text
                owner.navigationItem.searchController?.searchBar.becomeFirstResponder()
                owner.viewModel.searchMode.accept(.typing)
        }.disposed(by: disposeBag)
        
    }
    
    private func bindOutput() {
        viewModel.recentKeywords
            .bind(to: tableView.rx.items(cellIdentifier: "recent", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element
                cell.selectionStyle = .none
                cell.textLabel?.textColor = .systemBlue
            }
            .disposed(by: disposeBag)
        
        viewModel.searched.subscribe { text in
            self.navigationItem.searchController?.searchBar.searchTextField.text = text
        }.disposed(by: disposeBag)
        
        viewModel.pushToDetail.withUnretained(self).subscribe { owner, data in
            let vc = AppDetailViewController(appData: data, viewModel: owner.viewModel)
            owner.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "recent")
    }
    
    private func configureSearchBar() {
        let searchResultvc = SearchResultViewController(viewModel: self.viewModel)
        self.navigationItem.searchController = UISearchController(searchResultsController: searchResultvc)
        
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "검색"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    private func makeConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
   
}


