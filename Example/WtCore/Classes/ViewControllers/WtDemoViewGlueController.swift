//
//  WtDemoViewGlueController.swift
//  WtCore_Example
//
//  Created by fanwt on 2017/12/15.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

import UIKit

import WtCore

class WtDemoViewGlueController: UIViewController {
    var datas = [WtDemoCellGlueSwift]()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        title = "WtViewGlue - WtCore used on Swift"
        createDatas()
        tableView.reloadData()
    }
    
    func createDatas(){
        let cellGlue = WtDemoCellGlueSwift()
        datas.append(cellGlue)

        cellGlue.tableViewDatasource.selector(#selector(UITableViewDataSource.tableView(_:cellForRowAt:)), block: ({
            tableView, indexPath in
            let identifier = "DemoViewGlueCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            if (cell == nil) {
                cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            }
            cell?.textLabel?.text = "aaaaa"
            return cell!
            } as @convention(block) (UITableView, IndexPath) -> UITableViewCell))

        cellGlue.tableViewDelegate.selector(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:)), block: ({
                tableView , indexPath in
                tableView.deselectRow(at: indexPath, animated: true)
            } as @convention(block) (UITableView, IndexPath) -> Void))
        
        
        let cellGlue2 = WtDemoCellGlueSwift()
        datas.append(cellGlue2)
        
        cellGlue2.tableViewDatasource.selector(#selector(UITableViewDataSource.tableView(_:cellForRowAt:)), block: ({
            tableView, indexPath in
            let identifier = "DemoViewGlueCell2Identifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            if (cell == nil) {
                cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            }
            cell?.textLabel?.text = "bbbb"
            return cell!
            } as @convention(block) (UITableView, IndexPath) -> UITableViewCell))
        
        cellGlue2.tableViewDelegate.selector(#selector(UITableViewDelegate.tableView(_:heightForRowAt:)), block: ({
            tableView, indexPath in
            return 100
            } as @convention(block) (UITableView, IndexPath) -> CGFloat))
        
        
        let cellGlue3 = WtDemoCellGlueSwift()
        datas.append(cellGlue3)
        
        cellGlue3.tableViewDatasource.selector(#selector(UITableViewDataSource.tableView(_:cellForRowAt:)), block: ({
            tableView, indexPath in
            let identifier = "DemoViewGlueCell3Identifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            if (cell == nil) {
                cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            }
            cell?.textLabel?.text = "ccccc"
            cell?.detailTextLabel?.text = "detailTextLabel"
            return cell!
            } as @convention(block) (UITableView, IndexPath) -> UITableViewCell))
        
        cellGlue3.tableViewDelegate.selector(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:)), block: ({
            tableView , indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
            } as @convention(block) (UITableView, IndexPath) -> Void))
        
        cellGlue3.tableViewDelegate.selector(#selector(UITableViewDelegate.tableView(_:heightForRowAt:)), block: ({
            tableView, indexPath in
            return 60
            } as @convention(block) (UITableView, IndexPath) -> CGFloat))
    }
}

extension WtDemoViewGlueController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellGlue = datas[indexPath.row]
        let cell = cellGlue.tableViewDatasource.tableView(tableView, cellForRowAt: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellGlue = datas[indexPath.row]
        let h = cellGlue.tableViewDelegate.tableView?(tableView, heightForRowAt: indexPath) ?? 44
        return h
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellGlue = datas[indexPath.row]
        cellGlue.tableViewDelegate.tableView?(tableView, didSelectRowAt: indexPath)
    }
}
