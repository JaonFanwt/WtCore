//
//  WtWattpadView.swift
//  Pods
//
//  Created by wtfan on 2017/7/4.
//
//

import Foundation

import SnapKit

public protocol WtWattpadViewDelegate {
}

public protocol WtWattpadViewDatasource {
    func flipView(flipView: UIView, baseMapViewAtIndex: AnyObject?) -> UIView?
    func flipView(flipView: UIView, index: AnyObject?, offset: Int) -> AnyObject?
    func flipView(flipView: UIView, pageViewWithIndex index: AnyObject?) -> UIView?
}

extension UIView {
    func removeAllSubviews() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
}

class WtContainerView: UIView {
    public var index: Int = 0
    
    init(index i: Int) {
        super.init(frame: .zero)
        
        index = i
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var description: String {
        get {
            return "Index: \(index) - \(frame)"
        }
    }
}

public enum WtWattpadOrientation {
    case LeftRight
    case UpDown
}

public class WtWattpadView: UIView {
    public var orientation: WtWattpadOrientation = .UpDown {
        didSet {
            isOrientationUpDown = orientation == .UpDown
            flipMinOffset = isOrientationUpDown ? 100 : 40
        }
    }
    var isOrientationUpDown: Bool = true
    public var delegate: WtWattpadViewDelegate! = nil
    public var datasource: WtWattpadViewDatasource! = nil
    public var currentIndex: AnyObject? {
        get {
            return hCurrentIndex
        }
    }
    
    struct ContentIndex {
        var current: AnyObject?
        var pre: AnyObject?
        var next: AnyObject?
        
        // 手势滑动时记录动态Index
        var dynamicPre: AnyObject?
        var dynamicNext: AnyObject?
    }
    
    struct ContentView {
        var current: UIView!
        var pre: UIView!
        var next: UIView!
        
        struct BasemapView {
            var pre: UIView?
            var current: UIView?
        }
        
        var basemap: BasemapView! = BasemapView()
        
        func cleanup() {
            current?.removeFromSuperview()
            pre?.removeFromSuperview()
            next?.removeFromSuperview()
            basemap.pre?.removeFromSuperview()
            basemap.current?.removeFromSuperview()
        }
        
        func array() -> [UIView] {
            return [pre, current, next]
        }
    }
    
    struct ContainerView {
        var current: UIView! = WtContainerView.init(index: 0)
        var pre: UIView! = WtContainerView.init(index: -1)
        var next: UIView! = WtContainerView.init(index: 1)
        
        func cleanup() {
            current.removeAllSubviews()
            pre.removeAllSubviews()
            next.removeAllSubviews()
        }
        
        func array() -> [UIView] {
            return [pre, current, next]
        }
    }
    
    enum BaseMapStatus {
        case none
        case up
        case down
    }
    
    enum GestureOrientation {
        enum Pre {
            case x
            case y
        }
        enum Next {
            case x
            case y
        }
    }
    
    struct HasBasemapView {
        var current: Bool! = false
        var pre: Bool! = false
    }
    
    var containerView: ContainerView = ContainerView()
    var contentIndex: ContentIndex = ContentIndex()
    var contentView: ContentView = ContentView()
    var basemapStatus: BaseMapStatus = .none
    var hasBasemapView: HasBasemapView! = HasBasemapView()
    
    var hCurrentIndex: AnyObject? = nil
    var flipMinOffset: CGFloat = 100.0
    var animationDuration: TimeInterval = 0.3
    
    var tapGesture: UITapGestureRecognizer! = nil
    var panGesture: UIPanGestureRecognizer! = nil
    var beganPoint: CGPoint? = nil
    
    deinit {
        self.removeGestureRecognizer(tapGesture)
        self.removeGestureRecognizer(panGesture)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        initProperties()
        createSubviews()
        createAtions()
    }
    
    public func cleanPageIndex() {
        hCurrentIndex = nil
    }
    
    func swapValue<T>(_ a: inout T, _ b: inout T) {
        let temp = a
        a = b
        b = temp
    }
    
    func modifying<T>(_ value: inout T, _ function: (inout T) -> ()) {
        function(&value)
    }
    
