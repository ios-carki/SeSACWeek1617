//
//  ValidationViewController.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/27.
//

import UIKit

import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let disposeBag = DisposeBag()
    let viewModel = ValidationViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validationLabel.text = "8자 이상!"
        bind()
        //observableVSSubject()
        
    }
    
    func bind() {
        
        viewModel.validText
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = nameTextField.rx.text // String?
            .orEmpty    // String (옵셔널 해제)
            .map { $0.count >= 8 }  // Bool
            .share() // Subject, Relay => share안쓰려면 drive객체 사용

        validation
//            .subscribe(onNext: { value in
//                self.stepButton.rx.isEnabled = value
//                self.validationLabel.isHidden = value
//            }) = .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden) // error, complted 만날일 없으면 bind써라
            .disposed(by: disposeBag)

        validation
            .bind { value in
                let color: UIColor = value ? .systemPink : .lightGray
                self.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        stepButton.rx.tap
            .bind { _ in
                print("SHOW ALERT")
            }
            .disposed(by: disposeBag)
        
        //위랑 같음
//        validation
//            .withUnretained(self)
//            .bind { (vc, value) in
//                let color: UIColor = value ? .systemPink : .lightGray
//                vc.stepButton.backgroundColor = color
//            }
//            .disposed(by: disposeBag)
        
        //Stream == Sequence
//        let testA = stepButton.rx.tap
//            .subscribe { _ in
//                print("next")
//            } onError: { error in
//                print("error")
//            } onCompleted: {
//                print("complete")
//            } onDisposed: {
//                print("dispose")
//            }
//            .disposed(by: disposeBag)
            //.disposed(by: DisposeBag()) = .dispose() / dispose 리소스 정리 / 새로운 disposeBag으로 갈아끼워짐 = 바로 멈춤 / deinit

        
    }
    
    func observableVSSubject() {
        let testA = stepButton.rx.tap
            .map { "안녕하세요" }
            .asDriver(onErrorJustReturn: "")
            //.share() // 3번 -> 1번 ( 리소스 공유 )
        
        testA
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(stepButton.rx.title())
            .disposed(by: disposeBag)
        
        let sampleInt = Observable<Int>.create { observer in //.create는 return을 해줘야됨
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100)) //stream을 공유한다
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        /*
         Observable VS Subject
         1. Observable
         2. Subject - Observable에 전달, Observer의 역할, stream 공유 ( share() )
                        - 네 가지 종류 ( publish, behavior, replay, async ) => share()라는 메서드를 갖고있음
                        - 초기값 하나만 가지는 경우 -> behavior
                        - brhavior VS replay -> 한개가 아닌 여러개를 가질때 replay
         
         Subscribe
         1. next
         2. error
         3. complete
         
         bind ( error, complete ) -> 안씀
         1. next
         2. UI요소 담당
         3. 메인쓰레드
         
         drive vs bind
         1. stream을공유, share() - X
         
         relay VS subject
         - relay -> next이벤트만 방출 (relay는 UI에 대한 요소이기 때문에) / publish, behavior / next = accept
         
         Traits => UI처리에 특화
         대부분 stream을 공유 하는 키워드 포함됨(ex. share())
         */
    }
    

}
