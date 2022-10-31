//
//  SubjectViewController.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/25.
//

import UIKit

import RxCocoa
import RxSwift

class SubjectViewController: UIViewController {
    
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var resetBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sampleTableView: UITableView!
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    let publish = PublishSubject<Int>() //초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100) //초기값 필수
    let replay = ReplaySubject<Int>.create(bufferSize: 3) // bufferSize에 작성된 이벤트 갯수만큼 메모리에서 이벤트를 가지고 있다가, subscribe 직후 한 번에 이벤트를 전달
    let async = AsyncSubject<Int>()
    //Variable -> 현재는 안쓰는 Subject
    let disposeBag = DisposeBag()
    let viewDodel = SubjectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sampleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        viewDodel.list
            .bind(to: sampleTableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.phoneNumber))"
            }
            .disposed(by: disposeBag)
        
        addBarButtonItem.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewDodel.fetchData()
            }
            .disposed(by: disposeBag)
        
        resetBarButtonItem.rx.tap // tap = touchupinside
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewDodel.resetData()
            }
            .disposed(by: disposeBag)
        
        newButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewDodel.newData()
            }
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .withUnretained(self)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) //구독 시점에 타이밍 걸어줌 - 기다리는 코드
        //.distinctUntilChanged() // 같은 값은 받지 않음.
            .subscribe { (vc, value) in
                print("=====\(value)")
                vc.viewDodel.filterData(query: value)
            }
            .disposed(by: disposeBag)
//        publishSubject()
//        behaviorSubject()
//        replaySubject()
//        asyncSubject()
        
    }
    
    
    

}

extension SubjectViewController {
    
//    func asyncSubject() {
//        async.onNext(100) // 같음 => publish = 1
//        async.onNext(200)
//        async.onNext(300)
//        async.onNext(400)
//        async.onNext(500)
//
//        //구독시작
//        async
//            .subscribe { value in
//                print("async - \(value)")
//            } onError: { error in
//                print("async - \(error)")
//            } onCompleted: {
//                print("async completed")
//            } onDisposed: {
//                print("async disposed")
//            }
//            .disposed(by: disposeBag)
//
//        //이벤트 방출
//        async.onNext(3)
//        async.onNext(4)
//        async.on(.next(5)) // = publish.onNext(4)
//
//        async.onCompleted() // 작업이 끝난걸 알림
//
//        //onCompleted 이후의 이벤트는 전달이 안됨
//        async.onNext(6)
//        async.onNext(7)
//        async.onNext(8)
//    }
//
//    func replaySubject() {
//        //BufferSize 메모리에 보관, array, 이미지
//        replay.onNext(100) // 같음 => publish = 1
//        replay.onNext(200)
//        replay.onNext(300)
//        replay.onNext(400)
//        replay.onNext(500)
//
//        //구독시작
//        replay
//            .subscribe { value in
//                print("replay - \(value)")
//            } onError: { error in
//                print("replay - \(error)")
//            } onCompleted: {
//                print("replay completed")
//            } onDisposed: {
//                print("replay disposed")
//            }
//            .disposed(by: disposeBag)
//
//        //이벤트 방출
//        replay.onNext(3)
//        replay.onNext(4)
//        replay.on(.next(5)) // = publish.onNext(4)
//
//        replay.onCompleted() // 작업이 끝난걸 알림
//
//        //onCompleted 이후의 이벤트는 전달이 안됨
//        replay.onNext(6)
//        replay.onNext(7)
//        replay.onNext(8)
//    }
//
//    func behaviorSubject() {
//        //구독 전에 가장 최근 값을 같이 emit
//
//        behavior.onNext(1) // 같음 => publish = 1
//        behavior.onNext(200)
//
//        //구독시작
//        behavior
//            .subscribe { value in
//                print("behavior - \(value)")
//            } onError: { error in
//                print("behavior - \(error)")
//            } onCompleted: {
//                print("behavior completed")
//            } onDisposed: {
//                print("behavior disposed")
//            }
//            .disposed(by: disposeBag)
//
//        //이벤트 방출
//        behavior.onNext(3)
//        behavior.onNext(4)
//        behavior.on(.next(5)) // = publish.onNext(4)
//
//        behavior.onCompleted() // 작업이 끝난걸 알림
//
//        //onCompleted 이후의 이벤트는 전달이 안됨
//        behavior.onNext(6)
//        behavior.onNext(7)
//        behavior.onNext(8)
//    }
//
//    func publishSubject() {
//        //초기값이 없는 빈 상태, subscribe 전/error/completed notification 이후 이벤트는 무시
//        //subscribe 후에 대한 이벤트는 다 처리
//
//        //구독 시작 전이라서 값이 대입이 안됨
//        publish.onNext(1) // 같음 => publish = 1
//        publish.onNext(2)
//
//        //구독시작
//        publish
//            .subscribe { value in
//                print("publish - \(value)")
//            } onError: { error in
//                print("publish - \(error)")
//            } onCompleted: {
//                print("publish completed")
//            } onDisposed: {
//                print("publish disposed")
//            }
//            .disposed(by: disposeBag)
//
//        //이벤트 방출
//        publish.onNext(3)
//        publish.onNext(4)
//        publish.on(.next(5)) // = publish.onNext(4)
//
//        publish.onCompleted() // 작업이 끝난걸 알림
//
//        //onCompleted 이후의 이벤트는 전달이 안됨
//        publish.onNext(6)
//        publish.onNext(7)
//        publish.onNext(8)
//
//    }
}
