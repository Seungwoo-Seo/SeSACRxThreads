//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()

    let disposeBag = DisposeBag()

    let viewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)

        bind()
    }
    
    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }

    func bind() {
        // MARK: - Input
        emailTextField.rx.text.orEmpty
            .bind(with: self) { // -> subscribe나 bind말고 좀 더 적절한게 있을꺼 같은데
                $0.viewModel.email.onNext($1)
            }
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(with: self) {
                $0.viewModel.password.onNext($1)
            }
            .disposed(by: disposeBag)

        signInButton.rx.tap
            // subscribe를 사용할 건지 bind를 사용할건지는 이 중간 스트림에 따라서 바뀌겠네
            .subscribe(with: self) { owner, value in
                print("Selected")
            }
//            .bind(with: self) { owner, value in
//                print("Selected")
//            }
            .disposed(by: disposeBag)

        // MARK: - Output
        viewModel.validation
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)   // 굳이 메모리 관리를 해줘야 하는 이유가 원래 사라져야하는 인스턴스가 살아 있기 때문인가?

        // validation애서 완료나 에러를 방출할 수 있지만
        viewModel.validation
            .bind(with: self) { owner, value in
                // UI와 관련된 작업을 할 것이기 때문에 절대 완료나 에러를 방출하게 두면 안된다.
                owner.signInButton.backgroundColor = value ? UIColor.blue : UIColor.red
                owner.emailTextField.layer.borderColor = value ? UIColor.blue.cgColor : UIColor.red.cgColor
                owner.passwordTextField.layer.borderColor = value ? UIColor.blue.cgColor : UIColor.red.cgColor
            }
            .disposed(by: disposeBag)
    }
    
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
