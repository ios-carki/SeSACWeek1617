//
//  ValidationViewModel.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/27.
//

import Foundation

import RxSwift
import RxCocoa

class ValidationViewModel {
    
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상, 첫글자는 대문자가 필요합니다.")
    
}
