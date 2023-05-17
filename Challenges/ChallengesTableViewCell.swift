//
//  ChallengesTableViewCell.swift
//  IF project
//
//  Created by Misha on 22.01.2023.
//

import UIKit
import DeviceKit

struct ChallengesTableViewCellViewModel {
    var viewModels: [ChallengesCollectionViewCellViewModel]
}

class ChallengesTableViewCell: UITableViewCell {
    
    static let identifier = "ChallengesTableViewCell"
    
    var viewModels: [ChallengesCollectionViewCellViewModel] = []
    
    weak var delegate: ChallengesTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        if Device.current.isOneOf(K().smallDevices) {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 21
        } else {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 21
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChallengesCollectionViewCell.self,
                                forCellWithReuseIdentifier: ChallengesCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    func configure(with viewModel: ChallengesTableViewCellViewModel) {
        self.viewModels = viewModel.viewModels
        collectionView.reloadData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        delegate?.pageChanged(newPage: currentPage)
    }
    
}

//MARK: - Protocols

protocol ChallengesTableViewCellDelegate: AnyObject {
    func itemWasTapped(with viewModel: ChallengesCollectionViewCellViewModel)
    func pageChanged(newPage: Int)
    func challengeStateChanged(with ID: Int)
}

//MARK: - Extensions

extension ChallengesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = contentView.frame.size.width / 2.28
        let height = contentView.frame.size.height / 1.08
        
        return CGSize(width: width, height: height)
    }
}

extension ChallengesTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let viewModel = viewModels[indexPath.row]
        
        delegate?.itemWasTapped(with: viewModel)
    }
}

extension ChallengesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengesCollectionViewCell.identifier, for: indexPath) as? ChallengesCollectionViewCell else {fatalError("Can't downcast collectionView cell as ChallengesCollectionViewCell, should not happen")}
        
        cell.configure(with: viewModels[indexPath.row])
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
}
