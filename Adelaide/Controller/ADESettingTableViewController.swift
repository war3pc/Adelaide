//
//  ADESettingTableViewController.swift
//  Adelaide
//
//  Created by Charles on 2020/11/13.
//

import UIKit

class ADESettingTableViewController: UITableViewController {

    let kSuccessTitle = "Congratulations"
    let kNoticeTitle = "Notice"
    let kWarningTitle = "You've send interested for once"
    let kSubtitle = "You've send interested success"
    let kHasSendInterested = "HasSendInterested";
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let b = UserDefaults.standard.bool(forKey: kHasSendInterested)
            if !b {
                LoadingIndicatorView.show()
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(doWork), userInfo: nil, repeats: false)
            } else {
                doWarning()

            }
        } else {
            SCLAlertView().showInfo("About", subTitle: "Data for this assignment was taken from:\"Adelaide Fringe Must-See Events in 2020\", SouthAustralia.com. Retreived 20/09/2020.\"Our Top Picks For Adelaide Fringe\", Glam Adelaide. Retreived 20/09/2020.Keen, Suzie (12/2/2019) \"Adelaide Fringe picks: 10 top new shows in 2019\", InDaily. Retreived 20/09/2020.\"About Fringe\", Adelaide Fringe. Retreived 20/09/2020.Last modified: Monday, 28 September 2020, 10:11 AM")
        }

    }
    
    @objc func doWork() {
        // dismiss the loading indicator view once work is done
        LoadingIndicatorView.hide()
        let alert = SCLAlertView()
        _ = alert.showSuccess(kSuccessTitle, subTitle: kSubtitle)
         UserDefaults.standard.set(true, forKey: kHasSendInterested)
        UserDefaults.standard.synchronize()
    }
    
    func doWarning() {
        // dismiss the loading indicator view once work is done
        _ = SCLAlertView().showWarning(kNoticeTitle, subTitle: kWarningTitle)

    }
}
