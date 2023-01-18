//
//  CustomDelegateProxyViewController.swift
//  RxPractice
//
//  Created by heerucan on 2023/01/18.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import MapKit

class DelegateProxyViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.rx.didUpdateLocation
            .subscribe { locations in
                print(locations)
            }
            .disposed(by: bag)
        
        locationManager.rx.didUpdateLocation
            .map { $0[0] }
            .bind(to: mapView.rx.center)
            .disposed(by: bag)
        
        locationManager.rx.didFailWithError
            .subscribe { locations in
                print("실패 -", locations)
            }
            .disposed(by: bag)
    }
}


extension Reactive where Base: MKMapView {
    public var center: Binder<CLLocation> {
        return Binder(self.base) { mapView, location in
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.base.setRegion(region, animated: true)
        }
    }
}

// CLLocationManagerDelegate Extension
extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

// DelegateProxy를 상속해야 하고, 제네릭 클래스이고, 2개의 형식 파라미터를 받는데 1. 확장할 클래스, 2. 연관된 델리케이트 프로토콜
// DelegateProxyType 프로토콜과 연관된 델리게이트를 채택해줘야 한다.
/* DelegateProxyType
 클래스 프로토콜로 선언되어서 6개의 필수 멤버를 갖고 있다.
 HasDelegate 프로토콜을 채택하면 기본 구현을 제공한다.
 */
class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    weak private(set) var locationManager: CLLocationManager?
    
    // 확장대상을 파라미터로 받는다.
    init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
        self.locationManager = locationManager
    }
    
    static func registerKnownImplementations() {
        // 클로저에서는 DelegateProxy의 인스턴스를 리턴해야 한다.
        self.register {
            RxCLLocationManagerDelegateProxy(locationManager: $0)
        }
    }
}

extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocation: Observable<[CLLocation]> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { parameters in
                return parameters[1] as! [CLLocation]
            }
    }
    
    var didFailWithError: Observable<[CLLocation]> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFailWithError:)))
            .map { parameters in
                return parameters[1] as? [CLLocation] ?? [CLLocation()]
            }
    }
}
