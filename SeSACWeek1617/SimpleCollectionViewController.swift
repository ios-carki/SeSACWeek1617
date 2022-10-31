//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/18.
//

import UIKit

//class User: Hashable {
//    static func == (lhs: User, rhs: User) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(10)
//    }
//
//    let id = UUID().uuidString //Hashable = 고유하다
//    let name: String //Hashable = 고유하다
//    let age: Int //Hashable = 고유하다
//
//    init(name: String, age: Int) {
//        self.name = name
//        self.age = age
//    }
//}
struct User: Hashable {
    
    let id = UUID().uuidString //Hashable = 고유하다
    let name: String //Hashable = 고유하다
    let age: Int //Hashable = 고유하다
}

class SimpleCollectionViewController: UICollectionViewController {
    
    //var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    var list = [
        User(name: "뽀로로", age: 3),
        User(name: "뽀로로", age: 3),
        User(name: "해리포터", age: 33),
        User(name: "도라에몽", age: 5)
    ]
    
    
    //cellforitemat 이전에 선언이 돼야 함.
    // = regitster(UIcollectionView.sel ~~~~)과 같은 처리
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //컬렉션뷰 전반전인 설정 담당
        //iOS14 ++ 컬렉션뷰를 테이블 뷰 스타일처럼 사용 가능 (List Configuration)
        // 컬렉션뷰 스타일 (컬렉션뷰 셀X)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false //구분선 삭제
        configuration.backgroundColor = .brown //배경색

        //.list -> 테이블 뷰 형태로 사용하겠다
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = createLayout()
        
        //cellforRowAt의 기능을 여기서 담당하게 됨
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()//cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .red //셀에대한 컨텐츠는 여기서 다룸
            
            //디테일 텍스트
            content.secondaryText = "\(itemIdentifier.age) 살"
            //detail텍스트 아래로 배치
            content.prefersSideBySideTextAndSecondaryText = false
            //메인 텍스트와 디테일 텍스트 사이 간격
            content.textToSecondaryTextVerticalPadding = 20
            
            //content.image = indexPath.item < 3 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.image = itemIdentifier.age < 8 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.imageProperties.tintColor = .brown //셀에대한 컨텐츠는 여기서 다룸
            
            print("setUp")
            
            cell.contentConfiguration = content
            
            //백그라운드 컨피그
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .orange
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .systemPink
            cell.backgroundConfiguration = backgroundConfig
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)

            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, User>()
        snapShot.appendSections([0])
        snapShot.appendItems(list)
        dataSource.apply(snapShot)
    }
    
    
}

extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false //구분선 삭제
        configuration.backgroundColor = .brown //배경색
        
        //.list -> 테이블 뷰 형태로 사용하겠다
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
}
