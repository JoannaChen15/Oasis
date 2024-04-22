//
//  NewDiaryViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit
import SnapKit
import CoreData

class NewDiaryViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let stackView = UIStackView()

    private let typeButton = SelectionButton()
    private let locationButton = SelectionButton()
    private let dateButton = SelectionButton()
    private let photoLabel = UILabel()
    private let photoButton = UIButton()
    private let contentLabel = UILabel()
    private let contentView = UIView()
    private let contentTextView = UITextView()

    private let constant: CGFloat = 24
    private let buttonHeight: CGFloat = 56
    private var isFirstPresent = true
    
    var selectedType: LocationType?
    var selectedLocation: String?
    var selectedDate: Date?
    var selectedPhoto: UIImage?
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // 添加點擊手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        // 訂閱鍵盤彈出和隱藏的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstPresent {
            isFirstPresent = false
            addDashedBorder()
        }
    }

    @objc func hideKeyboard() {
        view.endEditing(true) // 收起所有正在編輯的元素的鍵盤
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // 獲取鍵盤的高度
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        // 設置 scrollView 的內容偏移量，使文本字段在鍵盤上方可見
        scrollView.contentInset.bottom = keyboardSize.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // 隱藏鍵盤時重置 scrollView 的內容偏移量
        scrollView.contentInset = .zero
    }

    @objc func doneAction() {

        guard let selectedType,
              let selectedLocation else { return }
        self.createDiary(locationName: selectedLocation, locationType: selectedType.rawValue, date: selectedDate ?? Date(), photo: selectedPhoto?.pngData(), content: contentTextView.text ?? "")
        dismiss(animated: true)
    }
    // Core Data
    
    func createDiary(locationName: String, locationType: String, date: Date, photo: Data?, content: String) {
        let newDiary = Diary(context: context)
        newDiary.locationName = locationName
        newDiary.locationType = locationType
        newDiary.date = date
        newDiary.photo = photo
        newDiary.content = content
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    func updateDiary(diary: Diary, newLocationName: String, newLocationType: String, newDate: Date, newPhoto: Data?, newContent: String) {
        diary.locationName = newLocationName
        diary.locationType = newLocationType
        diary.date = newDate
        diary.photo = newPhoto
        diary.content = newContent
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    @objc func cancelAction() {
        guard selectedType == nil, selectedLocation == nil, selectedDate == nil, selectedPhoto == nil, contentTextView.text == "" else {
            let controller = UIAlertController(title: "放棄編輯內容", message: "確定要放棄編輯並離開？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            controller.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "離開", style: .destructive) { _ in
                self.dismiss(animated: true)
            }
            controller.addAction(confirmAction)
            present(controller, animated: true)
            return
        }
        self.dismiss(animated: true)
    }
    
    @objc func chooseLocationType() {
        let controller = ChooseLocationTypeController()
        controller.buttonHandler = handleChooseLocationType
        present(controller, animated: true)
    }
    
    @objc func chooseLocation() {
        let controller = ChooseLocationController()
        //未選擇地點類型時
        guard let selectedType else {
            let controller = UIAlertController(title: "請先選擇地點類型 😉", message: "", preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "好", style: .default) { _ in
                //跳轉至選擇地點類型頁面
                let controller = ChooseLocationTypeController()
                controller.buttonHandler = self.handleChooseLocationType
                self.present(controller, animated: true)
            }
            controller.addAction(continueAction)
            present(controller, animated: true)
            return
        }
        //已選擇地點類型
        controller.selectedLocationType = selectedType
        controller.didSelectCellHandler = handleChooseLocation
        present(controller, animated: true)
    }
    
    @objc func chooseTime() {
        let controller = ChooseDateController()
        if let sheetPresentationController = controller.sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
        controller.buttonHandler = handleChooseDate
        if let selectedDate = selectedDate {
            // 設置選擇的日期
            controller.datePicker.setDate(selectedDate, animated: true)
        }
        present(controller, animated: true)
    }
    
    @objc func choosePhoto() {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true)
    }
    
    // 選擇地點類型時呼叫的函式
    func handleChooseLocationType(index: Int, type: String) {
        typeButton.detailLabel.text = type
        selectedType = LocationType.allCases[index]
        // reset地點
        locationButton.detailLabel.text = "選擇"
        selectedLocation = nil
    }
    
    // 選擇地點時呼叫的函式
    func handleChooseLocation(locationName: String) {
        locationButton.detailLabel.text = "\(selectedType!.emoji) \(locationName)"
        selectedLocation = locationName
    }
    
    // 選擇日期時呼叫的函式
    func handleChooseDate(selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let dateString = dateFormatter.string(from: selectedDate)
        dateButton.detailLabel.text = dateString
        self.selectedDate = selectedDate
    }

    deinit {
        // Unsubscribe from keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
}

private extension NewDiaryViewController {
    func configureUI() {
        view.backgroundColor = .systemGray6
        configureNavigation()
        configScrollView()
        configContainerView()
        configStackView()

        stackView.addArrangedSubview(typeButton)
        configTypeButton()

        stackView.addArrangedSubview(locationButton)
        configLocationButton()

        stackView.addArrangedSubview(dateButton)
        configDateButton()

        stackView.addArrangedSubview(photoLabel)
        configPhotoLabel()

        stackView.addArrangedSubview(photoButton)
        configPhotoButton()

        stackView.addArrangedSubview(contentLabel)
        configContentLabel()

        stackView.addArrangedSubview(contentView)
        configContentView()
    }
    
    func configureNavigation() {
        // 設置標題文本的字體和重量
        let titleFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.primary
        ]
        // 配置導航欄的標準外觀
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = titleTextAttributes
        navBarAppearance.backgroundColor = .systemBackground

        // 設置導航欄的標準外觀和滾動到邊緣時的外觀
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.title = "新增日記"
        // 添加按鈕
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneButton
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func configScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.backgroundColor = .systemGray6
        scrollView.alwaysBounceVertical = true
    }

    func configContainerView() {
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }
    }
    
    func configStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = constant
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(24)
            $0.bottom.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(constant)
        }
    }
    
    func configTypeButton() {
        typeButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview()
        }
        typeButton.mainLabel.text = "類型"
        typeButton.detailLabel.text = "選擇"
        typeButton.addTarget(self, action: #selector(chooseLocationType), for: .touchUpInside)
    }

    func configLocationButton() {
        locationButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview()
        }
        locationButton.mainLabel.text = "地點"
        locationButton.detailLabel.text = "選擇"
        locationButton.addTarget(self, action: #selector(chooseLocation), for: .touchUpInside)
    }

    func configDateButton() {
        dateButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview()
        }
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let dateString = dateFormatter.string(from: today)
        dateButton.detailLabel.text = dateString
        dateButton.mainLabel.text = "日期"
        dateButton.addTarget(self, action: #selector(chooseTime), for: .touchUpInside)
    }

    func configPhotoLabel() {
        photoLabel.text = "選擇照片"
        photoLabel.textColor = .primary
        photoLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        photoLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
    }

    func configPhotoButton() {
        photoButton.snp.makeConstraints { make in
            make.size.equalTo(100)
        }
        photoButton.backgroundColor = .systemBackground
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "photo", withConfiguration: configuration)
        photoButton.setImage(image, for: .normal)
        photoButton.tintColor = .systemGray2
        photoButton.layer.cornerRadius = 8
        photoButton.clipsToBounds = true
        photoButton.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
    }

    func configContentLabel() {
        contentLabel.text = "日記內容"
        contentLabel.textColor = .primary
        contentLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        contentLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
    }

    func configContentView() {
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalToSuperview()
        }
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8

        contentView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        contentTextView.font = UIFont.systemFont(ofSize: 17)
        contentTextView.textColor = .primary
    }
}

extension NewDiaryViewController {
    func addDashedBorder() {
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = UIColor.systemGray.cgColor
        dashedBorder.lineDashPattern = [8, 2] // 設置虛線的間隔
        dashedBorder.frame = photoButton.bounds
        dashedBorder.fillColor = nil
        dashedBorder.path = UIBezierPath(roundedRect: photoButton.bounds, cornerRadius: 8).cgPath
        photoButton.layer.addSublayer(dashedBorder)
    }
}

extension NewDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickImage = info[.originalImage] as? UIImage
        photoButton.setImage(pickImage, for: .normal)
        photoButton.imageView?.contentMode = .scaleAspectFill
        selectedPhoto = pickImage
        dismiss(animated: true)
    }
}
