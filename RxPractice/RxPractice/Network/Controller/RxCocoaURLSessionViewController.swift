//
//  RxCocoaURLSessionViewController.swift
//  RxPractice
//
//  Created by heerucan on 2023/01/19.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

enum ApiError: Error {
    case badUrl
    case invalidResponse
    case failed(Int)
    case invalidData
}

// 옵저버블 직접 생성
// RxCocoa가 제공하는 익스텐션사용
// 라이브러리 사용
class RxCocoaURLSessionViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let list = BehaviorSubject<[Book]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
                cell.textLabel?.text = element.title
                cell.detailTextLabel?.text = element.desc
            }
            .disposed(by: rx.disposeBag)
        
        fetchBookList()
    }
    
    
    func fetchBookList() {
                
        // just연산자로 url 방출 -> URL
        // URL -> URLRequest 객체로 변환
        // RxCocoa에서 제공하는 URLSession Extension 중 data method는 파라미터로 URLRequest를 받음
        // 최종적으로 bookUrlStr이라는 문자열을 방출하는 옵저버블이 Observable<Data>를 방출하는 옵저버블이 되게 된다.
        let response = Observable.just(booksUrlStr)
            .map { URL(string: $0)! }
            .map { URLRequest(url: $0) }
            .flatMap { URLSession.shared.rx.data(request: $0) }
            .map(BookList.parse(data:)) // data를 받아 [Book] 배열로 반환
            .asDriver(onErrorJustReturn: [])
        
        
//        let response = Observable<[Book]>.create { observer in
//            guard let url = URL(string: booksUrlStr) else {
//                fatalError("Invalid URL")
//                // 에러가 발생한 부분이니까 error event 전달
//                observer.onError(ApiError.badUrl)
//                return Disposables.create()
//            }
//
//            let session = URLSession.shared
//
//            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
//
//                if let error = error {
//                    // 에러가 발생한 부분이니까 error event 전달
//                    observer.onError(error)
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    // 에러가 발생한 부분이니까 error event 전달
//                    observer.onError(ApiError.invalidData)
//                    return
//                }
//
//                guard (200...299).contains(httpResponse.statusCode) else {
//                    // 에러가 발생한 부분이니까 error event 전달
//                    observer.onError(ApiError.failed(httpResponse.statusCode))
//                    return
//                }
//
//                guard let data = data else {
//                    // 에러가 발생한 부분이니까 error event 전달
//                    observer.onError(ApiError.invalidData)
//                    return
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let bookList = try decoder.decode(BookList.self, from: data)
//
//                    if bookList.code == 200 {
//                        // 결과를 next event로 방출
//                        observer.onNext(bookList.list)
//                    } else {
//                        observer.onNext([])
//                    }
//                    observer.onCompleted()
//                } catch {
//                    observer.onError(error)
//                }
//            }
//            task.resume()
//            return Disposables.create {
//                task.cancel() // Dispose 시점에는 현재 실행하는 datatask를 cancel시키게 구현
//                // 옵저버블이 방출하는 이벤트는 tableView에 바인딩되기에 옵저버블을 driver로 바꾸면 효율적
//            }
//        }
//            .asDriver(onErrorJustReturn: [])
        
        response
            .drive(list)
            .disposed(by: rx.disposeBag)
        
        // 시퀀스가 시작되는 시점에 true를 방출하고 response에서 next event를 방출하면 그 값을 false로 바꿔서 방출한다.
        // 그러면 그 false값을 isNetworkActivityIndicatorVisible -> 이 바인더에 바인딩한다.
        response
            .map { _ in false }
            .startWith(true)
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: rx.disposeBag)
    }
}
// just연산자로 url 방출 -> URL
// URL -> URLRequest 객체로 변환
// RxCocoa에서 제공하는 URLSession Extension 중 data method는 파라미터로 URLRequest를 받음
// 최종적으로 bookUrlStr이라는 문자열을 방출하는 옵저버블이 Observable<Data>를 방출하는 옵저버블이 되게 된다.
