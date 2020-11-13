//
//  FingerRandomViewController.swift
//  AdelaideFringe
//
//  Created by kevin on 2020/11/1.
//

import UIKit

class ADEFingerRandomViewController: UIViewController {
    @IBOutlet weak var cardView: GXCardView!

    public var fingerList = [ADEFringer]()
    public weak var delegate: ADEFringerDetailDelegate?

    var cellCount: Int = 10

    private lazy var cardLayout: GXCardLayout = {
        let layout = GXCardLayout()
        layout.visibleCount = 4
        layout.maxAngle = 15.0
        layout.isRepeat = false
        layout.isPanAnimatedEnd = false //必须动画结束才可再次拖拽，为true时可不停的拖拽
        layout.maxRemoveDistance = self.view.frame.width/4
        
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.dataSource = self
        cardView.delegate = self
        cardView.setCardLayout(cardLayout: self.cardLayout)
        cardView.register(nibCellType: ADERandomCell.self)
        // Do any additional setup after loading the view.
        getDataSource()
    }
    

}


extension ADEFingerRandomViewController {
    fileprivate func getDataSource() {
        if let list = self.fingerList.sample(size: 5, noRepeat: true) {
            self.fingerList = list
            self.cardView.reloadData()

        }

    }

}


extension ADEFingerRandomViewController: GXCardCViewDataSource, GXCardCViewDelegate {
    // MARK: - GXCardViewDataSource
    func numberOfItems(in cardView: GXCardView) -> Int {
        return self.fingerList.count
    }
    func cardView(_ cardView: GXCardView, cellForItemAt indexPath: IndexPath) -> GXCardCell {
        let cell = cardView.dequeueReusableCell(for: indexPath, cellType: ADERandomCell.self)
        let finger = fingerList[indexPath.row]
        let url = URL(string: "http://www.partiklezoo.com/fringer/images/\(finger.image)")!
        cell.iconIView.kf.setImage(with: url)
        cell.leftLabel.text = "Dislikes(\(finger.dislikes))"
        cell.rightLabel.text = "Likes(\(finger.likes))"
        
        return cell
    }
    
    // MARK: - GXCardViewDelegate
    func cardView(_ cardView: GXCardView, didRemoveLast cell: GXCardCell, forItemAt index: Int, direction: GXCardCell.SwipeDirection) {
        print("didRemove forRowAtIndex = %d, direction = %d", index, direction.rawValue)
        if !cardView.cardLayout.isRepeat {
            cardView.reloadData()
            cardView.scrollToItem(at: 0, animated: false)
        }
    }
    func cardView(_ cardView: GXCardView, willRemove cell: GXCardCell, forItemAt index: Int, direction: GXCardCell.SwipeDirection) {
        print("willRemove forRowAtIndex = %d, direction = %d", index, direction.rawValue)
        if direction == .left {
            delegate?.clickDislike(fingerId: fingerList[index].id, complection: { (like, dislike) in
                let finger = self.fingerList[index];
                finger.likes = like
                finger.dislikes = dislike
                if let randomCell = cell as? ADERandomCell {
                    randomCell.leftLabel.text = "Dislikes(\(finger.dislikes))"
                    randomCell.rightLabel.text = "Likes(\(finger.likes))"
                }

            })
        } else if direction == .right {
            delegate?.clickLike(fingerId: fingerList[index].id, complection: { (like, dislike) in
                let finger = self.fingerList[index];
                finger.likes = like
                finger.dislikes = dislike
                if let randomCell = cell as? ADERandomCell {
                    randomCell.leftLabel.text = "Dislikes(\(finger.dislikes))"
                    randomCell.rightLabel.text = "Likes(\(finger.likes))"
                }
            })
        } else if direction == .top {
            delegate?.clickInsterested(fingerId: fingerList[index].id, name: fingerList[index].name)
        }
    }
    func cardView(_ cardView: GXCardView, didRemove cell: GXCardCell, forItemAt index: Int, direction: GXCardCell.SwipeDirection) {
        print("didRemove forRowAtIndex = %d, direction = %d", index, direction.rawValue)
        if !cardView.cardLayout.isRepeat && index == 9 {
            self.cellCount = 20
            cardView.reloadData()
        }
    }
    func cardView(_ cardView: GXCardView, didMove cell: GXCardCell, forItemAt index: Int, move point: CGPoint, direction: GXCardCell.SwipeDirection) {
        print("move point = %@,  direction = %ld", point.debugDescription, direction.rawValue)
    }
    func cardView(_ cardView: GXCardView, didDisplay cell: GXCardCell, forItemAt index: Int) {
        print("didDisplay forRowAtIndex = %d", index)
    }
    func cardView(_ cardView: GXCardView, didSelectItemAt index: Int) {
        print("didSelectItemAt index = %d", index)
    }
}


extension Array {
    /// 从数组中返回一个随机元素
    public var sample: Element? {
        //如果数组为空，则返回nil
        guard count > 0 else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
     
    /// 从数组中从返回指定个数的元素
    ///
    /// - Parameters:
    ///   - size: 希望返回的元素个数
    ///   - noRepeat: 返回的元素是否不可以重复（默认为false，可以重复）
    public func sample(size: Int, noRepeat: Bool = false) -> [Element]? {
        //如果数组为空，则返回nil
        guard !isEmpty else { return nil }
         
        var sampleElements: [Element] = []
         
        //返回的元素可以重复的情况
        if !noRepeat {
            for _ in 0..<size {
                sampleElements.append(sample!)
            }
        }
        //返回的元素不可以重复的情况
        else{
            //先复制一个新数组
            var copy = self.map { $0 }
            for _ in 0..<size {
                //当元素不能重复时，最多只能返回原数组个数的元素
                if copy.isEmpty { break }
                let randomIndex = Int(arc4random_uniform(UInt32(copy.count)))
                let element = copy[randomIndex]
                sampleElements.append(element)
                //每取出一个元素则将其从复制出来的新数组中移除
                copy.remove(at: randomIndex)
            }
        }
        
        return sampleElements
    }
}
