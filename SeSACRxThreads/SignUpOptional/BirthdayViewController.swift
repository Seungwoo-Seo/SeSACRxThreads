//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")

    let disposeBag = DisposeBag()
    let viewModel = BirthdayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

        bind()
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }

    func bind() {
        // MARK: - Input
        birthDayPicker.rx.date
            .subscribe(with: self) {
                $0.viewModel.birthday.onNext($1)
            }
            .disposed(by: disposeBag)

        // MARK: - Output
        viewModel.birthday
            .map {
                let calendar = Calendar.current
                let component = calendar.dateComponents([.year], from: $0)
                return component.year! <= 2006
            }
            .bind(with: self) { $0.nextButton.isEnabled = $1 }
            .disposed(by: disposeBag)

        viewModel.year
            .map { "\($0)년" }
            .bind(with: self) {
                $0.yearLabel.text = $1
            }
            .disposed(by: disposeBag)

        viewModel.month
            .map { "\($0)월" }
            .bind(with: self) {
                $0.monthLabel.text = $1
            }
            .disposed(by: disposeBag)

        viewModel.day
            .map { "\($0)일" }
            .bind(with: self) {
                $0.dayLabel.text = $1
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
