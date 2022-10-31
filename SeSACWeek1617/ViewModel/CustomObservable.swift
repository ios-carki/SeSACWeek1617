//
//  CustomObservable.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/20.
//

import Foundation

class CustomObservable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            //2. 옵셔널쪽_체이닝
            listener?(value)
        }
    }
    
    //1. 외부, 내부 매개변수
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}

