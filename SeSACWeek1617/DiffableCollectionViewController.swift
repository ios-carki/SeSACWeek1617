//
//  DefableViewController.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/19.
//

import UIKit
import RxSwift
import RxCocoa

import Kingfisher

class DiffableCollectionViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = DiffableViewModel()
    
    let disposeBag = DisposeBag()
    
//    private var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
    //Int: list 배열길이?, 인덱스 패스? , String: list 배열 요소( row에 들어가는데이터)
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        collectionView.delegate = self
        //searchBar.delegate = self
        bindData()
        
        
    }
    
    func bindData() {
        viewModel.photoList
            .withUnretained(self)
            .subscribe(onNext: { (vc, photo) in
                var snapShot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
                snapShot.appendSections([0])
                snapShot.appendItems(photo.results)
                vc.dataSource.apply(snapShot)
            }, onError: { error in
                print("=====error: \(error)")
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        searchBar
            .rx
            .text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { (vc, value) in
                vc.viewModel.requestSearchPhoto(query: value)
            }
            .disposed(by: disposeBag)
                

    }
    
}

extension DiffableCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//        let alert = UIAlertController(title: item, message: "클릭!", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "확인", style: .cancel)
//        alert.addAction(ok)
//        present(alert, animated: true)
    }
}

//extension DiffableCollectionViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        viewModel.requestSearchPhoto(query: searchBar.text!)
//    }
//}

extension DiffableCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            
            //String -> URL -> Data -> Image
            
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)!
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!)
                    cell.contentConfiguration = content
                }
            }
            
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 2
            background.strokeColor = .brown
            cell.backgroundConfiguration = background
        })
        
        // collectionView.dataSource = self 의 ㄱ코드를 대신함
        //CellForRowAt, numberOfItemsInSection 의 코드를 대신함
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
}
