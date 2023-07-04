//
//  ViewController.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

class SearchResultViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel: AppSearchViewModel
    
    let appCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 330)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    init(viewModel: AppSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorColor = .clear
        tableview.backgroundColor = .white
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput()
        bindOutput()

        configure()
        configureTableView()
        makeConstraints()
    }
    
    private func bindInput() {
        self.tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                let text = owner.viewModel.simillarKeywords.value[indexPath.row]
                owner.viewModel.typed.accept(text)
                owner.viewModel.searchAction.accept(())
                owner.viewModel.searchMode.accept(.result)
        }.disposed(by: disposeBag)
        
        self.appCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                owner.viewModel.appDetailIndexAction.accept(indexPath)
                owner.viewModel.searchMode.accept(.result)
            }.disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.searchMode.withUnretained(self).subscribe { owner, mode in
            switch mode {
            case .home:
                owner.tableView.isHidden = false
                owner.appCollectionView.isHidden = true
            case .typing:
                owner.tableView.isHidden = false
                owner.appCollectionView.isHidden = true
            case .result:
                owner.tableView.isHidden = true
                owner.appCollectionView.isHidden = false
            }
        }.disposed(by: disposeBag)
        
        viewModel.simillarKeywords
            .bind(to: tableView.rx.items(cellIdentifier: "simillar", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element
            }
            .disposed(by: disposeBag)
        
        viewModel.appList
            .bind(to: appCollectionView.rx.items(cellIdentifier: "list", cellType: AppCollectionViewCell.self)) { (row, item, cell) in
                // 각 셀에 대한 구성 설정
                print("cell \(Thread.isMainThread)")
                cell.header.nameLabel.text = item.trackName
                cell.header.descLabel.text = item.description
                cell.header.rateLable.text = "★ " + ( item.averageUserRating?.description ?? "")
                let url = URL(string: item.artworkUrl100)!
                cell.header.thumbnailView.kf.setImage(with: url)
                cell.makePreviews(urls: item.screenshotUrls ?? [])
            }
            .disposed(by: disposeBag)
        
        viewModel.appList.withUnretained(self).subscribe { owner, _ in
            owner.viewModel.searchMode.accept(.result)
        }.disposed(by: disposeBag)
    }

    private func configure() {
        view.backgroundColor = .white
        [tableView, appCollectionView].forEach { view.addSubview($0) }
        appCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simillar")
        appCollectionView.register(AppCollectionViewCell.self, forCellWithReuseIdentifier:  "list")
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        appCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 200)
    }
}
