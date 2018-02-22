//
//  ViewController.swift
//  sampleCoreData
//
//  Created by Eriko Ichinohe on 2018/02/02.
//  Copyright © 2018年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import CoreData  //CoreData使う時絶対必要

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
,UIPickerViewDataSource
,UIPickerViewDelegate
{

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //文字列を表示するセルの取得（セルの再利用）
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //表示したい文字の設定
//                cell.textLabel?.text = "\(indexPath.row)行目"
        cell.textLabel?.text = todoList[indexPath.row]
        
        //文字を設定したセルを返す
        return cell
    }
    
    // MARK: -

    //Category用の変数
    var catList:[String] = []
    @IBOutlet weak var catPickerView: UIPickerView!

    //ToDo用の変数
    var todoList:[String] = []
    @IBOutlet weak var toDoTitle: UITextField!
    @IBOutlet weak var todoTableView: UITableView!
    

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        //CategoryのデータをCoreDataから読み出し
        readCoreData(ref: "Category")
        
        
        //CoreDataからデータを読み込む処理
        readCoreData(ref: "ToDo")
        
        //テーブルビューを再表示
        todoTableView.reloadData()
        
        //ピッカービューのデリゲート
        catPickerView.delegate = self
        catPickerView.dataSource = self
        
    }

//    //既に存在するデータの読み込み処理
//    func read(){
//
//        //配列の初期化
//        todoList = []
//        //AppDelegateを使う準備をしておく
//        let appD:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        //エンティティを操作するためのオブジェクトを作成
//        let viewContext = appD.persistentContainer.viewContext
//
//        //データを取得するエンティティの指定
//        //<>の中はモデルファイルで指定したエンティティ名
//        let query: NSFetchRequest<ToDo> = ToDo.fetchRequest()
//
//        do {
//            //データの一括取得
//            let fetchResults = try viewContext.fetch(query)
//
//            //取得したデータを、デバッグエリアにループで表示
//            for result: AnyObject in fetchResults {
//                let title : String = result.value(forKey: "title") as! String
//
//                let saveDate : Date = result.value(forKey: "saveDate") as! Date
//
//                print("title:\(title) saveDate:\(saveDate)")
//
//                todoList.append(title)
//
//            }
//        } catch  {
//
//        }
//
//
//
//    }
    
    // CoreDataの読み出し先によって切り替えて読み出す関数
    func readCoreData(ref:String) {
        
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        

        switch  ref {
        case "ToDo" :
            //ToDo用のRead処理
            //配列の初期化
            todoList = []
            //データを取得するエンティティの指定
            //<>の中はモデルファイルで指定したエンティティ名
            let query: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            
            // pickerViewで選択されている文字を取得
            let selectedRow = catPickerView.selectedRow(inComponent: 0) //引数は列番号
            let catTitle = catList[selectedRow]

            query.predicate = NSPredicate(format: "catTitle = %@", catTitle)
            
            do {
                //データの一括取得
                let fetchResults = try viewContext.fetch(query)
                
                //取得したデータを、デバッグエリアにループで表示
                for result: AnyObject in fetchResults {
                    let title : String = result.value(forKey: "title") as! String
                    
                    let saveDate : Date = result.value(forKey: "saveDate") as! Date

                   // let catTitle : String = result.value(forKey: "catTitle") as! String

                    print("title:\(title) saveDate:\(saveDate)")
                    
                    todoList.append(title)
                    
                }
            } catch  {
                
            }
            
        case "Category":
            //Category用のRead処理
            //配列の初期化
            catList = []
            //データを取得するエンティティの指定
            //<>の中はモデルファイルで指定したエンティティ名
            let query: NSFetchRequest<Category> = Category.fetchRequest()
            
            do {
                //データの一括取得
                let fetchResults = try viewContext.fetch(query)
                
                //取得したデータを、デバッグエリアにループで表示
                for result: AnyObject in fetchResults {
                    let titleOfCat : String = result.value(forKey: "titleOfCat") as! String
                    
                    
                    print("titleOfCat:\(titleOfCat) ")
                    
                    catList.append(titleOfCat)
                    
                }
            } catch  {
                
            }
            
        default:
            print("想定外の文字が指定されました")
        }
 
        
        
        
    }
    
    //リターンキーが押された時（キーボードが下がる）
    @IBAction func tapReturn(_ sender: UITextField) {
    }
    
    //追加ボタンが押された時
    @IBAction func tapSave(_ sender: UIButton) {
        
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        
        //ToDoエンティティオブジェクトを作成
        //forEntityNameは、モデルファイルで決めたエンティティ名（大文字小文字合わせる）
        let ToDo = NSEntityDescription.entity(forEntityName: "ToDo", in: viewContext)
        
        //ToDoエンティティにレコード（行）を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
        
        //レコードオブジェクトに値のセット
        newRecord.setValue(toDoTitle.text, forKey: "title")
        newRecord.setValue(Date(), forKey: "saveDate")  //Date()で現在日時が取得できます
        
        // pickerViewで選択されている文字を取得
        let selectedRow = catPickerView.selectedRow(inComponent: 0) //引数は列番号
        let catTitle = catList[selectedRow]
        newRecord.setValue( catTitle, forKey: "catTitle")
        print("cattile:\(catTitle)")
        
        //docatch エラーの多い処理はこの中に書くという文法ルールなので必要
        do {
            //レコード（行）の即時保存
            try viewContext.save()
        } catch  {
            print("DBへの保存に失敗しました")
            print(error)
        }
        
        
        //CoreDataからデータを読み込む処理
        readCoreData(ref: "ToDo")

        //テーブルビューを再表示
        todoTableView.reloadData()
    }
    
    //削除ボタンが押された時
    @IBAction func tapDelete(_ sender: UIButton) {
        
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        
        //データを取得するエンティティの指定
        //<>の中はモデルファイルで指定したエンティティ名
        let query: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        do {
            //削除したいデータの一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //取得したデータを、削除指示
            for result: AnyObject in fetchResults {
                let record = result as! NSManagedObject // 一行分のデータ
                
                viewContext.delete(record)
                
            }
        
            //削除した状態を保存
            try viewContext.save()
            
        } catch  {
            
        }
        
        
        
        
    }
    
    
    @IBAction func tapUpdate(_ sender: UIButton) {
        print("update")
        //AppDelegateを使う準備をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
 
        let query: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        

        
        query.predicate = NSPredicate(format: "title = %@", "鈴")

        
        
        do {
           
            //データの一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //取得したデータを、デバッグエリアにループで表示
            for result: AnyObject in fetchResults {

                //レコードオブジェクトに値のセット
                result.setValue(toDoTitle.text, forKey: "title")
                

                

                
                do{
                    try viewContext.save()
                    readCoreData(ref: "ToDo")
                    
                    todoTableView.reloadData()
                    
                }catch {
                    
                }
            }
        } catch  {
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //　削除キーを押されたら発動
            
            //1行だけCoreDataを削除する処理
            //AppDelegateを使う準備をしておく
            let appD:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            //エンティティを操作するためのオブジェクトを作成
            let viewContext = appD.persistentContainer.viewContext
            
            //データを取得するエンティティの指定
            //<>の中はモデルファイルで指定したエンティティ名
            let query: NSFetchRequest<ToDo> = ToDo.fetchRequest()

            //　検索するtoDoのタイトルを取得
            let cell = tableView.cellForRow(at: indexPath)
            let searchTitle = cell?.textLabel?.text
            print(searchTitle)
            
            //取得したタイトルをキーにqueryのデータを絞り込む
            query.predicate = NSPredicate(format: "title = %@", searchTitle!)
            
            //削除処理（全削除と同じ）
            do {
                //削除したいデータの一括取得
                let fetchResults = try viewContext.fetch(query)
                
                //取得したデータを、削除指示
                for result: AnyObject in fetchResults {
                    let record = result as! NSManagedObject // 一行分のデータ
                    
                    viewContext.delete(record)
                    
                }
                
                //削除した状態を保存
                try viewContext.save()
                //CoreDataからデータを読み込む処理
                readCoreData(ref: "ToDo")

                //テーブルビューを再表示
                todoTableView.reloadData()
                
            } catch  {
                
            }
            
        }
    
    }
    
    //pickerview行数を指定します。
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catList.count
    }
    //pickerviewの列数を指定します。
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //pickerviewに表示する文字の設定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catList[row]
    }
    
    //選択されたときに発動する処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let satu:CGFloat = CGFloat(catList.count - row) / CGFloat(catList.count)
        
        catPickerView.backgroundColor = UIColor(hue: 180/359, saturation: satu, brightness: 1, alpha: 1)
        
        readCoreData(ref: "ToDo")

        //テーブルビューを再表示
        todoTableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

