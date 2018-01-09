//
//  ListAlert.swift
//
//  Created by El Mehdi KHALLOUKI on 1/12/17.
//  Copyright © 2017 El Mehdi KHALLOUKI. All rights reserved.
//

import UIKit

class AConstants: NSObject {

    static let ColorRed: UIColor = UIColor(red: 227.0/255, green: 9.0/255, blue: 16.0/255, alpha: 1)
    static let FontTitle: UIFont = UIFont(name: "Poppins-SemiBold", size: 13) ?? UIFont.systemFont(ofSize: 13)

}

public enum MKListMode: UInt {
    case singleChoice
    case multiChoice
}

public class MKListAlert: UIView {

    // MARK: UIComponents
    var coverView: UIButton?
    var containerView: UIView?
    var tableView: UITableView?

//    var btnCancel: UIButton?
//    var btnDone: UIButton?
    var tableTitle: UILabel?

    public var selectedIndexes: [Int] = []
    public var listContent: [Any?] = []

    // MARK: Config
    public var mkBackgroundColor: UIColor = UIColor.white
    public var mkSubviewMarginTop: CGFloat = 60
    public var mkSubviewMarginBottom: CGFloat = 60
    public var mkSubviewMarginLeft: CGFloat = 20
    public var mkSubviewMarginRight: CGFloat = 20
    public var isSmall: Bool = false
    public var mkDismissWhenClickingOutside: Bool = true
    public var mkListMode: MKListMode = .singleChoice
    public var mkShowDuration: TimeInterval = 0.3
    public var mkHideDuration: TimeInterval = 0.3
    public var mkButtonsHeight: CGFloat = 60
//    var mkButtonsTextColor: UIColor = Constants.ColorRed
//    var mkButtonsFont: UIFont = Constants.FontTitle!
    public var mkTitle: String = ""
    public var mkTitleTextColor: UIColor = AConstants.ColorRed
    public var mkTitleFont: UIFont = AConstants.FontTitle
    public var subviewRadiosCorner: CGFloat = 10

//    var mkButtonsCancelTitle: String = "ACancel".localized
//    var mkButtonsDoneTitle: String = "AOK".localized
    public var mkCancelClosure: ((MKListAlert) -> (Void))?
    public var mkOKClosure: ((MKListAlert, [Int]) -> (Void))?
    public var mkListFont: UIFont = UIFont.systemFont(ofSize: 15)

    public var mkTitleForRow: ((MKListAlert, Int, [Any?]) -> String)?

    var tableHeightConstraint: NSLayoutConstraint?

    public class func alert(title: String, listToShow: [Any?]) -> MKListAlert {
        let alert = MKListAlert()
        alert.listContent = listToShow
        alert.mkTitle = title
        return alert
    }

    init() {
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func getBundle() -> Bundle? {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "FlyAlert", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                return bundle
            }
        }
        return nil
    }

    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false

        coverView = UIButton()
        coverView!.translatesAutoresizingMaskIntoConstraints = false
        coverView!.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        coverView!.addTarget(self, action: #selector(self.didClickOutside(sender:)), for: .touchUpInside)
        self.addSubview(coverView!)

        containerView = UIView()
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        containerView!.backgroundColor = mkBackgroundColor
        containerView!.clipsToBounds = true
        containerView!.layer.cornerRadius = subviewRadiosCorner
        self.addSubview(containerView!)

        self.layoutIfNeeded()
        tableView = UITableView()
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: "MKTableViewCell", bundle: getBundle()), forCellReuseIdentifier: "MKTableViewCell")
//        tableView?.register(UINib(nibName: "MKSectionView", bundle: getBundle()), forHeaderFooterViewReuseIdentifier: "MKSectionView")
        tableView?.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView?.estimatedSectionHeaderHeight = 25
        tableView?.tableFooterView = UIView()
        tableView?.separatorInset = .zero
        tableView?.layoutMargins = .zero
        tableView?.separatorStyle = .none
        containerView!.addSubview(tableView!)

//        btnCancel = UIButton()
//        btnCancel?.translatesAutoresizingMaskIntoConstraints = false
//        btnCancel?.setTitle(mkButtonsCancelTitle, for: .normal)
//        btnCancel?.setTitleColor(mkButtonsTextColor, for: .normal)
//        btnCancel?.titleLabel?.font = mkButtonsFont
//        btnCancel?.addTarget(self, action: #selector(self.didCancel(sender:)), for: .touchUpInside)
//        containerView!.addSubview(btnCancel!)

