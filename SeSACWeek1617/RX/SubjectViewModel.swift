//
//  SubjectViewModel.swift
//  SeSACWeek1617
//
//  Created by Carki on 2022/10/25.
//

import Foundation

import RxSwift

struct Contact {
    var name: String
    var age: Int
    var phoneNumber: String
}

class SubjectViewModel {
    
    var contactData = [
        Contact(name: "jack", age: 21, phoneNumber: "010-1234-1234"),
        Contact(name: "Metaverse Jack", age: 23, phoneNumber: "010-1234-5678"),
        Contact(name: "Real jack", age: 25, phoneNumber: "010-5678-1234")
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        list.onNext(contactData)
    }
    
    func resetData() {
        list.onNext([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), phoneNumber: "")
        contactData.append(new)
        list.onNext(contactData)
    }
    
    func filterData(query: String) {
        
        let result = query != "" ? contactData.filter { $0.name.contains(query) } : contactData
        list.onNext(result)
    }
}
