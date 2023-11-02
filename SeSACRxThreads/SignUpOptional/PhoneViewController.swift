//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit

import RxCocoa
import RxSwift
import SnapKit

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")

    let disposeBag = DisposeBag()

    let viewModel = PhoneViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

        bind()
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    func bind() {
        // MARK: - Input
        phoneTextField.rx.text
            .orEmpty
            .skip(1)
            .map { $0.formated(by: "###-####-####") }           // -----> 여기랑 사실 vm으로 가야지
            .subscribe(with: self) { $0.viewModel.phone.onNext($1) }
            .disposed(by: disposeBag)

        // MARK: - Output
        viewModel.phone                         // -> 위치에 따라 인풋이 바뀌네
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)

        viewModel.phone
            .map { $0.count > 10 }                              // -----> 여기랑 사실 vm으로 가야지
            .bind(with: self) { owner, value in
                let color = value ? UIColor.blue : UIColor.red
                owner.nextButton.isEnabled = value
                owner.nextButton.backgroundColor = color
                owner.phoneTextField.tintColor = color
                owner.phoneTextField.layer.borderColor = color.cgColor
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
