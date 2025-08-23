import UIKit
import React
import React_RCTAppDelegate

class RNPriceListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Implement React Native view controller
        // 1. set up embedded RN component (MODULE NAME : CDC_Interview)
        let factory = (RCTSharedApplication()?.delegate as? RCTAppDelegate)?.rootViewFactory
        self.view = factory?.view(withModuleName: "CDC_Interview")
    }
}
