//
//  AppDetailViewController.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import UIKit

import RxSwift
import RxRelay

class AppDetailViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let viewModel: AppSearchViewModel
    
    let appData: BehaviorRelay<AppData>
    
    let header = AppHeaderView()
    
    let previewScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()
    
    let imageStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        return button
    }()
    
    init(appData: AppData, viewModel: AppSearchViewModel) {
        self.appData = BehaviorRelay(value: appData)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        makeConstraints()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.searchMode.accept(.result)
    }
    
    private func bind() {
        appData.withUnretained(self).subscribe { owner, data in
            let url = URL(string: data.artworkUrl100)
            self.header.thumbnailView.kf.setImage(with: url)
            self.header.nameLabel.text = data.trackName
            self.header.descLabel.text = data.description
            self.header.rateLable.text = "★ " + ( data.averageUserRating?.description ?? "")
            self.makePreviews(urls: data.screenshotUrls ?? [])
        }.disposed(by: disposeBag)
        
        shareButton.rx.tap.withUnretained(self).subscribe { owner, _ in
            owner.shareButtonTapped(
                appName: owner.appData.value.trackName ?? "",
                description: owner.appData.value.description ?? "")
        }.disposed(by: disposeBag)
    }
    
    private func configure() {
        [header, previewScrollView, shareButton].forEach { view.addSubview($0) }
        [imageStack].forEach { previewScrollView.addSubview($0) }
        self.navigationController?.navigationBar.prefersLargeTitles = false
        header.nameLabel.font = .systemFont(ofSize: 24, weight: UIFont.Weight(600))
        header.descLabel.font = .systemFont(ofSize: 16)
        header.rateLable.font = .systemFont(ofSize: 14)
    }
    
    private func makeConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
        
        header.thumbnailView.snp.updateConstraints { make in
            make.width.height.equalTo(80)
        }
        
        header.nameStack.snp.updateConstraints { make in
            make.top.equalTo(header.thumbnailView.snp.top)
        }
        
        previewScrollView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(250)
        }
        
        imageStack.snp.makeConstraints { make in
            make.edges.equalTo(previewScrollView)
            make.height.equalTo(250)
        }
        
        shareButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(previewScrollView.snp.bottom).offset(24)
        }
    }
    
    private func makePreviews(urls: [String]) {
        for item in urls {
            let url = URL(string: item)
            let preview = PreviewImageView(frame: .zero)
            preview.snp.makeConstraints { make in
                make.width.equalTo(120)
            }
            preview.kf.setImage(with: url)
            self.imageStack.addArrangedSubview(preview)
        }
    }
    
    private func shareButtonTapped(appName: String, description: String) {
        let shareText = "\(appName) 다운로드 받으실래요? 앱스토어에서 \(appName)을 검색하세요!"
            let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            
        activityViewController.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .collaborationCopyLink, .collaborationInviteWithLink, .markupAsPDF, .openInIBooks]
            
            // 공유하기 액션 시트 표시
            present(activityViewController, animated: true, completion: nil)
        }
}
