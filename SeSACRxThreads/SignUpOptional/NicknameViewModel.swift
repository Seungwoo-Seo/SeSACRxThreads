//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by 서승우 on 2023/11/02.
//

import Foundation

import RxCocoa
import RxSwift

class NicknameViewModel {
    let disposeBag = DisposeBag()

    let nickname = BehaviorSubject(value: "")
    let validation = BehaviorSubject(value: true)


    init() {
        nickname
            .map { $0.count < 2 || $0.count >= 6 }
            .subscribe(with: self) { $0.validation.onNext($1) }
            .disposed(by: disposeBag)
    }

}
