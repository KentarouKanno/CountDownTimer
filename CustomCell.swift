//
//  CustomCell.swift
//  Timer
//
//  Created by Kentarou on 2018/11/09.
//  Copyright © 2018 Kentarou. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var listData: ListData? {
        didSet {
            update()
        }
    }
    
    func update() {
        guard var listData = listData else { return }
        titleLabel.text = listData.titleText()
        timerLabel.text = listData.update()
        baseView.backgroundColor = listData.backColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 50, weight: .regular)
        
    }
}
