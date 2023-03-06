//
//  MemoView.swift
//  MVPPractice
//
//  Created by heerucan on 2023/03/03.
//

import Foundation

/*
 MemoViewController가 채택하고,
 특정 비즈니스 로직에 의한 결과로 MemoViewController로 데이터를 전달
 */
protocol MemoViewProtocol: AnyObject {
    func addMemo(memo: Memo)
    func deleteMemo(index: Int)
    func updateMemo(index: Int, content: String)
}
