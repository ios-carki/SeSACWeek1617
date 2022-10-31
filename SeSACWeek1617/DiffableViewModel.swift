//
//  DiffableViewModel.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/20.
//

import Foundation

import RxSwift

enum SearchError: Error {
    case noPhoto
    case serverError
}

class DiffableViewModel {
    
    //var photoList: CustomObservable<SearchPhoto> = CustomObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    var photoList = PublishSubject<SearchPhoto>()
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { [weak self] photo, statusCode, error in
            
            //위 열거형 선언해서 에러코드 커스텀화
            guard let statusCode = statusCode, statusCode == 200 else {
                self?.photoList.onError(SearchError.serverError)
                return
            }
            
            guard let photo = photo else {
                self?.photoList.onError(SearchError.noPhoto)
                return
                
            }
            //self.photoList.value = photo
            self?.photoList.onNext(photo)
        }
    }
    
}
