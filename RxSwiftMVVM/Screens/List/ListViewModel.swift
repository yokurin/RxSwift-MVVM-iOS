//
//  ListViewModel.swift
//  RxSwiftMVVM
//
//  Created by Tsubasa Hayashi on 2019/04/29.
//  Copyright © 2019 Tsubasa Hayashi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Action
import APIKit

protocol ListViewModelInputs {
    var fetchTrigger: PublishSubject<Void> { get }
    var reachedBottomTrigger: PublishSubject<Void> { get }
}

protocol ListViewModelOutputs {
    var navigationBarTitle: Observable<String> { get }
    var gitHubRepositories: Observable<[GitHubRepository]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<NSError> { get }
}

protocol ListViewModelType {
    var inputs: ListViewModelInputs { get }
    var outputs: ListViewModelOutputs { get }
}

final class ListViewModel: ListViewModelType, ListViewModelInputs, ListViewModelOutputs {

    var inputs: ListViewModelInputs { return self }
    var outputs: ListViewModelOutputs { return self }

    // MARK: - Inputs
    let fetchTrigger = PublishSubject<Void>()
    let reachedBottomTrigger = PublishSubject<Void>()
    private let page = BehaviorRelay<Int>(value: 1)

    // MARK: - Outputs
    let navigationBarTitle: Observable<String>
    let gitHubRepositories: Observable<[GitHubRepository]>
    let isLoading: Observable<Bool>
    let error: Observable<NSError>

    private let searchAction: Action<Int, [GitHubRepository]>
    private let disposeBag = DisposeBag()

    init(language: String) {
        self.navigationBarTitle = Observable.just("\(language) Repositories")
        self.searchAction = Action { page in
            return Session.shared.rx.response(GitHubApi.SearchRequest(language: language, page: page))
        }
        let response = BehaviorRelay<[GitHubRepository]>(value: [])
        self.gitHubRepositories = response.asObservable()

        self.isLoading = searchAction.executing.startWith(false)
        self.error = searchAction.errors.map { _ in NSError(domain: "Network Error", code: 0, userInfo: nil) }

        searchAction.elements
            .withLatestFrom(response) { ($0, $1) }
            .map { $0.1 + $0.0 }
            .bind(to: response)
            .disposed(by: disposeBag)

        searchAction.elements
            .withLatestFrom(page)
            .map { $0 + 1 }
            .bind(to: page)
            .disposed(by: disposeBag)

        fetchTrigger
            .withLatestFrom(page)
            .bind(to: searchAction.inputs)
            .disposed(by: disposeBag)

        reachedBottomTrigger
            .withLatestFrom(isLoading)
            .filter { !$0 }
            .withLatestFrom(page)
            .filter { $0 < 5 }
            .bind(to: searchAction.inputs)
            .disposed(by: disposeBag)
    }

}

