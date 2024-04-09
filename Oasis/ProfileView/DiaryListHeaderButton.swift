//
//  DiaryListHeaderButton.swift
//  Oasis
//
//  Created by joanna on 2024/4/9.
//

import UIKit

class DiaryListHeaderButton: UIButton {
    
    let buttonLabel = UILabel()
    
    var status: DiaryListHeaderButtonStatus = .unselected {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
        buttonLabel.textAlignment = .center
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI() {
        buttonLabel.textColor = status.color
    }

}

enum DiaryListHeaderButtonStatus {
    case selected
    case unselected
    
    var color: UIColor {
        switch self {
        case .unselected:
            return .systemGray4
        case .selected:
            return .primary
        }
    }
}
