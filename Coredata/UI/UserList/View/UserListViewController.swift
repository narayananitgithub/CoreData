//
//  UserListViewController.swift
//  Coredata
//
//  Created by Narayanasamy on 13/08/23.
//

import UIKit

class UserListViewController: UIViewController {
    
    
    @IBOutlet weak var dataTableView: UITableView!
    
    private var users: [UserEntity] = []
    private let manager = DatabaseManger()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataTableView.register(UINib(nibName: "Usercell", bundle: nil), forCellReuseIdentifier: "Usercell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = manager.fetchUser()
        dataTableView.reloadData()
        
    }
    
    @IBAction func OnClickAddUserBtnTapped(_ sender: Any) {
        addUpdateUserNavigation()
    
    }
    
    func addUpdateUserNavigation(user: UserEntity? = nil){
        
        guard let registerVc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController else { return }
           registerVc.user = user
         
        navigationController?.pushViewController(registerVc, animated: true)
        }
        
    }
    
extension  UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Usercell") as? Usercell else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
}
extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let update = UIContextualAction(style: .normal, title: "Update") { _, _, _ in
            self.manager.deleteuser(userEntity: self.users[indexPath.row])
        }
        update.backgroundColor = .systemIndigo
        
        let delete = UIContextualAction(style: .normal, title: "") { _, _, _ in
            self.manager.deleteuser(userEntity: self.users[indexPath.row]) // Coredata
            self.users.remove(at: indexPath.row) // Array
            self.dataTableView.reloadData()
            
        }
        return UISwipeActionsConfiguration(actions: [delete,update])
    }
}
