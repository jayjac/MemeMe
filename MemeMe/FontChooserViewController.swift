//
//  FontChooserViewController.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 20/07/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit


//View controller that's shown to allow the user to pick a different font
//It'll consist of a tableview whose has as many sections as there are familyNames installed on the device
//Each section will have as many rows as there are fonts in one family
class FontChooserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate let fontFamilies = UIFont.familyNames
    fileprivate var selectedIndexPath: IndexPath?
    fileprivate let selectedFontUserDefaultsKey = "selectedFont"
    fileprivate let fontHeaderSectionIdentifier = "FontHeader" //Reuse identifier

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let headerNib = UINib(nibName: "FontHeaderView", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: fontHeaderSectionIdentifier)
        
        let font = UserDefaults.standard.string(forKey: selectedFontUserDefaultsKey) ?? "Impact"
        setFont(to: font)
    }
    
    fileprivate func setFont(to fontName: String) {
        UserDefaults.standard.setValue(fontName, forKey: selectedFontUserDefaultsKey)
        guard selectedIndexPath == nil else { return } // avoid to loop through all system fonts unnecessarily on every font change
        selectedIndexPath = getIndexPath(of: fontName)
        tableView.scrollToRow(at: selectedIndexPath!, at: .middle, animated: false) // goes straight to the selected font when user opens font chooser
    }
    
    fileprivate func getFont(at indexPath: IndexPath) -> String {
        let section = indexPath.section
        let row = indexPath.row
        let fontFamily = fontFamilies[section]
        let names = UIFont.fontNames(forFamilyName: fontFamily)
        let fontName = names[row]
        return fontName
    }
    
    // Retrieves the indexPath (section, row) of a given font name
    fileprivate func getIndexPath(of fontName: String) -> IndexPath {
        var indexPath = IndexPath(row: 0, section: 0)
        loop: for (section, family) in fontFamilies.enumerated() {
            let fonts = UIFont.fontNames(forFamilyName: family)
            for (row, font) in fonts.enumerated() {
                if font == fontName {
                    indexPath.row = row
                    indexPath.section = section
                    break loop
                }
            }
        }
        return indexPath
    }

    @IBAction func doneButtonWasTapped() {
        dismiss(animated: true, completion: nil)
    }

}

extension FontChooserViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UIFont.familyNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let font = fontFamilies[section]
        let names = UIFont.fontNames(forFamilyName: font)
        return names.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontCell")!

        let fontName = getFont(at: indexPath)
        cell.textLabel?.text = fontName
        cell.textLabel?.font = UIFont(name: fontName, size: 16.0)
        cell.accessoryType = .none // clears the checkmark before cell re-use
        
        if selectedIndexPath == indexPath {
            checkCell(cell, at: indexPath)
        }
        return cell
    }
    
    private func checkCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        cell.accessoryType = .checkmark
        selectedIndexPath = indexPath
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedIndexPath != indexPath {
            let previousSelectedIndexPath = selectedIndexPath //should never be nil
            let font = getFont(at: indexPath)
            setFont(to: font)
            
            //This is the cell being tapped so this should always be non-nil
            let cell = tableView.cellForRow(at: indexPath)
            checkCell(cell!, at: indexPath)
            
            guard let previousIndexPath = previousSelectedIndexPath else { return }
            let previousCell = tableView.cellForRow(at: previousIndexPath)
            previousCell?.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: fontHeaderSectionIdentifier) as! FontHeaderView
        header.label.text = "  \(fontFamilies[section])  "
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
}
