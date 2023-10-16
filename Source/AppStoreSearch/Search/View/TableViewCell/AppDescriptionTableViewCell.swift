//
//  AppDescriptionTableViewCell.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/19.
//

import UIKit

class AppDescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Global Variable
    
    static let reuseIdentifier = "AppDescriptionTableViewCell"
    weak var delegate: AppDetailDelegate?
    
    // 더 보기 버튼 클릭 시 height Constraint 해제 후 TableView Update
    var appDescriptionViewHeightConstraint: NSLayoutConstraint!
    var appDescription: String!
    
    // MARK: - UI Component
    
    private lazy var appDescriptionView: UITextView = {
        let appDescriptionView = UITextView()
        appDescriptionView.isEditable = false
        appDescriptionView.isSelectable = false
        appDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        return appDescriptionView
    }()
    
    private lazy var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.accessibilityIdentifier = "descriptionMoreButton"
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
        self.accessibilityIdentifier = "descriptionCell"
        
        self.selectionStyle = .none
        addContentView()
        setAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        checkDescriptionOverContent()
        setTopLine()
    }
}

// MARK: - Custom function

extension AppDescriptionTableViewCell {
    
    private func addContentView() {
        contentView.addSubview(appDescriptionView)
        appDescriptionView.addSubview(moreButton)
        
        contentView.layer.addSublayer(topLine)
    }
    
    private func setAutolayout() {
        appDescriptionViewHeightConstraint = appDescriptionView.heightAnchor.constraint(equalToConstant: 77.0)
        NSLayoutConstraint.activate([
            appDescriptionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0),
            appDescriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            appDescriptionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0),
            appDescriptionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.0),
            appDescriptionViewHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            moreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.0),
            moreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            moreButton.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    func bindUI(appInfo: AppInfo) {
        appDescription = appInfo.description
        
        moreButton.setTitle("더 보기", for: .normal)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7
        let font = UIFont.systemFont(ofSize: 13.0, weight: .light)
        let text = appInfo.description.replacingOccurrences(of: "\n\n", with: "\n")
        appDescriptionView.attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle:style, .font:font])
    }
    
    @objc func clickMoreButton(_ sender: UIButton) {
        appDescriptionViewHeightConstraint?.isActive = false
        appDescriptionView.text = appDescription
        moreButton.isHidden = true
        
        delegate?.layoutChangeNeeded()
    }
    
    private func checkDescriptionOverContent() {
        if appDescriptionView.contentSize.height > appDescriptionView.bounds.height {
            moreButton.isHidden = false
            setButtonBackground()
        }
        
        appDescriptionView.isScrollEnabled = false
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