//        btnDone = UIButton()
//        btnDone?.translatesAutoresizingMaskIntoConstraints = false
//        btnDone?.setTitle(mkButtonsDoneTitle, for: .normal)
//        btnDone?.setTitleColor(mkButtonsTextColor, for: .normal)
//        btnDone?.titleLabel?.font = mkButtonsFont
//        btnDone?.addTarget(self, action: #selector(self.didFinish(sender:)), for: .touchUpInside)
//        containerView!.addSubview(btnDone!)

        tableTitle = UILabel()
        tableTitle?.translatesAutoresizingMaskIntoConstraints = false
        //Here
        tableTitle?.text = mkTitle
        tableTitle?.textColor = UIColor.black
        tableTitle?.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        tableTitle?.font = mkTitleFont
        tableTitle?.textAlignment = .center
        containerView!.addSubview(tableTitle!)

        self.addConstraint(NSLayoutConstraint(item: coverView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: coverView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: coverView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: coverView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))

        if isSmall {
            self.addConstraint(NSLayoutConstraint(item: containerView!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.25, constant: 0))
        } else {
            self.addConstraint(NSLayoutConstraint(item: containerView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: mkSubviewMarginLeft))
            self.addConstraint(NSLayoutConstraint(item: containerView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -mkSubviewMarginRight))
        }
//        self.addConstraint(NSLayoutConstraint(item: containerView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .top, multiplier: 1, constant: mkSubviewMarginTop))
        self.addConstraint(NSLayoutConstraint(item: containerView!, attribute: .height, relatedBy: .equal, toItem: coverView!, attribute: .height, multiplier: 0.5, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: containerView!, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self, attribute: .bottom, multiplier: 1, constant: -mkSubviewMarginBottom))
        self.addConstraint(NSLayoutConstraint(item: containerView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
//        self.addConstraint(NSLayoutConstraint(item: containerView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

        // NOTE: - Title Constraints
        containerView!.addConstraint(NSLayoutConstraint(item: tableTitle!, attribute: .top, relatedBy: .equal, toItem: containerView!, attribute: .top, multiplier:  1, constant: 0))
        containerView!.addConstraint(NSLayoutConstraint(item: tableTitle!, attribute: .trailing, relatedBy: .equal, toItem: containerView!, attribute: .trailing, multiplier:  1, constant: 0))
        containerView!.addConstraint(NSLayoutConstraint(item: tableTitle!, attribute: .leading, relatedBy: .equal, toItem: containerView!, attribute: .leading, multiplier:  1, constant: 0))
        containerView!.addConstraint(NSLayoutConstraint(item: tableTitle!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier:  1, constant: mkButtonsHeight))

        // NOTE: - TableView Constraints
        containerView!.addConstraint(NSLayoutConstraint(item: tableView!, attribute: .leading, relatedBy: .equal, toItem: containerView!, attribute: .leading, multiplier: 1, constant: 0))
        containerView!.addConstraint(NSLayoutConstraint(item: tableView!, attribute: .top, relatedBy: .equal, toItem: tableTitle!, attribute: .bottom, multiplier: 1, constant: 0))
        containerView!.addConstraint(NSLayoutConstraint(item: tableView!, attribute: .trailing, relatedBy: .equal, toItem: containerView!, attribute: .trailing, multiplier: 1, constant: 0))
//        containerView!.addConstraint(NSLayoutConstraint(item: tableView!, attribute: .bottom, relatedBy: .equal, toItem: containerView!, attribute: .bottom, multiplier: 1, constant: -mkButtonsHeight))
        containerView!.addConstraint(NSLayoutConstraint(item: tableView!, attribute: .bottom, relatedBy: .equal, toItem: containerView!, attribute: .bottom, multiplier: 1, constant: 0))
//        tableHeightConstraint = NSLayoutConstraint(item: tableView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
//        containerView!.addConstraint(tableHeightConstraint!)

        // NOTE: - btnCancel and btnDone Constraints
//        containerView!.addConstraint(NSLayoutConstraint(item: btnCancel!, attribute: .leading, relatedBy: .equal, toItem: containerView!, attribute: .leading, multiplier: 1, constant: 0))
//        containerView!.addConstraint(NSLayoutConstraint(item: btnCancel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: mkButtonsHeight))
//        containerView!.addConstraint(NSLayoutConstraint(item: btnCancel!, attribute: .width, relatedBy: .equal, toItem: containerView!, attribute: .width, multiplier: 0.5, constant: 0))
//        containerView!.addConstraint(NSLayoutConstraint(item: btnCancel!, attribute: .bottom, relatedBy: .equal, toItem: containerView!, attribute: .bottom, multiplier: 1, constant: 0))
//
//        containerView!.addConstraint(NSLayoutConstraint(item: btnDone!, attribute: .trailing, relatedBy: .equal, toItem: containerView!, attribute: .trailing, multiplier: 1, constant: 0))
//        containerView!.addConstraint(NSLayoutConstraint(item: btnDone!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: mkButtonsHeight))
//        containerView!.addConstraint(NSLayoutConstraint(item: btnDone!, attribute: .width, relatedBy: .equal, toItem: containerView!, attribute: .width, multiplier: 0.5, constant: 0))
//        containerView!.addConstraint(NSLayoutConstraint(item: btnDone!, attribute: .bottom, relatedBy: .equal, toItem: containerView!, attribute: .bottom, multiplier: 1, constant: 0))

        self.layoutIfNeeded()
    }

    public override func layoutSubviews() {
        if let tableHeightCS = tableHeightConstraint {
            var tableHeight = tableView!.contentSize.height
            let condition = containerView!.frame.height - mkButtonsHeight
            if tableHeight > condition {
                tableHeight = condition
            }
            tableHeightCS.constant = tableHeight
        }

        super.layoutSubviews()
    }

    public func setOKClosure(_ closure: @escaping ((MKListAlert, [Int]) -> (Void))) {
        mkOKClosure = closure
    }

    public func setCancelClosure(_ closure: @escaping ((MKListAlert) -> (Void))) {
        mkCancelClosure = closure
    }

    public func show() {
        DispatchQueue.main.async {
            self.commonInit()

            self.alpha = 0.0
            let windows = UIApplication.shared.windows.filter { $0.windowLevel == UIWindowLevelNormal && !$0.isHidden }
            guard let window = windows.first else {
                return
            }
            window.addSubview(self)

            window.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1, constant: 0))
            window.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: window, attribute: .right, multiplier: 1, constant: 0))
            window.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: window, attribute: .left, multiplier: 1, constant: 0))
            window.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .bottom, multiplier: 1, constant: 0))

            window.layoutIfNeeded()
            window.layoutSubviews()

            self.backgroundColor = .clear
            UIView.animate(withDuration: self.mkShowDuration) {
                self.alpha = 1.0
            }

        }
    }

    @objc func didFinish(sender: UIButton) {
        if let okClosure = mkOKClosure {
            okClosure(self, selectedIndexes)
        }
        else {
            hide()
        }
    }

    @objc func didCancel(sender: UIButton) {
        if let cancelClosure = mkCancelClosure {
            cancelClosure(self)
        }
        else {
            hide()
        }
    }

    @objc func didClickOutside(sender: UIButton) {
        if mkDismissWhenClickingOutside {
            hide()
        }
    }

    public func hide() {
        UIView.animate(withDuration: mkHideDuration, animations: {
            self.alpha = 0.0
        }) { finished in
            if finished {
                self.removeFromSuperview()
            }
        }
    }

}

