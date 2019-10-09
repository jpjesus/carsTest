//
//  ManufacturerViewModel.swift
//  autoSample
//
//  Created by Jesus Alberto on 10/6/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxDataSources

typealias ManufacturerListIntput = (
    tableView: Reactive<UITableView>,
    spinner: UIActivityIndicatorView,
    navigation: UINavigationController?,
    loadPage: Observable<Int>
)

typealias ManufacturerListOutput = (
    section: Disposable,
    selectCell: Observable<Brand>
)

class ManufacturerViewModel {
    
    private let provider: MoyaProvider<AutoAPI>
    private var pageNumber: Int = 0
    var manufacturer: Manufacturer = Manufacturer()
    
    
    init(with provider: MoyaProvider<AutoAPI>) {
        self.provider = provider
    }
    
    func setup(input: ManufacturerListIntput) -> ManufacturerListOutput {
        
        let brands =  input.loadPage.flatMap { [weak self] page -> Observable<Manufacturer> in
            guard let self = self else { return Observable.just(Manufacturer()) }
            return self.getManufacturerType(with: page, indicator: input.spinner, navigation: input.navigation)
        }
    
        let dataSource = createDataSource()
        
        let section = brands.asObservable()
            .map(setBrandsForCell)
            .bind(to: input.tableView.items(dataSource: dataSource))
        
        let selectCell = input.tableView.modelSelected(Brand.self)
            .asObservable()
        

        return(section: section,
                 selectCell: selectCell)
    }
    
    func showAutoModel(with navigation: UINavigationController?, brand: Brand) {
        let viewModel = CarListViewModel(with: provider, brand: brand)
        let vc = AutoListViewController(with: viewModel)
        navigation?.pushFadeAnimation(viewController: vc)
    }
}

extension ManufacturerViewModel {
    
    private func createDataSource() -> RxTableViewSectionedAnimatedDataSource<ManufacturerSection> {
        let dataSource =
            RxTableViewSectionedAnimatedDataSource<ManufacturerSection>(configureCell:{ (dataSource: TableViewSectionedDataSource<ManufacturerSection>, tableView: UITableView, indexPath: IndexPath, item: Brand) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ManufacturerCarCellView.self), for: indexPath) as? ManufacturerCarCellView else {
                return UITableViewCell()
            }
            cell.buildCell(for: item)
            cell.backgroundColor = .random
            return cell
        })
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .bottom)
        return dataSource
    }
    
    private func setBrandsForCell(manufacturer: Manufacturer) -> [ManufacturerSection] {
        var results: [ManufacturerSection] = []
        self.manufacturer.type += manufacturer.type
        results.append(ManufacturerSection(header: "", items: self.manufacturer.type.sorted { $0.id < $1.id }))
        return results
    }
    
    private func getManufacturerType(with pageNumber: Int, indicator: UIActivityIndicatorView, navigation: UINavigationController?) -> Observable<Manufacturer> {
        return provider.rx.request(.getManufacturer(page: pageNumber, pageSize: 15))
            .do(onSuccess: {  _ in
                indicator.stopAnimating()
            }, onError: {  _ in
                indicator.stopAnimating()
                UINavigationController.showOfflineAlert(with: navigation)
            })
            .asObservable()
            .map(Manufacturer.self)
            .retry(2)
    }
}