    public func layoutContainerViews() {
        if basemapStatus == .up {
            // 状态为：
            //  -1         0 -1
            //  ---        ---
            //   0   --->  basemap
            //  ---        ---
            //   1          1
            //  由1图切换到2图，current和next不变
            containerView.current.transform = .identity
            containerView.next.transform = .identity
            
            if orientation == .UpDown {
                containerView.current.frame.origin.y = -frame.size.height
                containerView.next.frame.origin.y = frame.size.height
            }else {
                containerView.current.frame.origin.x = -frame.size.width
                containerView.next.frame.origin.x = frame.size.width
            }
        }else if basemapStatus == .down {
            // 状态为：
            //  -1         -1
            //  ---        ---
            //   0   --->  basemap
            //  ---        ---
            //   1          0 1
            //  由1图切换到2图，current由原先的0改为-1，next由原先的1改为0
            containerView.current.transform = .identity
            containerView.next.transform = .identity
            
            if orientation == .UpDown {
                containerView.current.frame.origin.y = -frame.size.height
                containerView.next.frame.origin.y = frame.size.height
            }else {
                containerView.current.frame.origin.x = -frame.size.width
                containerView.next.frame.origin.x = frame.size.width
            }
            
        }else {
            
            containerView.pre.transform = .identity
            containerView.current.transform = .identity
            containerView.next.transform = .identity
            
            if orientation == .UpDown {
                if contentView.basemap.pre != nil {
                    containerView.pre.frame.origin.y = -2*frame.size.height
                }else {
                    containerView.pre.frame.origin.y = -frame.size.height
                }
                
                if contentView.basemap.current != nil {
                    containerView.next.frame.origin.y = 2*frame.size.height
                }else {
                    containerView.next.frame.origin.y = frame.size.height
                }
                
                containerView.current.frame.origin.y = 0
            }else {
                if contentView.basemap.pre != nil {
                    containerView.pre.frame.origin.x = -2*frame.size.width
                }else {
                    containerView.pre.frame.origin.x = -frame.size.width
                }
                
                if contentView.basemap.current != nil {
                    containerView.next.frame.origin.x = 2*frame.size.width
                }else {
                    containerView.next.frame.origin.x = frame.size.width
                }
                
                containerView.current.frame.origin.x = 0
            }
        }
    }
    
    public func reloadData(withIndex index: AnyObject) {
        hCurrentIndex = index
        
        loadData()
    }
    
    func loadData() {
        contentView.cleanup()
        
        loadContentViews(index: hCurrentIndex!)
        
        bringSubview(toFront: containerView.current)
        
        zip(containerView.array(), contentView.array()).forEach { (_containerView, _contentView) in
            _contentView.isUserInteractionEnabled = true
            _containerView.addSubview(_contentView)
        }
        
        layoutContainerViews()
    }
    
    func loadContentViews(index: AnyObject) {
        contentIndex.current = datasource.flipView(flipView: self, index: index, offset: 0)
        contentView.current = datasource.flipView(flipView: self, pageViewWithIndex: contentIndex.current) ?? UIView.init()
        contentView.basemap.current = datasource.flipView(flipView: self, baseMapViewAtIndex: contentIndex.current)
        
        contentIndex.pre = datasource.flipView(flipView: self, index: contentIndex.current, offset: -1)
        contentView.pre = datasource.flipView(flipView: self, pageViewWithIndex: contentIndex.pre) ?? UIView.init()
        contentView.basemap.pre = datasource.flipView(flipView: self, baseMapViewAtIndex: contentIndex.pre)
        
        contentIndex.next = datasource.flipView(flipView: self, index: contentIndex.current, offset: 1)
        contentView.next = datasource.flipView(flipView: self, pageViewWithIndex: contentIndex.next) ?? UIView.init()
    }
    
    func loadNextContentView() {
        contentView.next.removeFromSuperview()
        
        hCurrentIndex = contentIndex.current
        contentIndex.next = datasource.flipView(flipView: self, index: contentIndex.current, offset: 1)
        contentView.next = datasource.flipView(flipView: self, pageViewWithIndex: contentIndex.next) ?? UIView.init()
        containerView.next.addSubview(contentView.next)
        
        modifying(&contentView.basemap) { basemap in swapValue(&basemap.current, &basemap.pre) }
        
        contentView.basemap.current?.removeFromSuperview()
        contentView.basemap.current = datasource.flipView(flipView: self, baseMapViewAtIndex: contentIndex.current)
        if contentView.basemap.current != nil {
            insertSubview(contentView.basemap.current!, at: 0)
        }
        
        bringSubview(toFront: containerView.current)
    }
    
