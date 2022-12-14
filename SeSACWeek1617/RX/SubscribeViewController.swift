//
//  SubscribeViewController.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/26.
//

import UIKit

import RxCocoa
import RxSwift

class SubscribeViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.
        let sample = button.rx.tap
        
        sample
            .subscribe { [weak self] _ in
                self?.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        //2.
//        button.rx.tap
//            .withUnretained(self)
//            .subscribe {(vc, _) in
//                vc.label.text = "안녕 반가워"
//            }
//            .disposed(by: disposeBag)
        
        //3. 메인 쓰레드
//        button.rx.tap
//            .observe(on: MainScheduler.instance) //다른 쓰레드로 동작하게 변경
//            .withUnretained(self)
//            .subscribe {(vc, _) in
//                
//                vc.label.text = "안녕 반가워"
//            }
//            .disposed(by: disposeBag)
        
        //4. bind: subscribe, mainSchedular, error X
//        button.rx.tap
//            .withUnretained(self)
//            .bind { (vc, _) in
//                vc.label.text = "안녕 반가워"
//            }
//            .disposed(by: disposeBag)
            
        //5. operator로 데이터의 stream 조작
//        button
//            .rx
//            .tap
//            .map { "안녕 반가워" }
//            .bind(to: label.rx.text)
//            .disposed(by: disposeBag)
        
        //6. driver traits(드라이버 특성) = bind traits(바인드 특성) 과 동일
        // + stream이 공유(리소스 낭비 방지, share() )
//            .share()
//            .bind() => 합친거
        button.rx.tap
            .map { "안녕 반가워" }
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
    }
    

}
