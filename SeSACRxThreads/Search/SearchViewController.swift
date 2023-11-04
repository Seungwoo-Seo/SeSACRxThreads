//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/11/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
    }

}

class SearchViewController: UIViewController {
     
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 80
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()

    let disposeBag = DisposeBag()

    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        bind()
        setSearchController()
    }
     
    func bind() {
        // MARK: - 이 부분이 고민이네, 궅이 따지지만 Output인데 뭔가 Input Output 보단 View 초기화? 느낌인데 약간, items의 위치를 Output 구조체 안에? 애매하네
        viewModel.items
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchTableViewCell.identifier,
                cellType: SearchTableViewCell.self
            )) { (row, element, cell) in
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .green

                cell.downloadButton.rx.tap
                    .subscribe(with: self) { owner, value in
                        owner.navigationController?.pushViewController(SampleViewController(), animated: true)
                        print("downLoad tap")
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        // MARK: - Input
        let input = SearchViewModel.Input(
            itemSelected: tableView.rx.itemSelected,
            modelSelected: tableView.rx.modelSelected(String.self),
            searchButtonClicked: searchBar.rx.searchButtonClicked,
            text: searchBar.rx.text
        )

        // MARK: - Output
        let output = viewModel.transform(input: input)
        output.cellSelected
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
