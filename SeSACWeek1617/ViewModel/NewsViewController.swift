//
//  NewsViewController.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/20.
//

import UIKit

import RxSwift
import RxCocoa

class NewsViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    var viewModel = NewsViewModel()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierachy()
        configureDataSource()
        bindData()
        //configureViews()
        
    }
    
    func bindData() {
        
        //numberTextField.text = "3000"
        viewModel.pageNumber.bind { value in
            print("bind == \(value)")
            self.numberTextField.text = value
        }
        
        viewModel.sample
            .withUnretained(self)
            .bind { (vc, item) in
            var snapShot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
            snapShot.appendSections([0])
            snapShot.appendItems(item)
            vc.dataSource.apply(snapShot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
        loadButton
            .rx
            .tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.loadSample()
            }
            .disposed(by: disposeBag)
        
    }
    
//    func configureViews() {
//        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
//        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
//        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
//    }
//
//    @objc func numberTextFieldChanged() {
//        print(#function)
//        guard let text = numberTextField.text else { return }
//        viewModel.changeFormatPageNumber(text: text)
//    }
//
//    @objc func resetButtonTapped() {
//        viewModel.resetSample()
//    }
//
//    @objc func loadButtonTapped() {
//        viewModel.loadSample()
//    }
//
}

extension NewsViewController {
    
    func configureHierachy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
        snapShot.appendSections([0])
        snapShot.appendItems(News.items)
        dataSource.apply(snapShot, animatingDifferences: false)
        
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
}
