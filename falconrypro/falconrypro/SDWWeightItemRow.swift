//
//  SDWWeightItemRow.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/24/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Eureka

final class SDWWeightItemRow: SelectorRow<PushSelectorCell<DiaryWeightItemDisplayItem>, SDWWeightItemViewController>, RowType {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .show(controllerProvider: ControllerProvider.callback {
            
            return SDWWeightItemViewController(){ _ in
                
            } }, onDismiss: { vc in _ = vc.navigationController?.popViewController(animated: true) })
        
        
    }
}
