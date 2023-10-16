//
//  RecentSearchTableViewCell.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/16.
//

import UIKit

class AutoKeywordTableViewCell: UITableViewCell {
    
    // MARK: - Global Variable
    
    static let reuseIdentifier = "AutoKeywordTableViewCell"
    
    // MARK: - UI Component
    
    lazy var searchIcon: UIImageView = {
        let searchIcon = UIImageView(frame: .init(x: 0.0, y: 0.0, width: 0.0, height: contentView.frame.height))
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = .lightGray
        searchIcon.translatesAutoresizingMaskIntoConstraints = false

        return searchIcon
    }()
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .init(x: 0.0, y: 0.0, width: 0.0, height: contentView.frame.height))
        label.textColor = .black
        label.font = .systemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bottomLine: CALayer = {
        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.separator.cgColor
        
        return bottomLine
    }()
    
    // MARK: - Override Function
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setBottomLine()
    }
}

// MARK: - Custon Function

extension AutoKeywordTableViewCell {
    
    func bindUI(_ text: String) {
        label.text = text
        setBottomLine()
    }
    
    private func addContentView() {
        contentView.addSubview(searchIcon)
        contentView.addSubview(label)
        contentView.layer.addSublayer(bottomLine)
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            searchIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0),
            searchIcon.widthAnchor.constraint(equalToConstant: 15.0),
            searchIcon.heightAnchor.constraint(equalTo: searchIcon.widthAnchor),
            searchIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: searchIcon.rightAnchor, constant: 10.0),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.0),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setBottomLine() {
        bottomLine.frame = CGRectMake(15.0, self.frame.height - 1.0, self.frame.width - 15.0, 1.0)
    }
    
}
