//
//  MASearchListViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/27.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import RxViewController
import RxRelay
import ReactorKit
import AmassingUI
import LentoBaseKit

class Person: NSObject {
    
    @objc dynamic var name: String = "CJL"
}

class MASearchListViewController: LentoBaseViewController {

    var textField: MATextField!
    var passwordField: MATextField!
    var filterBar: UIView!
    var loginButton: UIButton!
    var person: Person!
    open var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInitialization()
        layoutInitialization()
        dataUpdates()
    }
    
    func dataUpdates() {
        person.rx.observeWeakly(String.self, "name").subscribe { strig in
            print("strig====> \(String(describing: strig))")
        } onError: { _ in
            
        }.disposed(by: disposeBag)
        
        let minimalUsernameLength: Int = 10
        
        let usernameValid = passwordField.rx.text.orEmpty.map { string in
            string.count >= minimalUsernameLength
        }.share(replay: 1)
        
        
        let passwordValid = passwordField

        loginButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            print("vcontrolEventcontrolEvent")
            self?.person.name = "zhanghao"
        }).disposed(by: disposeBag)
    
        textField.rx.text.bind(to: loginButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        
        let observable1 = Observable.zip(Observable.just(0),
                                         Observable.just(1),
                                         Observable.just(2),
                                         Observable.just(3),
                                         Observable.just(4),
                                         Observable.just(5))
   
        
        observable1.subscribe { event in
            print("last event ====> \(event)")
        }.disposed(by: disposeBag)
        
        
        let usesddrnameValid = textField.rx.text.orEmpty
                .map { $0.count >= minimalUsernameLength }
                .share(replay: 1)
        
        let usesddrnameValid2 = textField.rx.text.orEmpty
                .map { $0.count <= minimalUsernameLength }
                .share(replay: 1)
        
        
        let obs2 = Observable.combineLatest(
            usernameValid,
            usesddrnameValid2) { ele,esd  in
            return ele && esd } .share(replay: 1)
    }
}

extension UIButton {
    
//    var rx_sayhelloObs: AnyObserver<String> {
//return
//    }
    
}
