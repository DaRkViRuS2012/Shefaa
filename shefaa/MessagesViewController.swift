//
//  MessagesViewController.swift
//  shefaa
//
//  Created by Nour  on 8/10/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Alamofire
class MessagesViewController: UITableViewController{

   
    let cellid = "MessageCell"
    
    var messages:[Message] = []
    let refresh = UIRefreshControl()
    let progressHUD = ProgressHUD(text: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image?.withRenderingMode(.alwaysOriginal)
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationItem.titleLabel.textColor = .white
        refresh.tintColor = .blue
        refresh.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: .valueChanged)
        tableView.addSubview(refresh)
        self.navigationItem.titleLabel.textColor = .white
        self.title = NSLocalizedString("Messages", comment: "")
        
        self.tableView.addSubview(progressHUD)
        
        //  _ = progressHUD.anchor(tableView.topAnchor, left: tableView.leadingAnchor, bottom: tableView.bottomAnchor, right: tableView.trailingAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        progressHUD.frame = tableView.frame
        progressHUD.hide()

        prepateTaleView()
        loadData()
        prepareViewState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        self.loadData()
        refreshControl.endRefreshing()
    }
    
        
        func loadData(){
            
            progressHUD.show()
            guard let user =  Globals.user else{
                return
            }
            
            let uid = (user.user?.uid!)!
            print (uid)
            

            let url = Globals.baseUrl + "/load-pm?recipient_id=\(uid)&sess_name=\(user.session_name!)&sess_id=\(user.sessid!)&token=\(user.token!)&language=en".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            print(url)
            
            Alamofire.request(url).responseJSON { response in
                print(response.response)
                self.progressHUD.hide()
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let res = Message.modelsFromDictionaryArray(array: JSON as! NSArray)
                    self.messages = res
                    
                    
                    if self.messages.count == 0{
                        self.empty()
                    }
                    self.MessagesOrder()
                    
                    self.tableView.reloadData()
                }else{
                    self.error()
                }
            }
            
            
        }

    func MessagesOrder(){
        self.messages.sort { (first, second) -> Bool in
            first.timestamp! > second.timestamp!
        }
    
    }
    
    func prepateTaleView(){
       
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: cellid , bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.viewController(identifier: "MessageViewController" ) as! MessageViewController
        vc.msg = messages[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    var lodingView:LoadingView = {
        let v = LoadingView()
        return v
    }()
    
    var emptyView:EmptyView = {
        let v = EmptyView()
        return v
    }()
    
    var wrongView:ErrorView = {
        let v = ErrorView()
        return v
    }()
    
    
    func prepareViewState(){
        view.addSubview(lodingView)
        view.addSubview(wrongView)
        view.addSubview(emptyView)
        lodingView.frame  = CGRect(x: UIScreen.main.bounds.minX, y: UIScreen.main.bounds.minY, width: self.view.frame.width, height: self.view.frame.height )
        wrongView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        emptyView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        emptyView.tapGestureRecognizer.addTarget(self, action: #selector(loadData))
        wrongView.tapGestureRecognizer.addTarget(self, action: #selector(loadData))
        initilze()
    }
    
    func initilze(){
        
        lodingView.isHidden = true
        wrongView.isHidden = true
        emptyView.isHidden = true
    }
    
    func loding(){
        lodingView.isHidden = false
        wrongView.isHidden = true
        emptyView.isHidden = true
    }
    
    func error(){
        lodingView.isHidden = true
        wrongView.isHidden = false
        emptyView.isHidden = true
    }
    func empty(){
        
        lodingView.isHidden = true
        wrongView.isHidden = true
        emptyView.isHidden = false
    }
    
    
    
    

    
}
