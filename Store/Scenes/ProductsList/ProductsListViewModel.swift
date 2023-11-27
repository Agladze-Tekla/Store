//
//  ProductsListViewModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import Foundation

protocol ProductsListViewModelDelegate: AnyObject {
    func productsFetched()
    func showError(_ error: Error)
    func productsAmountChanged()
}

final class ProductsListViewModel {

    weak var delegate: ProductsListViewModelDelegate?
    
    var products: [ProductModel]?
    var totalPrice: Double? { products?.reduce(0) { $0 + $1.price * Double(($1.selectedAmount ?? 0))} }
    
    func viewDidLoad() {
        fetchProducts()
    }
    
    private func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] response in
            switch response {
            case .success(let products):
                self?.products = products
                self?.delegate?.productsFetched()
            case .failure(let error):
                //Handled Error
                self?.delegate?.showError(error)
                //break
            }
        }
    }
    
    func addProduct(at index: Int) {
        var product = products?[index]
        //TODO: handle if products are out of stock
        if product?.stock != 0 {
        product?.selectedAmount = (products?[index].selectedAmount ?? 0 ) + 1
        delegate?.productsAmountChanged()
        } else {
            print("Our of stock.")
        }
    }
    
    func removeProduct(at index: Int) {
        var product = products?[index]
        //TODO: handle if selected quantity of product is already 0
        if product?.stock != 0 {
        product?.selectedAmount = (products?[index].selectedAmount ?? 0 ) - 1
        delegate?.productsAmountChanged()
        } else {
            print("Product not chosen yet.")
        }
    }
}
