//
//  FavoritesViewController2.swift
//  World
//
//  Created by Timmy Li on 2/12/20.
//  Copyright © 2020 Timmy Li. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBAction func closeButtonPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var closeButtonView: UIButton!
    @IBOutlet var favoritesTableView: UITableView!
    
    weak var delegate: PlacesFavoritesDelegate?
    var favoritePlaces = [String:Int]()
    
    lazy var favoritesNameList = {
        Array(self.favoritePlaces.keys)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritePlaces = DataManager.sharedInstance.favoritePlaces
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "favoriteRow")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoritePlaces.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteRow")!
        cell.textLabel!.text = favoritesNameList()[indexPath[1]]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.favoritePlace(name: favoritesNameList()[indexPath[1]])
    }
}

protocol PlacesFavoritesDelegate: class{
    func favoritePlace(name: String) -> Void
}

