//
//  ToastView.swift
//  Oasis
//
//  Created by joanna on 2024/4/26.
//

import UIKit
import SnapKit

class ToastView: UIView {
    
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        layer.cornerRadius = 10
        backgroundColor = .primary
        
        addSubview(label)
        label.textColor = .white
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }

    func showMessage(_ message: String) {
        label.text = message

        // 將視圖添加到窗口上
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                // 設定視圖大小
                frame = CGRect(x: 0, y: 0, width: window.bounds.width - 64, height: 50)
                // 計算初始和最終位置
                let initialPoint = CGPoint(x: window.bounds.midX, y: window.bounds.maxY)
                let finalPoint = CGPoint(x: window.bounds.midX, y: window.bounds.maxY - 120)
                // 設定初始位置
                center = initialPoint
                // 將視圖添加到窗口上
                window.addSubview(self)
                window.bringSubviewToFront(self)
                
                // 設置顯示動畫
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.center = finalPoint
                }) { _ in
                    // 延遲一段時間後再執行隱藏動畫
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                            self.center = initialPoint
                        }) { _ in
                            // 隱藏後移除視圖
                            self.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
    
}
