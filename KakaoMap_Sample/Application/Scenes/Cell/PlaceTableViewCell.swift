//
//  PlaceTableViewCell.swift
//  KakaoMap_Sample
//
//  Created by JHH on 28/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import UIKit

final class PlaceTableViewCell: UITableViewCell {
    
    // MARK: UI Components
    
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    private let roadAddressNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 8)
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView  = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment    = .leading
        stackView.spacing      = 5
        return stackView
    }()
    
    
    // MARK: Constructor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(self.labelStackView)
        self.labelStackView.addArrangedSubview(self.placeNameLabel)
        self.labelStackView.addArrangedSubview(self.roadAddressNameLabel)
        
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PlaceItemViewModel){
        self.placeNameLabel.text = viewModel.placeName
        self.roadAddressNameLabel.text = viewModel.roadAddressName
    }
}

// MARK: - Layout

extension PlaceTableViewCell{
    private func layout(){
        self.labelStackView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }
}
