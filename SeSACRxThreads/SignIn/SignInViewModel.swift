//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxCocoa
import RxSwift

class SignInViewModel {
    let disposeBag = DisposeBag()

    let email = BehaviorSubject(value: "")
    let password = BehaviorSubject(value: "")

    let validation: Observable<Bool>

    init() {
        // 아 착각하고 있던게 Observable 스트림을 시작할 땐 무조건 create, just, of, from으로 시작해야 하는 줄 알았는데
        // 생각해보니까 결국 걔네도 다 operater네 결국 여러 operater들을 거쳐서 데이터가 가공되고 가공된 데이터를 옵저버가 마지막에
        // 처리해주는 Flow로 가면 이지하네
        self.validation = Observable
            .combineLatest(email, password) {
                $0.count > 8 && $1.count >= 6
            }
        // 원래 이 시점에 validation에서 참조하고 있는 인스턴스는 더 이상 사용되지 않기 때문에 소멸되야하는거 아니냐?
        // 해답 : Observable은 보통의 클래스 인스턴스의 생명주기와 약간 다르게 동작한다고 한다.
    }
    
}
