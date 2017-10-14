//
//  AddAsPopUpViewController.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 25/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class AddAsPopUpViewController: UIViewController {
    @IBOutlet weak var categoryButton: UIButton!
    let categoryType = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.categoryType
            
        ]
    }()
    
    //MARK: - setting DropDown
    func customizeDropDown(_ sender: AnyObject) {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        //		appearance.textFont = UIFont(name: "Georgia", size: 14)
        
    }
    //MARK: UIViewControllerLifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Helper Methods
    func initialMethod()
    {
        //////////// drop down
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        self.categoryButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK: -dropDown Setup
    
    func setupDropDowns() {
        setupCategoryDropDown( )
        
    }
    
    
    func setupCategoryDropDown() {
        
        categoryType.anchorView = categoryButton
        
        self.categoryType.bottomOffset = CGPoint(x: 0, y: categoryButton.bounds.height)
        
        self.categoryType.dataSource = [
            "Private",
            "Public"
            
        ]
        
        // Action triggered on selection
        categoryType.selectionAction = { [unowned self] (index, item) in
            self.categoryButton.setTitle(item, for: .normal)
        }
        
    }
    
    
    //MARK: - UIButtonAction Methods
    
    
    @IBAction func dismisButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
        let conatactObj = ContactViewController()
        //conatactObj.isPopUp = true
        conatactObj.modalPresentationStyle = .overCurrentContext
        self.present(conatactObj, animated: true, completion: nil)
        
    }
    @IBAction func okButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func publicButtonAction(_ sender: UIButton) {
        categoryType.show()
    }
    @IBAction func cancelButtonAction(_ sender: UIButton) {
    }
}
