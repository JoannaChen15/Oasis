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

    func showMessage() {
        // 將視圖添加到窗口上
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                // 計算初始和最終 frame
                let toastWidth: CGFloat = window.bounds.width - 64 // 寬度減去兩側的邊距
                let initialFrame = CGRect(x: window.bounds.midX - toastWidth/2,
                                          y: window.bounds.maxY, // 初始位置在屏幕底部
                                          width: toastWidth,
                                          height: 50)
                
                let finalFrame = CGRect(x: window.bounds.midX - toastWidth/2,
                                        y: window.bounds.maxY - 140, // 目標位置往上偏移 140 點
                                        width: toastWidth,
                                        height: 50)
                
                // 將視圖添加到窗口上，並設置初始位置
                frame = initialFrame
                window.addSubview(self)
                window.bringSubviewToFront(self)
                
                // 設置顯示動畫
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                    self.frame = finalFrame
                }) { _ in
                    // 延遲一段時間後再執行隱藏動畫
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                            self.frame = initialFrame
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
