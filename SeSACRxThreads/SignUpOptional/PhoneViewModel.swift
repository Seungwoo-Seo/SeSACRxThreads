//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 서승우 on 2023/11/02.
//

import Foundation

import RxCocoa
import RxSwift

class PhoneViewModel {
    let disposeBag = DisposeBag()

    let phone = BehaviorSubject(value: "010")

}
