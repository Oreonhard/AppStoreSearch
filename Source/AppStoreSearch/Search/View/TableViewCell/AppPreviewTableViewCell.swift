//
//  AppPreviewTableViewCell.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/19.
//

import UIKit

class AppPreviewTableViewCell: UITableViewCell {
    
    // MARK: - Global Variable
    
    static let reuseIdentifier = "AppPreviewTableViewCell"
    weak var delegate: AppDetailDelegate?
    
    var previewImages: [String] = []
    
    // MARK: - UI Component
    
    private lazy var appPreviews: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 10.0
        flowlayout.itemSize = CGSize(width: 210.0, height: 420.0)
        flowlayout.sectionInset = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        
        let appPreviews = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        appPreviews.accessibilityIdentifier = "appPreviews"
        appPreviews.showsHorizontalScrollIndicator = false
        // 스크롤 시 빠르게 감속 되도록 설정
        appPreviews.decelerationRate = .fast
        appPreviews.delegate = self
        appPreviews.dataSource = self
        appPreviews.register(AppPreviewCollectionViewCell.self, forCellWithReuseIdentifier: AppPreviewCollectionViewCell.reuseIdentifier)
        appPreviews.translatesAutoresizingMaskIntoConstraints = false
        
        return appPreviews
    }()
    
    // MARK: - Override Function
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        addContentView()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UICollectionViewDataSource

extension AppPreviewTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previewImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppPreviewCollectionViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? AppPreviewCollectionViewCell {
            cell.imageURL = previewImages[indexPath.row]
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension AppPreviewTableViewCell: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = appPreviews.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // targetContentOffset을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        var index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        // 스크롤 방향 체크
        if velocity.x > 0 {
            index = ceil(index)
        } else if velocity.x < 0 {
            index = floor(index)
        } else {
            index = round(index)
        }
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: index * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedPreviewImage(index: indexPath.row, previewImages: previewImages)
    }
    
}

// MARK: - Custom Function

extension AppPreviewTableViewCell {
    
    private func addContentView() {
        contentView.addSubview(appPreviews)
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            appPreviews.topAnchor.constraint(equalTo: contentView.topAnchor),
            appPreviews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0),
            appPreviews.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            appPreviews.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            appPreviews.heightAnchor.constraint(equalToConstant: 440.0)
        ])
    }
    
    func bindUI(appInfo: AppInfo) {
        previewImages = appInfo.previewImages
    }
    
}
