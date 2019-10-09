//
//  ManufacturerViewController.swift
//  autoSample
//
//  Created by Jesus Parada on 10/7/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ManufacturerViewController: UIViewController {
    @IBOutlet private weak var manufacturerTableView: UITableView! {
        didSet {
            manufacturerTableView.showsVerticalScrollIndicator = false
            manufacturerTableView.register(UINib(nibName: String(describing: ManufacturerCarCellView.self), bundle: nil), forCellReuseIdentifier:
                "ManufacturerCarCellView")
            manufacturerTableView.separatorStyle = .singleLine
            manufacturerTableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            manufacturerTableView.separatorColor = .random
            manufacturerTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }
    
    private let viewModel: ManufacturerViewModel
    private let disposeBag = DisposeBag()
    private let insets: CGFloat = 10
    private let cellHegiht: CGFloat = 90
    private let isLastCell: PublishSubject<Int> = PublishSubject<Int>()
    private var counter: Int = 0
    private var loadMoreBrands: Observable<Int> {
        return isLastCell.asObservable()
    }
    
    init(with viewModel: ManufacturerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ManufacturerViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ManufacturerViewController {
    
    private func bind() {
        let config: ManufacturerListIntput = (
            tableView: manufacturerTableView.rx,
            spinner: spinner,
            navigation: navigationController,
            loadPage: loadMoreBrands
        )
        let output = viewModel.setup(input:config)
        
         isLastCell.onNext(counter)
        
        manufacturerTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        output.selectCell
            .subscribe(onNext: { [weak self] manufacturerBrand in
                guard let self = self else { return }
                self.viewModel.showAutoModel(with: self.navigationController, brand: manufacturerBrand)
            }).disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDelegate

extension ManufacturerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(indexPath.row * 20)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.manufacturer.type.count - 1{
            counter = counter + 1
            isLastCell.onNext((counter))
        }
    }
}
