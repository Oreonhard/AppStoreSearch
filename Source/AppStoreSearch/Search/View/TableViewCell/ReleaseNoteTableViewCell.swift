//
//  ReleaseNoteTableViewCell.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/20.
//

import UIKit

class ReleaseNoteTableViewCell: UITableViewCell {
    
    // MARK: - Global Variable
    
    static let reuseIdentifier = "ReleaseNoteTableViewCell"
    weak var delegate: AppDetailDelegate?
    
    /// 더 보기 버튼 클릭 시 height Constraint 해제 후 TableView Update
    var releaseNoteHeightConstraint: NSLayoutConstraint!
    var releaseNote: String!
    
    // MARK: - UI Component
    
    private lazy var newReleaseLabel: UILabel = {
        let newReleaseLabel = UILabel()
        newReleaseLabel.font = .systemFont(ofSize: 20.0, weight: .bold)
        newReleaseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return newReleaseLabel
    }()
    
    private lazy var versionHistoryButton: UIButton = {
        let versionHistoryButton = UIButton()
        versionHistoryButton.setTitleColor(.systemBlue, for: .normal)
        versionHistoryButton.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .light)
        versionHistoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        return versionHistoryButton
    }()
    
    private lazy var versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.textColor = .systemGray
        versionLabel.font = .systemFont(ofSize: 12.0, weight: .light)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return versionLabel
    }()
    
    private lazy var periodLabel: UILabel = {
        let periodLabel = UILabel()
        periodLabel.textColor = .systemGray
        periodLabel.font = .systemFont(ofSize: 12.0, weight: .light)
        periodLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return periodLabel
    }()
    
    private lazy var releaseNoteView: UITextView = {
        let releaseNoteView = UITextView()
        releaseNoteView.isEditable = false
        releaseNoteView.isSelectable = false
        releaseNoteView.translatesAutoresizingMaskIntoConstraints = false
        
        return releaseNoteView
    }()
    
    private lazy var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.accessibilityIdentifier = "releaseNoteMoreButton"
        moreButton.isHidden = true
        moreButton.contentHorizontalAlignment = .right
        moreButton.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .light)
        moreButton.setTitleColor(.systemBlue, for: .normal)
        moreButton.addTarget(self, action: #selector(clickMoreButton), for: .touchUpInside)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        return moreButton
    }()
    
    private lazy var topLine: CALayer = {
        let topLine = CALayer()
        topLine.frame = CGRectMake(15.0, 1.0, self.frame.width - 30.0, 0.5)
        topLine.backgroundColor = UIColor.separator.cgColor
        
        return topLine
    }()
    
    // MARK: - Override function
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessibilityIdentifier = "releaseNoteCell"
        
        self.selectionStyle = .none
        addContentView()
        setAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        checkReleaseNoteOverContent()
        setTopLine()
    }
}

// MARK: - Custom function

extension ReleaseNoteTableViewCell {
    
    private func addContentView() {
        contentView.addSubview(newReleaseLabel)
        contentView.addSubview(versionHistoryButton)
        contentView.addSubview(versionLabel)
        contentView.addSubview(periodLabel)
        contentView.addSubview(releaseNoteView)
        releaseNoteView.addSubview(moreButton)
        
        contentView.layer.addSublayer(topLine)
    }
    
    private func setAutolayout() {
        NSLayoutConstraint.activate([
            newReleaseLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0),
            newReleaseLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0)
        ])
        
        NSLayoutConstraint.activate([
            versionHistoryButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0),
            versionHistoryButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.0)
        ])
        
        NSLayoutConstraint.activate([
            versionLabel.topAnchor.constraint(equalTo: newReleaseLabel.bottomAnchor, constant: 5.0),
            versionLabel.leftAnchor.constraint(equalTo: newReleaseLabel.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            periodLabel.topAnchor.constraint(equalTo: versionHistoryButton.bottomAnchor),
            periodLabel.rightAnchor.constraint(equalTo: versionHistoryButton.rightAnchor)
        ])
        
        releaseNoteHeightConstraint = releaseNoteView.heightAnchor.constraint(equalToConstant: 77.0)
        NSLayoutConstraint.activate([
            releaseNoteView.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 15.0),
            releaseNoteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            releaseNoteView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0),
            releaseNoteView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.0),
            releaseNoteHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            moreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.0),
            moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            moreButton.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    func bindUI(appInfo: AppInfo) {
        releaseNote = appInfo.releaseNotes!
        
        newReleaseLabel.text = "새로운 기능"
        versionHistoryButton.setTitle("버전 기록", for: .normal)
        versionLabel.text = "버전 " + appInfo.version
        moreButton.setTitle("더 보기", for: .normal)
        periodLabel.text = getTimeAgoAtNow(date: appInfo.currentReleaseDate!)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7
        let font = UIFont.systemFont(ofSize: 13.0, weight: .light)
        let text = appInfo.releaseNotes!.replacingOccurrences(of: "\n\n", with: "\n")
        releaseNoteView.attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle:style, .font:font])
    }
    
    @objc func clickMoreButton(_ sender: UIButton) {
        releaseNoteHeightConstraint?.isActive = false
        releaseNoteView.text = releaseNote
        moreButton.isHidden = true
        
        delegate?.layoutChangeNeeded()
    }
    
    private func checkReleaseNoteOverContent() {
        if releaseNoteView.contentSize.height > releaseNoteView.bounds.height {
            moreButton.isHidden = false
            setButtonBackground()
        }
        
        releaseNoteView.isScrollEnabled = false
    }
    
    private func setButtonBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = moreButton.bounds
        gradient.colors = [CGColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5), CGColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.0, 0.2]
        
        moreButton.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setTopLine() {
        topLine.frame = CGRectMake(15.0, 1.0, self.frame.width - 30.0, 1.0)
    }
}
