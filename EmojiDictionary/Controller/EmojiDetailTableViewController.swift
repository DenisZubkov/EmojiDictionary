//
//  EmojiDetailTableViewController.swift
//  EmojiDictionary
//
//  Created by Dennis Zubkoff on 10/10/2018.
//  Copyright © 2018 Denis Zubkov. All rights reserved.
//

import UIKit

class EmojiDetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    var emoji: Emoji?
    
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var usageTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
        guard sender == symbolTextField else { return }
        guard var symbol = symbolTextField.text else { return }
        guard symbol.count > 0 else { return }
        if !symbol.containsEmoji {
            let title = "Неверный СИМВОЛ!!"
            let message = "В поле 'СИМВОЛ' нет Эмодзи"
            showMessage(title: title, message: message)
            symbolTextField.text = ""
            return
        }
        if !symbol.isSingleEmoji {
            let title = "Неверный СИМВОЛ!!"
            let message = "В поле 'СИМВОЛ' может быть только один символ"
            showMessage(title: title, message: message)
            symbol.removeLast()
            symbolTextField.text = symbol
            return
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbolTextField.delegate = self
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        usageTextField.delegate = self 
        
        if let emoji = emoji {
            symbolTextField.text = emoji.symbol
            nameTextField.text = emoji.name
            descriptionTextField.text = emoji.description
            usageTextField.text = emoji.usage
        } else {
            symbolTextField.text = nil
            nameTextField.text = nil
            descriptionTextField.text = nil
            usageTextField.text = nil
        }
    }

    
    func updateSaveButtonState() {
        let symbol = symbolTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let usage = usageTextField.text ?? ""
        saveButton.isEnabled = !symbol.isEmpty && !name.isEmpty && !description.isEmpty && !usage.isEmpty
    }
    
    func showMessage(title: String, message: String) {
        let alertData = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertData.addAction(cancelAction)
        present(alertData, animated: true, completion: nil)
    }

}

extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}

extension String {
    
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        
        return unicodeScalars.contains { $0.isEmoji }
    }
    

}
