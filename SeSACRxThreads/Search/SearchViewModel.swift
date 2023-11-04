//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 서승우 on 2023/11/04.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchViewModel {
    let disposeBag = DisposeBag()

    // 기본 값
    var data = ["A", "B", "C"]
    lazy var items = BehaviorSubject(value: data)

    struct Input {
        let itemSelected: ControlEvent<IndexPath>
        let modelSelected: ControlEvent<String>
        let searchButtonClicked: ControlEvent<Void>
        let text: ControlProperty<String?>
    }

    struct Output {
        let cellSelected: Observable<String>
    }

    func transform(input: Input) -> Output {
        let cellSelected = Observable
            .zip(
                input.itemSelected,
                input.modelSelected
            )
            .map { "셀 선택 \($0) \($1)" }

        input.searchButtonClicked
            .withLatestFrom(input.text.orEmpty) { _, text in
                return text
            }
            .subscribe(with: self) { owner, value in
                owner.data.insert(value, at: 0)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)

        input.text
            .orEmpty
            .debounce(
                .seconds(1),
                scheduler: MainScheduler.instance
            )
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value == "" ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)

        return Output(cellSelected: cellSelected)
    }

}
