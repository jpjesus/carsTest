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
    navigation: UINavigationController?,
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
                return self.getAutoList(with: page, brandID: self.brand.id , indicator: input.spinner, navigation: input.navigation)
            }
            
            let dataSource = createDataSource()
            
            let section = brands.asObservable()
                .map(setAutoForCell)
                .bind(to: input.tableView.items(dataSource: dataSource))
        
           input.tableView.isHidden.onNext(false)
            
            let selectCell = input.tableView.modelSelected(Car.self)
                .asObservable()
            
            
            return(section: section,
                   selectCell: selectCell)
        }
    
    func showCarInfo(with car: Car, navigation: UINavigationController?) {
        UINavigationController.showCartInfo(with: navigation, brandName: brand.name, carModel: car.name)
    }
}

extension CarListViewModel {
    
    private func createDataSource() -> RxTableViewSectionedAnimatedDataSource<CarSection> {
        let dataSource =
            RxTableViewSectionedAnimatedDataSource<CarSection>(configureCell:{ (dataSource: TableViewSectionedDataSource<CarSection>, tableView: UITableView, indexPath: IndexPath, item: Car) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CarCellView.self), for: indexPath) as? CarCellView else {
                    return UITableViewCell()
                }
                cell.buildCell(for: item)
                cell.backgroundColor = .random
                return cell
            })
         dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .bottom)
        return dataSource
    }
    
    private func getAutoList(with pageNumber: Int, brandID: String, indicator: UIActivityIndicatorView, navigation: UINavigationController?) -> Observable<CarType> {
        return provider.rx.request(.getType(manufacturerId: brandID, page: pageNumber, pageSize: 15))
            .do(onSuccess: {  _ in
                indicator.stopAnimating()
            }, onError: { _ in
                indicator.stopAnimating()
                UINavigationController.showOfflineAlert(with: navigation)
            })
            .asObservable()
            .map(CarType.self)
            .retry(2)
    }
    
    private func setAutoForCell(autoType: CarType) -> [CarSection] {
        var results: [CarSection] = []
        self.cars.type += autoType.type
        results.append(CarSection (header: "", items: self.cars.type.sorted { $0.id < $1.id }))
        return results
    }
}
