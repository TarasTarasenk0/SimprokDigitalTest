//
//  ViewController.swift
//  SimprokDigitalTest
//
//  Created by md760 on 7/14/19.
//  Copyright © 2019 md760. All rights reserved.
//

import UIKit
import SVProgressHUD

class InstructorsViewController: UIViewController {
    
   private let cellId = "cellId"
   private var sinceCount: Int = 20
   private var instructorsArray = [InstructorsModel]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchRequest(firstPage: 0, lastPage: sinceCount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private func fetchRequest(firstPage: Int, lastPage: Int) {
        
        SVProgressHUD.show()
        Singleton.shared.fetchRequest(urlString: "https://api.github.com/users?since=\(firstPage)&per_page=\(lastPage)") { [weak self] (data, error) in
            guard let data = data,
                let `self` = self else { return }
            
            self.instructorsArray += data
            self.collectionView.reloadData()
            self.sinceCount += 20
            SVProgressHUD.dismiss()
        }
    }
    
    private func setupView() {
        self.collectionView.register(UINib(nibName: "InstructorsCell", bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    
}

extension InstructorsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 165.0
        if collectionView.frame.width < cellWidth * 2.0 + 10 {
            return CGSize(width: collectionView.frame.width - 10, height: 200)
        }
        return CGSize(width: collectionView.frame.width / 2 - 10, height: 200)
    }
}

extension InstructorsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == instructorsArray.count - 1 {
            updateNextSet()
        }
    }
    
    func updateNextSet() {
        fetchRequest(firstPage: sinceCount, lastPage: sinceCount + 20)
    }
}

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
