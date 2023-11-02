//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 서승우 on 2023/11/02.
//

import Foundation

import RxCocoa
import RxSwift

class BirthdayViewModel {
    let disposeBag = DisposeBag()

    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    let year = BehaviorSubject(value: 2023)
    let month = BehaviorSubject(value: 11)
    let day = BehaviorSubject(value: 2)

    init() {
        birthday            
            .subscribe(with: self) {
                let calendar = Calendar.current
                let component = calendar.dateComponents([.year, .month, .day], from: $1)
                $0.year.onNext(component.year!)
                $0.month.onNext(component.month!)
                $0.day.onNext(component.day!)
            }
            .disposed(by: disposeBag)
    }

}
