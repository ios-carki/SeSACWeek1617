//
//  RxCocoaExampleViewController.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {

    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var nickname = Observable.just("jack") //옵저버블은 전달만 할 수 있음 = 타입을 바꿀 수 없음 -> Subject객체로
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickname
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.nickname = "HELLO"
//        }
        
        
        
        
        

        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
    }
    
    //viewController가 deinit 되면, 알아서 disposed도 동작한다.
    //루트뷰 컨트롤러는 deinit이 안된다@@@
    //또는 DisposeBag() 객체를 새롭게 넣어주거나, nil 할당 => 예외 케이스!(rootVC에 interval이 있다면?)
    deinit {
        print("RxCocoaExampleViewController")
    }
    
    func setOperator() {
        
        Observable.repeatElement("Jack") //Infinite Observable Sequence
            .take(5) //5번만 반복하도록 -> finite Observable Sequence
            .subscribe { value in
                print("repeatElement - \(value)")
            } onError: { error in
                print("repeatElement - \(error)")
            } onCompleted: {
                print("repeatElement completed")
            } onDisposed: { //disposed 될때 출력
                print("repeatElement disposed")
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) //메인 쓰레드에서 1초마다 간격에 맞게 방출
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
//        let intervalObservable2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) //메인 쓰레드에서 1초마다 간격에 맞게 방출
//            .subscribe { value in
//                print("interval - \(value)")
//            } onError: { error in
//                print("interval - \(error)")
//            } onCompleted: {
//                print("interval completed")
//            } onDisposed: {
//                print("interval disposed")
//            }
//            .disposed(by: disposeBag)
//
//        let intervalObservable3 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) //메인 쓰레드에서 1초마다 간격에 맞게 방출
//            .subscribe { value in
//                print("interval - \(value)")
//            } onError: { error in
//                print("interval - \(error)")
//            } onCompleted: {
//                print("interval completed")
//            } onDisposed: {
//                print("interval disposed")
//            }
//            .disposed(by: disposeBag)
        
        //DisposeBag: 리소스 해제 관리
            //- 1. 시퀀스가 끝날 때 but bind
            //- 2. class deinit 자동 해제 ( bind )
            //- 3. dispose 직접 호출.
            //- 4. DisposeBag을 새롭게 할당하거나, nil 전달.
    
        //dispose() 구독하는 것 마다 별도로 관리
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.disposeBag = DisposeBag() //한번에 리소스 정리할 때 사용
//        }
        
        let itemA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemB = [2.4, 2.0, 1.3]
        
        Observable.just(itemA) //하나의 객체만 가능
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("error - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemA, itemB) //객체 여러개 가능
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func setSign() {
        //ex. 텍스트필드1(Observable), 텍스트필드2(Observable) > 레이블(Observer, bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) {  value1, value2 in
            return "name은 \(value1)이고, 이메일은 \(value2)입니다."
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        //데이터의 흐름 Stream 시퀀스
        signName //UITextField
            .rx //Reactive
            .text //String?
            .orEmpty //옵셔널 해제 String
            .map { $0.count < 4} //Int
            //.map { $0  < 4 } //Bool
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap//touchUpInside
            .withUnretained(self)   //순환참조
            .subscribe(onNext: { vc, _ in // [weak self] RxSwiftCommunity
                vc.showAlert()
            })
//            .subscribe { [ weak self ] _ in // 여기 찾아보기 클로저를 참고하고 있어서???, 순환참조
//                vc.showAlert()
//            }
//            .subscribe(onNext: <#T##(((RxCocoaExampleViewController, ControlEvent<Void>.Element)) -> Void)?##(((RxCocoaExampleViewController, ControlEvent<Void>.Element)) -> Void)?##((RxCocoaExampleViewController, ControlEvent<Void>.Element)) -> Void#>)
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "하하하", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    func setSwitch() {
        Observable.of(false) //just?, of?
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
    }
    
    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
//            .subscribe { value in //성공한 케이스
//                print(value)
//            } onError: { error in
//                print("error")
//            } onCompleted: {
//                print("completed")
//            } onDisposed: {
//                print("disposed")
//            }
            .disposed(by: disposeBag)

        
    }
    
    func setPickerView() {
        
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
//            .subscribe(onNext: { value in
//                print(value)
//            })
            .disposed(by: disposeBag)
     
        
    }
    
}
