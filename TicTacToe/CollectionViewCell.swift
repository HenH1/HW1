//
//  CollectionViewCell.swift
//  TicTacToe
//
//  Created by admin on 3/4/16.
//  Copyright © 2016 Barak. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell{
    private(set) var isCellSelected = false
    private(set) var lastMove = ""
    
    @IBOutlet weak var cellLabel: UILabel!
    
    func selectCell(card: String) ->Bool{
        
        guard !isCellSelected else { return false }
        
        cellLabel.text = card

        if(lastMove == "")
        {
            lastMove = card
            isCellSelected = false
            
        }
        else if( lastMove == card)
        {
            isCellSelected = true
            lastMove = ""

        }

        return isCellSelected
    }
    
}
