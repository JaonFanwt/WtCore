//
//  WtDemoCellGlueSwift.swift
//  WtCore_Example
//
//  Created by fanwt on 2017/12/15.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

import WtCore

class WtDemoCellGlueSwift: NSObject {
    var tableViewDelegate: (WtDelegateProxy & UITableViewDelegate)!
    var tableViewDatasource: (WtDelegateProxy & UITableViewDataSource)!
    
    override init() {
        tableViewDelegate = (WtDelegateProxy.init(with: UITableViewDelegate.self) as? (WtDelegateProxy & UITableViewDelegate))!
        tableViewDatasource = (WtDelegateProxy.init(with: UITableViewDataSource.self) as? (WtDelegateProxy & UITableViewDataSource))!
    }
}