    func loadPreContentView() {
        contentView.pre.removeFromSuperview()
        
        hCurrentIndex = contentIndex.current
        contentIndex.pre = datasource.flipView(flipView: self, index: contentIndex.current, offset: -1)
        contentView.pre = datasource.flipView(flipView: self, pageViewWithIndex: contentIndex.pre) ?? UIView.init()
        containerView.pre.addSubview(contentView.pre)
        
        modifying(&contentView.basemap) { basemap in swapValue(&basemap.current, &basemap.pre) }
        
        contentView.basemap.pre?.removeFromSuperview()
        contentView.basemap.pre = datasource.flipView(flipView: self, baseMapViewAtIndex: contentIndex.pre)
        
        bringSubview(toFront: containerView.current)
    }
    
    func swapCurrentToNext() {
        modifying(&containerView) { containerView in swapValue(&containerView.current, &containerView.next) }
        modifying(&contentIndex) { contentIndex in swapValue(&contentIndex.current, &contentIndex.next) }
        modifying(&contentView) { contentView in swapValue(&contentView.current, &contentView.next) }
        
        modifying(&containerView) { containerView in swapValue(&containerView.next, &containerView.pre) }
        modifying(&contentView) { contentView in swapValue(&contentView.next, &contentView.pre) }
        modifying(&contentIndex) { contentIndex in swapValue(&contentIndex.next, &contentIndex.pre) }
        
        hCurrentIndex = contentIndex.current
    }
    
    func swapCurrentToPre() {
        modifying(&containerView) { containerView in swapValue(&containerView.current, &containerView.pre) }
        modifying(&contentIndex) { contentIndex in swapValue(&contentIndex.current, &contentIndex.pre) }
        modifying(&contentView) { contentView in swapValue(&contentView.current, &contentView.pre) }
        
        modifying(&containerView) { containerView in swapValue(&containerView.pre, &containerView.next) }
        modifying(&contentIndex) { contentIndex in swapValue(&contentIndex.pre, &contentIndex.next) }
        modifying(&contentView) { contentView in swapValue(&contentView.pre, &contentView.next) }
        
        hCurrentIndex = contentIndex.current
    }
    
    func initProperties() {
        self.orientation = .UpDown
    }
    
    func createSubviews() -> Void {
        for v in containerView.array() {
            v.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height);
            v.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
            addSubview(v)
        }
    }
    
