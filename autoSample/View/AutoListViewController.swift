//
//  AutosViewController.swift
//  autoSample
//
//  Created by Jesus Parada on 10/8/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AutoListViewController: UIViewController {
    
    @IBOutlet weak var carListTableView: UITableView! {
        didSet {
            carListTableView.showsVerticalScrollIndicator = false
            carListTableView.register(UINib(nibName: String(describing: CarCellView.self), bundle: nil), forCellReuseIdentifier:
                "CarCellView")
            carListTableView.separatorStyle = .singleLine
            carListTableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            carListTableView.separatorColor = .random
            carListTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }
    
    private let viewModel: CarListViewModel
    private let isLastCell: PublishSubject<Int> = PublishSubject<Int>()
    private var counter: Int = 0
    private var loadMoreCars:
        Observable<Int> {
        return isLastCell.asObservable()
    }
    private let disposeBag = DisposeBag()
    
        init(with viewModel: CarListViewModel) {
            self.viewModel = viewModel
            super.init(nibName: String(describing: AutoListViewController.self), bundle: nil)
        }
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension AutoListViewController {
    private func bind() {
        let config: AutoListIntput = (
            tableView: carListTableView.rx,
            spinner: spinner,
            navigation: navigationController,
            loadPage: loadMoreCars
        )
        let output = viewModel.setup(input:config)
        
        isLastCell.onNext(counter)
        
        carListTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        output.selectCell
            .subscribe(onNext: { [weak self] car in
                guard let self = self else { return }
               self.viewModel.showCarInfo(with: car, navigation: self.navigationController)
            }).disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDelegate

extension AutoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(indexPath.row * 20)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.cars.type.count - 1{
            counter = counter + 1
            isLastCell.onNext((counter))
        }
    }
}
