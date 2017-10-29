//
//  WtDemoWattpadViewController.swift
//  WtCore
//
//  Created by wtfan on 2017/4/07.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

import UIKit

import WtCore

class WtDemoWattpadViewController: UIViewController, WtWattpadViewDelegate, WtWattpadViewDatasource{
    @IBOutlet weak var wattpadView: WtWattpadView!
    
    deinit {
        print("\(#file) - \(#function) - \(#line)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        wattpadView.delegate = self
        wattpadView.datasource = self
        wattpadView.orientation = .LeftRight
        
        let switchButton = UISwitch.init()
        let buttonItem = UIBarButtonItem.init(customView: switchButton)
        navigationItem.rightBarButtonItem = buttonItem
        
        switchButton.wtAction({ [weak wattpadView] (control, controlEvents) in
            guard let switchButton = control as? UISwitch else {
                return
            }

            if switchButton.isOn {
                wattpadView?.orientation = .UpDown
            }else {
                wattpadView?.orientation = .LeftRight
            }
        }, for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        wattpadView.layoutContainerViews()
        wattpadView.reloadData(withIndex: NSNumber.init(value: 0))
    }
    
    // MASK
    func flipView(flipView: UIView, pageViewWithIndex index: AnyObject?) -> UIView? {
        guard let index = index as? NSNumber else {
            return nil
        }
        
        let indexLabel = UILabel.init(frame: flipView.frame)
        indexLabel.textAlignment = .center
        indexLabel.textColor = UIColor.black
        indexLabel.font = UIFont.systemFont(ofSize: 28)
        indexLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        indexLabel.text = "\(index)"
        indexLabel.backgroundColor = UIColor.wtRandom()
        
        return indexLabel
    }
    
    func flipView(flipView: UIView, baseMapViewAtIndex index: AnyObject?) -> UIView? {
        guard let index = index as? NSNumber else {
            return nil
        }
        
        let baseMapView = UIView.init(frame: flipView.frame)
        
        let indexLabel = UILabel.init(frame: flipView.frame)
        indexLabel.textAlignment = .center
        indexLabel.textColor = UIColor.black
        indexLabel.font = UIFont.systemFont(ofSize: 28)
        indexLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        indexLabel.text = "我是底图，index:\(index)"
        baseMapView.addSubview(indexLabel)
        
        return baseMapView
    }
    
    func flipView(flipView: UIView, index: AnyObject?, offset: Int) -> AnyObject? {
        guard index is NSNumber else {
            return NSNumber.init(value: 0)
        }
        
        let i = Int(index!.int64Value) + offset
        
        if abs(i) > 10 {
            return nil
        }
        
        return NSNumber.init(value: i)
    }
}

