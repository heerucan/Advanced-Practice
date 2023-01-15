import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

// MARK: - 구독공유

let source = Observable<String>.create { observer in
    let url = URL(string: "https://roniruny.tistory.com")!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data, let html = String(data: data, encoding: .utf8) {
            observer.onNext(html) // 전달된 문자열을 방출
        }
        
        observer.onCompleted()
    }
    
    task.resume()
    
    return Disposables.create {
        task.cancel()
    }
}
.debug()
.share()

/// 구독자 3개 추가
source.subscribe().disposed(by: disposeBag) // 시퀀스 추가
source.subscribe().disposed(by: disposeBag)
source.subscribe().disposed(by: disposeBag)

/* 이 경우에 3번 네트워크 요청이 실행된다. 구독자가 추가되면 새로운 시퀀스가 추가된다. */
