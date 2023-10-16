//
//  RecentSearchTableViewCell.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/16.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
    
    // MARK: - Global Variable
    
    static let reuseIdentifier = "RecentTableViewCell"
    
    // MARK: - UI Component
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var topLine: CALayer = {
        let topLine = CALayer()
        topLine.frame = CGRectMake(15.0, 1.0, self.frame.width - 30.0, 0.5)
        topLine.backgroundColor = CGColor(red: 239.0/255.0, green: 239.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        
        return topLine
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
        
        setTopLine()
    }
    
}

// MARK: - Custon Function

extension RecentTableViewCell {
    
    func bindUI(_ text: String) {
        label.text = text
        setTopLine()
    }
    
    private func addContentView() {
        contentView.addSubview(label)
        contentView.layer.addSublayer(topLine)
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.0),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setTopLine() {
        topLine.frame = CGRectMake(15.0, 1.0, self.frame.width - 30.0, 1.0)
    }
    
}
