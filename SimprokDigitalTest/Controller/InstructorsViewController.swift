//
//  ViewController.swift
//  SimprokDigitalTest
//
//  Created by md760 on 7/14/19.
//  Copyright © 2019 md760. All rights reserved.
//


import UIKit
import SVProgressHUD

final class InstructorsViewController: UIViewController {
    
    //Outlets
    @IBOutlet private weak var schoolButton: UIButton!
    @IBOutlet private weak var instructorButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //Properties
    private let cellId = "cellId"
    private var sinceCount: Int = ConstValue.paginationNumber
    private var instructorsArray = [InstructorsModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchRequest(firstPage: ConstValue.startNumber, lastPage: sinceCount)
    }
    
    //Change statusBar color
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private func fetchRequest(firstPage: Int, lastPage: Int) {
        SVProgressHUD.show()
    
        InstructorsModel.fetchRequest(firstPage: ConstValue.startNumber, lastPage: sinceCount) { [weak self] (data, error) in
            guard let data = data,
                let `self` = self else { return }
            self.instructorsArray += data
            self.sinceCount += ConstValue.paginationNumber
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK: setupView
    private func setupView() {
        self.collectionView.register(UINib(nibName: "InstructorsCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        
        //circle image
        let cornerRadius = schoolButton.frame.width / 2
        schoolButton.layer.cornerRadius = cornerRadius
        instructorButton.layer.cornerRadius = cornerRadius
    }
    
}

//MARK: CollectionViewDelegateFlowLayout
extension InstructorsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = ConstValue.halfScreen
        if collectionView.frame.width < cellWidth * ConstValue.cellsInLine + ConstValue.cellsInsert {
            return CGSize(width: collectionView.frame.width - ConstValue.cellsInsert, height: ConstValue.cellHeight)
        }
        return CGSize(width: collectionView.frame.width / ConstValue.cellsInLine - ConstValue.cellsInsert, height: ConstValue.cellHeight)
    }
}

//MARK: CollectionViewDelegate
extension InstructorsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == instructorsArray.count - 1 {
            updateNextSet()
        }
    }
    
    func updateNextSet() {
        fetchRequest(firstPage: sinceCount, lastPage: sinceCount + ConstValue.paginationNumber)
    }
}

//MARK: ColletionViewDataSource
extension InstructorsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instructorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InstructorsCell
        cell.model = instructorsArray[indexPath.item]
        return cell
    }
}
