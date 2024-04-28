//
//  ChartViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/27.
//

import UIKit

class ChartViewController: UIViewController {
    
    private let chartContainerView = UIView()
    private let chartTitleLabel = UILabel()
    private let chartCenterLabel = UILabel()
    private let chartCountLabel = UILabel()

    // 每個度數對應的弧度
    private let aDegree: CGFloat = .pi / 180
    // 圓弧的線寬、半徑、起始角度、圓心
    private let lineWidth: CGFloat = 36
    private let radius: CGFloat = 120
    private var startDegree: Double = 270
    private var center = CGPoint()

    // 要顯示的百分比
    private var percentages = [Double]()
    // 百分比顏色
    private var colors: [UIColor] = [.primary, .lightBlue, .lightPink, .lightYellow]
    
    var datas: [LocationTypeCellModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 計算圓心
        center = CGPoint(x: lineWidth + radius, y: lineWidth + radius)
        configureUI()
    }
    
    func setupWith(datas: [LocationTypeCellModel]) {
        self.datas = datas
        var numbers = [Double]()
        for data in datas {
            numbers.append(Double(data.count))
        }
        percentages = calculatePercentages(numbers)
    }
    
    private func calculatePercentages(_ numbers: [Double]) -> [Double] {
        // 第一個元素是總篇數
        let total = numbers[0]
        // 將每個元素除以總篇數得到比例
        let percentages = numbers[1...].map { $0 / total }
        return percentages
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureChartContainerView()
        configureChartLabel()
        configureDonutChart()
    }
    
    private func configureNavigationBar() {
        // 設置標題文本的字體和重量
        let titleFont = UIFont.systemFont(ofSize: 17, weight: .regular) // 設置標題字體大小和粗細
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.primary
        ]
        // 配置導航欄的標準外觀
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = titleTextAttributes
        navBarAppearance.backgroundColor = .systemBackground
        navBarAppearance.shadowColor = .clear
        // 設置導航欄的標準外觀和滾動到邊緣時的外觀
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationItem.title = "統計圖表"
    }
    
    private func configureChartContainerView() {
        view.addSubview(chartContainerView)
        chartContainerView.snp.makeConstraints { make in
            make.size.equalTo((radius + lineWidth) * 2)
            make.center.equalToSuperview()
        }
    }
    
    private func configureChartLabel() {
        view.addSubview(chartTitleLabel)
        chartTitleLabel.text = "我去過的地方"
        chartTitleLabel.textColor = .primary
        chartTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        chartTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(chartContainerView.snp.top).offset(-32)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(chartCountLabel)
        chartCountLabel.text = "\(datas[0].count)"
        chartCountLabel.textColor = .primary
        chartCountLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        chartCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
        }
        
        view.addSubview(chartCenterLabel)
        chartCenterLabel.text = "總篇數"
        chartCenterLabel.textColor = .primary
        chartCenterLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        chartCenterLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(12)
        }
    }
    
    private func configureDonutChart() {
        for (index, percentage) in percentages.enumerated() {
            
            // 設置圓弧大小
            let endDegree = startDegree + 360 * percentage
            let percentagePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
            let percentageLayer = CAShapeLayer()
            percentageLayer.path = percentagePath.cgPath
            percentageLayer.strokeColor  = colors[index].cgColor
            percentageLayer.lineWidth = lineWidth
            percentageLayer.fillColor = UIColor.clear.cgColor
            chartContainerView.layer.addSublayer(percentageLayer)
            
            // 設置動畫
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.3 // 動畫持續時間（以秒為單位）
            percentageLayer.add(animation, forKey: "strokeEndAnimation")
            
            // 設置種類圖示
            guard let emoji = datas?[index + 1].type?.emoji else { return }
            let typeButton = createtypeButton(percentage: percentage, startDegree: startDegree, title: "\(emoji)")
            chartContainerView.addSubview(typeButton)
            
            // 將下一個的起點設為上一個的終點
            startDegree = endDegree
        }
    }
    
    private func createtypeButton(percentage: Double, startDegree: Double, title: String) -> UIButton {
        
        // 計算圖示中心點
        let textCenterDegree = startDegree + 360 * percentage / 2
        let distanceFromCenter: CGFloat = 20 // 從圓弧中心往外移動的距離
        let textCenterPoint = CGPoint(x: center.x + CGFloat((radius + distanceFromCenter) * cos(aDegree * textCenterDegree)),
                                      y: center.y + CGFloat((radius + distanceFromCenter) * sin(aDegree * textCenterDegree)))
        
        // 設置圖示
        let typeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        typeButton.center = textCenterPoint
        typeButton.backgroundColor = .systemBackground
        typeButton.layer.shadowColor = UIColor.systemGray4.cgColor
        typeButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        typeButton.layer.shadowOpacity = 0.5
        typeButton.layer.shadowRadius = 4
        typeButton.layer.cornerRadius = 20
        typeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        typeButton.titleLabel?.textAlignment = .center
        typeButton.setTitle("\(title)", for: .normal)
        
        return typeButton
    }
    
}
