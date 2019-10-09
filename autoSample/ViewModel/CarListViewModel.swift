//
//  AutoListViewModel.swift
//  autoSample
//
//  Created by Jesus Parada on 10/8/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxDataSources

typealias AutoListIntput = (
    tableView: Reactive<UITableView>,
    spinner: UIActivityIndicatorView,
    loadPage: Observable<Int>
)

typealias AutoListOutput = (
    section: Disposable,
    selectCell: Observable<Car>
)

class CarListViewModel {
    
    private let provider: MoyaProvider<AutoAPI>
    let brand: Brand
    var cars: CarType = CarType()
    
    init(with provider: MoyaProvider<AutoAPI>, brand: Brand) {
        self.provider = provider
        self.brand = brand
    }
    
    func setup(input: AutoListIntput) -> AutoListOutput {
            
            let brands =  input.loadPage.flatMap { [weak self] page -> Observable<CarType> in
                guard let self = self else { return Observable.just(CarType()) }
                return self.getAutoList(with: page, brandID: self.brand.id , indicator: input.spinner)
            }
            
            let dataSource = createDataSource()
            
            let section = brands.asObservable()
                .map(setAutoForCell)
                .bind(to: input.tableView.items(dataSource: dataSource))
            
            let selectCell = input.tableView.modelSelected(Car.self)
                .asObservable()
            
            
            return(section: section,
                   selectCell: selectCell)
        }
}

extension CarListViewModel {
    
    private func createDataSource() -> RxTableViewSectionedReloadDataSource<AutoSection> {
        let dataSource =
            RxTableViewSectionedReloadDataSource<AutoSection>(configureCell:{ (dataSource: TableViewSectionedDataSource<AutoSection>, tableView: UITableView, indexPath: IndexPath, item: AutoDescriptionProtocol) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ManufacturerCarCellView.self), for: indexPath) as? ManufacturerCarCellView else {
                    return UITableViewCell()
                }
                cell.buildCell(for: item)
                cell.backgroundColor = .random
                return cell
            })
        return dataSource
    }
    
    private func getAutoList(with pageNumber: Int, brandID: String, indicator: UIActivityIndicatorView) -> Observable<CarType> {
        return provider.rx.request(.getType(manufacturerId: brandID, page: pageNumber, pageSize: 15))
            .do(onSuccess: {  _ in
                indicator.stopAnimating()
            }, onError: { [weak self] _ in
                indicator.stopAnimating()
            })
            .asObservable()
            .map(CarType.self)
            .retry(2)
    }
    
    private func setAutoForCell(autoType: CarType) -> [AutoSection] {
        var results: [AutoSection] = []
        self.cars.type += autoType.type
        results.append(AutoSection (header: "", items: self.cars.type))
        return results
    }
}
