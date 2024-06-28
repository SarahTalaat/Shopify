//
//  CustomDropDownViewController.swift
//  Shopify
//
//  Created by Sara Talat on 03/06/2024.
//

import UIKit

class CustomDropDownViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var dropDownTableView: UITableView!

    let items = ["Item 1", "Item 2", "Item 3", "Item 4"] // Your items for the dropdown
    var isDropDownVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view
        dropDownTableView.dataSource = self
        dropDownTableView.delegate = self
        dropDownTableView.isHidden = true

        // Optional: Customize the appearance of the button
        dropDownButton.layer.cornerRadius = 5
        dropDownButton.layer.borderWidth = 1
        dropDownButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func dropDownButtonTapped(_ sender: UIButton) {
        isDropDownVisible.toggle()
        dropDownTableView.isHidden = !isDropDownVisible
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownButton.setTitle(items[indexPath.row], for: .normal)
        dropDownTableView.isHidden = true
        isDropDownVisible = false
    }
}
