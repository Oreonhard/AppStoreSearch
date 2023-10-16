//
//  AppFullPreviewVC.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/19.
//

import UIKit

class AppFullPreviewVC: UIViewController {
    
    // MARK: - Global Variable
    
    var previewImages: [String]!
    var seletedIndex: Int = 0
    
    // MARK: - UI Component
    
    lazy var previews: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let appPreviews = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 10.0
        flowlayout.sectionInset = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowlayout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.8)
        
        appPreviews.accessibilityIdentifier = "appFullPreview"
        appPreviews.showsHorizontalScrollIndicator = false
        // 스크롤 시 빠르게 감속 되도록 설정
        appPreviews.decelerationRate = .fast
        appPreviews.delegate = self
        appPreviews.dataSource = self
        appPreviews.register(AppPreviewCollectionViewCell.self, forCellWithReuseIdentifier: AppPreviewCollectionViewCell.reuseIdentifier)
        appPreviews.translatesAutoresizingMaskIntoConstraints = false
        
        return appPreviews
    }()
    
    lazy var completeButton: UIButton = {
        let completeButton = UIButton()
        completeButton.accessibilityIdentifier = "appFullPreviewCloseButton"
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.systemBlue, for: .normal)
        completeButton.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .semibold)
        completeButton.addTarget(self, action: #selector(clickedComplete), for: .touchUpInside)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        return completeButton
    }()
    
    @objc func clickedComplete(_ sender:UIButton) {
        self.dismiss(animated: true)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(completeButton)
        self.view.addSubview(previews)
        
        setAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let layout = previews.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let offset = CGPoint(x: CGFloat(seletedIndex) * cellWidthIncludingSpacing - previews.contentInset.left, y: previews.contentInset.top)
        previews.setContentOffset(offset, animated: false)
    }
}

// MARK: - UICollectionViewDelegate

extension AppFullPreviewVC: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = previews.collectionViewLayout as! UICollectionViewFlowLayout
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
    
}

// MARK: - UICollectionViewDataSource

extension AppFullPreviewVC: UICollectionViewDataSource {
    
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

// MARK: - Custon Function

extension AppFullPreviewVC {
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            completeButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -5.0),
            completeButton.heightAnchor.constraint(equalToConstant: 50.0),
            completeButton.widthAnchor.constraint(equalToConstant: 50.0)
        ])
        
        NSLayoutConstraint.activate([
            previews.topAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 5.0),
            previews.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            previews.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            previews.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
}
