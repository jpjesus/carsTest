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
    collectionView: Reactive<UICollectionView>,
    navigation: UINavigationController?,
    spinner: UIActivityIndicatorView
)

typealias ManufacturerListOutput = (
    section: Disposable,
    selectCell: Observable<Brand>
)

class ManufacturerViewModel {
    
    private let provider: MoyaProvider<AutoAPI>
    
    
    init(with provider: MoyaProvider<AutoAPI>) {
        self.provider = provider
    }
    
    func setup(input: ManufacturerListIntput) -> ManufacturerListOutput {
        
        let brands = provider.rx.request(.getManufacturer(page: 0, pageSize: 10))
            .do(onSuccess: {  _ in
                input.spinner.stopAnimating()
            }, onError: { [weak self] _ in
                input.spinner.stopAnimating()
            })
            .asObservable()
            .map(Manufacturer.self)
            .retry(1)
        
        let dataSource = createDataSource()
        
        let section = brands.asObservable()
            .map(setBrandsForCell)
            .bind(to: input.collectionView.items(dataSource: dataSource))
        
        let selectCell = input.collectionView.modelSelected(Brand.self)
            .asObservable()
        
        return(section: section,
                 selectCell: selectCell)
    }
    
}

extension ManufacturerViewModel {
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ManufacturerSection> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ManufacturerSection>(configureCell:{ (dataSource: CollectionViewSectionedDataSource<ManufacturerSection>, collectionView: UICollectionView, indexPath: IndexPath, item: Brand) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ManufacturerCarCellView.self), for: indexPath) as? ManufacturerCarCellView else {
                return UICollectionViewCell()
            }
            //cell.buildCell(for: item)
            return cell
        })
        return dataSource
    }
    
    private func setBrandsForCell(manufacturer: Manufacturer) -> [ManufacturerSection] {
        var results: [ManufacturerSection] = []
        results.append(ManufacturerSection (header: "", items: manufacturer.brands))
        return results
    }
}
