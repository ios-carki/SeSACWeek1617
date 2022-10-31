//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/20.
//

import Foundation

import RxSwift
import RxCocoa

class NewsViewModel {
    
    //만약 C옵저버블 init이
    /*
     init(call value: String) {
        self.value = value
     }
     
     var pageNumber: CustomObservable<String> = CustomObservable(call: "3000")
     */
    //var pageNumber: CustomObservable<String> = CustomObservable("3000")
    var pageNumber = BehaviorSubject<String>(value: "3,000")
    //var sample: CustomObservable<[News.NewsItem]> = CustomObservable(News.items)
    //var sample = BehaviorSubject(value: News.items)
    var sample = BehaviorRelay(value: News.items)
    
    func changeFormatPageNumber(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)!
        
        //pageNumber.value = result
        pageNumber.onNext(result)
    }
    
    func resetSample() {
        //sample.value = []
        //sample.onNext([])
        sample.accept([])
    }
    
    func loadSample() {
        //sample.value = News.items
        //sample.onNext(News.items)
        sample.accept(News.items)
    }
}
