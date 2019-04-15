//
//  ViewController.swift
//  DragBetweenCollectionView
//
//  Created by Daniel Hjärtström on 2019-04-09.
//  Copyright © 2019 Sog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var items: [AnimalObject] = {
        return [
            AnimalObject(text: "Dog"),
            AnimalObject(text: "Cat"),
            AnimalObject(text: "Elaphant"),
            AnimalObject(text: "Giraffe"),
            AnimalObject(text: "Mouse"),
            AnimalObject(text: "Rat")
        ]
    }()
    
    var insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    

    private lazy var collectionView: CollectionContainer = { () -> CollectionContainer<AnimalCollectionViewCell, AnimalObject> in
        let temp = CollectionContainer<AnimalCollectionViewCell, AnimalObject>()
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50.0).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        return temp
    }()
    
    private lazy var collectionView2: CollectionContainer = { () -> CollectionContainer<AnimalCollectionViewCell, AnimalObject> in
        let temp = CollectionContainer<AnimalCollectionViewCell, AnimalObject>()
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 205.0).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        return temp
    }()
    
    private lazy var collectionView3: CollectionContainer = { () -> CollectionContainer<AnimalCollectionViewCell, AnimalObject> in
        let temp = CollectionContainer<AnimalCollectionViewCell, AnimalObject>()
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 355.0).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.items = items
        collectionView2.isHidden = false
        collectionView3.isHidden = false
    }

}

extension NSObject {
    func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

class CollectionContainer<C: BaseCollectionViewCell<T>, T>: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private class CurrentView {
        var view: UIView?
        var originFrame: CGRect?
        var indexPath: IndexPath?
    }
    
    private var current: CurrentView = CurrentView()

    var items: [T] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let temp = UICollectionViewFlowLayout()
        temp.scrollDirection = .horizontal
        temp.minimumLineSpacing = 5
        temp.minimumInteritemSpacing = 5
        return temp
    }()
    
    private lazy var collectionView: UICollectionView = {
        let temp = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        temp.backgroundColor = UIColor.white
        temp.allowsMultipleSelection = false
        temp.dataSource = self
        temp.isPagingEnabled = false
        temp.delegate = self
        temp.layer.borderColor = UIColor.black.cgColor
        temp.layer.borderWidth = 1.0
        temp.contentInsetAdjustmentBehavior = .never
        temp.isPagingEnabled = true
        temp.showsHorizontalScrollIndicator = false
        temp.register(C.self, forCellWithReuseIdentifier: "cell")
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let temp = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        temp.minimumNumberOfTouches = 2
        temp.maximumNumberOfTouches = 2
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureFrames()
    }
    
    private func configureFrames() { }
    
    private func commonInit() {
        backgroundColor = UIColor.black
        collectionView.addGestureRecognizer(panRecognizer)
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let superView = collectionView.superview else { return }
        let translation = sender.translation(in: superView)
        var cell: UICollectionViewCell?
        
        switch sender.state {
        case .began:
            let point = sender.location(in: collectionView)
            guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
            guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
            cell = collectionView.cellForItem(at: indexPath)
            guard let cell = cell else { return }
            vibrate(.heavy)
            
            let cellRect: CGRect = attributes.frame
            let cellFrameInSuperview = collectionView.convert(cellRect, to: collectionView.superview)
            let snapshot = collectionView.resizableSnapshotView(from: cell.frame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
            
            current.view = snapshot
            current.indexPath = indexPath
            current.originFrame = cellFrameInSuperview
            
            guard let currentView = current.view, let frame = current.originFrame else { return }
            
            superView.addSubview(currentView)
            currentView.frame = frame
            superview?.bringSubviewToFront(self)
            currentView.superview?.bringSubviewToFront(currentView)
            cell.alpha = 0
            
        case .changed:
            
            moveViewWithPan(sender: sender, translation: translation)
        
        case .ended:
            cell?.alpha = 1
            guard let currentView = current.view, let originFrame = current.originFrame, let index = current.indexPath else { return }
            let point = sender.location(in: superview)
            
            var parent: UICollectionView?
            if let collectionView = superview?.hitTest(point, with: nil) as? UICollectionView {
                parent = collectionView
            } else if let collectionView = superview?.hitTest(point, with: nil)?.superview?.superview as? UICollectionView {
                parent = collectionView
            }
            
            guard let container = parent?.superview as? CollectionContainer else {
                UIView.animate(withDuration: 0.5, animations: {
                    currentView.frame = originFrame
                }) { [weak self] completed in
                    currentView.removeFromSuperview()
                    self?.resetCurrentView()
                    self?.collectionView.reloadData()
                }
                return
            }
            
            container.items.append(items[index.row])
            currentView.removeFromSuperview()
            resetCurrentView()
            
            items.remove(at: index.row)
            collectionView.reloadData()
            
            if self != container {

            } else {
   
            }
            
        default:
            break
        }
    }
    
    private func resetCurrentView() {
        current.originFrame = nil
        current.view = nil
        current.indexPath = nil
    }
    
    func moveViewWithPan(sender: UIPanGestureRecognizer, translation: CGPoint) {
        guard let current = current.view else { return }
        current.center = CGPoint(x: current.center.x + translation.x, y: current.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: collectionView.superview!)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AnimalCollectionViewCell else { return UICollectionViewCell() }
        if var object = items[indexPath.row] as? AnimalObject {
            object.index = indexPath.row
            cell.setupWithObject(object)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height - insets.bottom * 2, height: collectionView.frame.height - insets.bottom * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
    
}
