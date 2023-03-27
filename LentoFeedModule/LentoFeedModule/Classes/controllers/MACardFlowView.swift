//
//  PKCardFlowView.swift
//  Lento
//
//  Created by zhang on 2023/2/15.
//

import UIKit
import LentoBaseKit






class MACardFlowItem: NSObject {
    
}

public class MACardFlowView: LentoBaseView {
    
    public override func commonInitialization() {
        
    }
    
    public override func layoutInitialization() {
        
    }
    
    private func dataUpdates() {
        
    }
}

extension MACardFlowView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MACardFlowView: UITableViewDelegate {
    
//    OneKey
//    OneKey
//    TwoKey
//
//    Primary and secondary
}
