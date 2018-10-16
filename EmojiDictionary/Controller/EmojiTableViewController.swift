//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Denis Zubkov on 08/10/2018.
//  Copyright © 2018 Denis Zubkov. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var emojis: [Emoji] = []
    var emojiTypes: [EmojiType] = []
    var isAppend: Bool?
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileName = "emojiTypes"
    let fileExt = "plist"
    
//    [EmojiType.init(name: "Животные", emojis: emojiAnimals),
//                                   EmojiType.init(name: "Мордочки", emojis: emojiFaces)
//    ]
//
    func saveData(to archiveURL: URL) {
        let propertyListEncoder = PropertyListEncoder()
        let encodeEmojiTypes = try? propertyListEncoder.encode(emojiTypes)
        try? encodeEmojiTypes?.write(to: archiveURL, options: .noFileProtection)
        
    }
    
    func loadData() {

        let archiveURL = documentsDirectory.appendingPathComponent(fileName).appendingPathExtension(fileExt)
        let propertyListDecoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: archiveURL),
            let decodeEmojiTypes = try? propertyListDecoder.decode([EmojiType].self, from: data) {
            
            self.emojiTypes = decodeEmojiTypes
            
        } else {
            
            emojis.append(Emoji(symbol: "🐢", name: "Черепаха", description:  "Зеленая черепаха", usage: "Медленное движение"))
            emojis.append(Emoji(symbol: "🐰", name: "Заяц", description:  "Заяц с ушами", usage: "Быстрое движение"))
            emojis.append(Emoji(symbol: "🐱", name: "Кошка", description:  "Желтый кот", usage: "Хитрое поведение"))
            emojis.append( Emoji(symbol: "🐶", name: "Собака", description:  "Типичный пес", usage: "Открытое поведение"))
            emojis.append(Emoji(symbol: "😀", name: "Смайлик", description:  "Улыбающаяся мордочка", usage: "Медленное движение"))
            emojis.append( Emoji(symbol: "😇", name: "Ангел", description:  "Мордочка с нимбом", usage: "Хорошие поступки}"))
            emojis.append(Emoji(symbol: "😍", name: "Влюбленный", description:  "Влюбленная мордочка", usage: "Состояние влюбленности"))
            let emojiAnimals = [emojis[0], emojis[1], emojis[2], emojis[3]]
            let emojiFaces = [emojis[4], emojis[5], emojis[6]]
            emojiTypes.append(EmojiType(name: "Животные", emojis: emojiAnimals))
            emojiTypes.append(EmojiType(name: "Мордочки", emojis: emojiFaces))
            emojiTypes.append(EmojiType(name: "Новые", emojis: []))
            
            saveData(to: archiveURL)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.title = "Правка"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return emojiTypes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return emojiTypes[section].emojis.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiTableViewCell", for: indexPath) as! EmojiTableViewCell
        let emoji = emojiTypes[indexPath.section].emojis[indexPath.row]
        cell.update(with: emoji)
        // cell.showsReorderControl = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return emojiTypes[section].name
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            emojiTypes[indexPath.section].emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        let archiveURL = documentsDirectory.appendingPathComponent(fileName).appendingPathExtension(fileExt)
        saveData(to: archiveURL)
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: UITableViewDelegate
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let emoji = emojiTypes[indexPath.section].emojis[indexPath.row]
//
//        print("\(emoji.symbol) - \(indexPath)")
//    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = emojiTypes[sourceIndexPath.section].emojis.remove(at: sourceIndexPath.row)
        emojiTypes[destinationIndexPath.section].emojis.insert(movedEmoji, at: destinationIndexPath.row)
        let archiveURL = documentsDirectory.appendingPathComponent(fileName).appendingPathExtension(fileExt)
        saveData(to: archiveURL)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmojiEditSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                isAppend = false
                let dvc = segue.destination as! EmojiDetailTableViewController
                dvc.emoji = emojiTypes[indexPath.section].emojis[indexPath.row]
            }
        }
        if segue.identifier == "EmojiAppendSegue" {
                isAppend = true
                let dvc = segue.destination as! EmojiDetailTableViewController
                dvc.emoji = nil
        }
    }
    
    @IBAction func editSave(unwindSegue: UIStoryboardSegue) {
        let dvc = unwindSegue.source as! EmojiDetailTableViewController
        guard let isAppend = isAppend else { return }
        let symbol = dvc.symbolTextField.text ?? ""
        let name = dvc.nameTextField.text ?? ""
        let description = dvc.descriptionTextField.text ?? ""
        let usage = dvc.usageTextField.text ?? ""
        if isAppend {
            let emoji = Emoji.init(symbol: symbol, name: name, description: description, usage: usage)
            var index = 0
            for emojiType in emojiTypes {
                if emojiType.name == "Новые" {
                    emojiTypes[index].emojis.append(emoji)
                }
                index += 1
            }
            self.isAppend = nil
            
        } else {
            if let indexPath = tableView.indexPathForSelectedRow {
                emojiTypes[indexPath.section].emojis[indexPath.row].symbol = symbol
                emojiTypes[indexPath.section].emojis[indexPath.row].name = name
                emojiTypes[indexPath.section].emojis[indexPath.row].description = description
                emojiTypes[indexPath.section].emojis[indexPath.row].usage = usage
                self.isAppend = nil
                
            }
        }
        let archiveURL = documentsDirectory.appendingPathComponent(fileName).appendingPathExtension(fileExt)
        saveData(to: archiveURL)
        tableView.reloadData()
        
        
    }
    
    @IBAction func editCancel(unwindSegue: UIStoryboardSegue) { 
        
    }

    
}