extension MKListAlert: UITableViewDelegate, UITableViewDataSource {

    // MARK : UITableView Delegate/Datasource
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mkListMode == .singleChoice {
            selectedIndexes = [indexPath.row]
        }
        else if mkListMode == .multiChoice {
            if selectedIndexes.contains(indexPath.row) {
                selectedIndexes = selectedIndexes.filter {
                    $0 != indexPath.row
                }
            }
            else {
                selectedIndexes += [indexPath.row]
            }
        }

        if let okClosure = mkOKClosure {
            okClosure(self, selectedIndexes)
        }
        else {
            hide()
        }
        
        tableView.reloadData()
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listContent.count
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "MKTableViewCell")
        if let cell = c as? MKTableViewCell {
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.preservesSuperviewLayoutMargins = false
            cell.backgroundColor = .white

//            cell.bemCheck.isUserInteractionEnabled = false
            if let titleForRow = mkTitleForRow {
                cell.lblTitle.text = titleForRow(self, indexPath.row, listContent)
                cell.lblTitle.numberOfLines = 0
                cell.lblTitle.textColor = UIColor.black
                
                // NOTE : - Change the color and background color of selected item
                if selectedIndexes.contains(indexPath.row) {
                    cell.lblTitle.textColor = AConstants.ColorRed
                    cell.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:0.5)
                }
//                cell.bemCheck.setOn((selectedIndexes.contains(indexPath.row)), animated: false)
            }
            return cell
        }
        return c!
    }

}