    func createAtions() -> Void {
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handlerTapGesture(tapGesture:)))
        addGestureRecognizer(tapGesture)
        
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlerPanGesture(panGesture:)))
        addGestureRecognizer(panGesture)
    }
    
    func fixNextContent() {
        guard let dynamicNextIndex = contentIndex.dynamicNext else {
            return
        }
        
        if contentIndex.next == nil || contentIndex.next?.isEqual(dynamicNextIndex) == false {
            contentIndex.next = dynamicNextIndex
            contentView.next.removeFromSuperview()
            
            contentView.next = datasource.flipView(flipView: self, pageViewWithIndex: contentIndex.next) ?? UIView.init()
            containerView.next.addSubview(contentView.next)
        }
    }
    
    func fixPreContent() {
        guard let dynamicPreIndex = contentIndex.dynamicPre else {
            return
        }
        
        if contentIndex.pre == nil || contentIndex.pre?.isEqual(dynamicPreIndex) == false {
            contentIndex.pre = dynamicPreIndex
            contentView.pre.removeFromSuperview()
            
            contentView.pre = datasource.flipView(flipView: self, pageViewWithIndex: contentIndex.pre) ?? UIView.init()
            containerView.pre.addSubview(contentView.pre)
        }
    }
    
    func handlerTapGesture(tapGesture: UITapGestureRecognizer) {
        guard orientation == .LeftRight else {
            return
        }
        
        let translatPoint = tapGesture.location(in: self)
        
        self.isUserInteractionEnabled = false
        
        if basemapStatus == .none {
            hasBasemapView.current = contentView.basemap.current != nil
            hasBasemapView.pre = contentView.basemap.pre != nil
            
            contentView.basemap.current?.removeFromSuperview()
            contentView.basemap.pre?.removeFromSuperview()
        }
        contentIndex.dynamicPre = nil
        contentIndex.dynamicNext = nil
        
        var moveToPoint = CGPoint.init(x: -flipMinOffset - 10, y: -flipMinOffset - 10)
        if translatPoint.x < self.frame.size.width / 2.0 {
            moveToPoint = CGPoint.init(x: flipMinOffset + 10, y: flipMinOffset + 10)
        }
        
        // 判断是否有前后页，并做数据修正
        fixDynamicContent(moveToPoint)
        
        // 判断是否能移动，不能移动强制中断
        if canMove(moveToPoint) == false {
            // 中断
            tapGesture.isEnabled = false
            tapGesture.isEnabled = true
            
            self.isUserInteractionEnabled = true
            return
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.flipMove(moveToPoint)
            self.flipEnd(withTranslatPoint: moveToPoint)
        }) { (finish) in
            
        }
    }
    
    func handlerPanGesture(panGesture: UIPanGestureRecognizer) {
        let translatPoint = panGesture.translation(in: self)
        
        switch panGesture.state {
        case .began:
            beganPoint = translatPoint
            if basemapStatus == .none {
                hasBasemapView.current = contentView.basemap.current != nil
                hasBasemapView.pre = contentView.basemap.pre != nil
                
                contentView.basemap.current?.removeFromSuperview()
                contentView.basemap.pre?.removeFromSuperview()
            }
            
            contentIndex.dynamicPre = nil
            contentIndex.dynamicNext = nil
            
        case .changed:
            // 判断是否有前后页，并做数据修正
            fixDynamicContent(translatPoint)
            
            // 判断是否能移动，不能移动强制中断
            if canMove(translatPoint) == false {
                // 中断
                panGesture.isEnabled = false
                panGesture.isEnabled = true
                return
            }
            
            // 移动
            flipMove(translatPoint)
            
        case .ended:
            flipEnd(withTranslatPoint: translatPoint)
            
        default:
            flipToOriginal()
        }
    }
    
    // MARK: 滑动结束
    func flipEnd(withTranslatPoint translatPoint: CGPoint) {
        if orientation == .UpDown {
            if fabs(translatPoint.y) <= flipMinOffset {
                flipToOriginal()
            }else if translatPoint.y < 0 {
                flipToNextPage(o: .y)
            }else if translatPoint.y > 0 {
                flipToPrePage(o: .y)
            }
        }else {
            if fabs(translatPoint.x) <= flipMinOffset {
                flipToOriginal()
            }else if translatPoint.x < 0 {
                flipToNextPage(o: .x)
            }else if translatPoint.x > 0 {
                flipToPrePage(o: .x)
            }
        }
    }
    
    // MARK: 修正下标和内容
    func fixDynamicContent(_ translatPoint: CGPoint) {
        var offset = translatPoint.y
        if orientation == .LeftRight {
            offset = translatPoint.x
        }
        
        // 判断是否有前后页，并做数据修正
        if offset < 0 {
            if contentIndex.dynamicNext == nil {
                contentIndex.dynamicNext = datasource.flipView(flipView: self, index: hCurrentIndex, offset: 1)
            }
            
            if contentIndex.dynamicNext != nil { // 修正index和下一页View
                fixNextContent()
            }
            
        }else if offset > 0 {
            if contentIndex.dynamicPre == nil {
                contentIndex.dynamicPre = datasource.flipView(flipView: self, index: hCurrentIndex, offset: -1)
            }
            
            if contentIndex.dynamicPre != nil { // 修正index和下一页View
                fixPreContent()
            }
            
        }else {}
    }
    
    // MARK: 判断是否能移动，不能移动强制中断
    func canMove(_ translatPoint: CGPoint) -> Bool {
        var offset = translatPoint.y
        if orientation == .LeftRight {
            offset = translatPoint.x
        }
        
        if self.basemapStatus == .none {
            if offset < 0 {
                if hasBasemapView.current {
                }else {
                    if contentIndex.next == nil {
                        return false
                    }
                }
            }else if offset > 0 {
                if hasBasemapView.pre {
                }else {
                    if contentIndex.pre == nil {
                        return false
                    }
                }
            }
        }else if self.basemapStatus == .up {
            if offset < 0 {
                if contentIndex.next == nil {
                    
                    return false
                }
            }
        }else {
            if offset > 0 {
                if contentIndex.pre == nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    // MARK: 移动
    func flipMove(_ translatPoint: CGPoint) {
        var offset = translatPoint.y
        var transformX = CGFloat(0.0)
        var transformY = translatPoint.y
        if orientation == .LeftRight {
            offset = translatPoint.x
            transformX = translatPoint.x
            transformY = CGFloat(0.0)
        }
        
        // 移动
        if self.basemapStatus == .none {
            if offset < 0 { // 手指往上滑，向下翻页，若有basemap，则显示当前basemap
                if hasBasemapView.current {
                    if contentView.basemap.current!.superview == nil {
                        contentView.basemap.pre?.removeFromSuperview()
                        insertSubview(contentView.basemap.current!, at: 0)
                        bringSubview(toFront: containerView.current)
                    }else {} // 不做处理
                    
                    containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
                }else {
                    containerView.pre.transform = CGAffineTransform(translationX: transformX, y: transformY)
                    containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
                    containerView.next.transform = CGAffineTransform(translationX: transformX, y: transformY)
                }
            }else if offset > 0 {
                if hasBasemapView.pre {
                    if contentView.basemap.pre!.superview == nil {
                        contentView.basemap.current?.removeFromSuperview()
                        insertSubview(contentView.basemap.pre!, at: 0)
                        bringSubview(toFront: containerView.current)
                    }else {} // 不做处理
                    
                    containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
                }else {
                    containerView.pre.transform = CGAffineTransform(translationX: transformX, y: transformY)
                    containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
                    containerView.next.transform = CGAffineTransform(translationX: transformX, y: transformY)
                }
            }
        }else {
            containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
            containerView.next.transform = CGAffineTransform(translationX: transformX, y: transformY)
        }
    }
    
    // MARK: 恢复原始坐标
    func flipToOriginal() {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            self.containerView.pre.transform = .identity
            self.containerView.current.transform = .identity
            self.containerView.next.transform = .identity
        }, completion: { (completion) in
            self.isUserInteractionEnabled = true
        })
    }
    
    // MARK: 翻到上一页
    func flipToPrePage(o: GestureOrientation.Pre) {
        var transformX = CGFloat(0.0)
        var transformY = frame.size.height
        if o == .x {
            transformX = frame.size.width
            transformY = CGFloat(0.0)
        }
        
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            if self.basemapStatus == .none {
                if self.hasBasemapView.pre == false && self.hasBasemapView.current == true {
                    self.containerView.pre.transform = CGAffineTransform(translationX: transformX, y: transformY)
                    self.containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
                }else if self.hasBasemapView.current || self.hasBasemapView.pre {
                    self.containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
                }else {
                    self.containerView.pre.transform = CGAffineTransform(translationX: transformX, y: transformY)
                    self.containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
                    self.containerView.next.transform = CGAffineTransform(translationX: transformX, y: transformY)
                }
            }else if self.basemapStatus == .up {
                self.containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
            }else {
                self.containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
            }
        }, completion: { (completion) in
            if self.basemapStatus == .none {
                if self.hasBasemapView.pre && !self.hasBasemapView.current {
                    self.basemapStatus = .down
                    self.swapCurrentToPre()
                }else if !self.hasBasemapView.pre && self.hasBasemapView.current {
                    self.swapCurrentToPre()
                    self.loadPreContentView()
                } else if self.hasBasemapView.current {
                    self.basemapStatus = .down
                    self.swapCurrentToPre()
                }else {
                    self.swapCurrentToPre()
                    self.loadPreContentView()
                }
            }else if self.basemapStatus == .up {
                self.basemapStatus = .none
            }else if self.basemapStatus == .down {
                self.loadPreContentView()
                self.basemapStatus = .none
            }else {}
            
            self.layoutContainerViews()
            self.isUserInteractionEnabled = true
        })
    }
    // MARK: 翻到下一页
    func flipToNextPage(o: GestureOrientation.Next) {
        var transformX = CGFloat(0.0)
        var transformY = -frame.size.height
        if o == .x {
            transformX = -frame.size.width
            transformY = CGFloat(0.0)
        }
        
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            if self.basemapStatus == .none {
                if self.hasBasemapView.current {
                    self.containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
                }else {
                    self.containerView.pre.transform = CGAffineTransform(translationX: transformX, y: transformY)
                    self.containerView.current.transform = CGAffineTransform(translationX: transformX, y: transformY)
                    self.containerView.next.transform = CGAffineTransform(translationX: transformX, y: transformY)
                }
            }else if self.basemapStatus == .up {
                self.containerView.next.transform = CGAffineTransform(translationX: transformX, y: transformY)
            }else if self.basemapStatus == .down {
                self.containerView.next.transform = CGAffineTransform(translationX: transformX, y: transformY)
            }
        }, completion: { (completion) in
            if self.basemapStatus == .none {
                if self.hasBasemapView.current {
                    self.basemapStatus = .up
                }else {
                    self.swapCurrentToNext()
                    self.loadNextContentView()
                }
            }else if self.basemapStatus == .up {
                self.swapCurrentToNext()
                self.loadNextContentView()
                self.basemapStatus = .none
            }else if self.basemapStatus == .down {
                self.swapCurrentToNext()
                self.basemapStatus = .none
            }else {}
            
            self.layoutContainerViews()
            self.isUserInteractionEnabled = true
        })
    }
}
