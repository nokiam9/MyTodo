//
//  ViewController.swift
//  Todo
//
//  Created by imac on 15/12/6.
//  Copyright © 2015年 caogo.cn. All rights reserved.
//

import UIKit

// 定义了全局变量todos，也就是本APP需要的运行数据库，是一个TodoModel的数组
var todos:[TodoModel] = []

// 自定义的一个方法，将指定格式的字符串转化为NSDate类型，为了初始化时给todos赋值方便
func dateFromString(dateStr: String) -> NSDate? {
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    
    return dateFormat.dateFromString(dateStr)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 给todos数据库设置初始数据
        todos = [TodoModel(id: "1", image: "child-selected", title: "1. Go to Zone", date: dateFromString("2015-11-11")!),
        TodoModel(id: "2", image: "phone-selected", title: "2. Phone Call", date: dateFromString("2015-11-12")!),
        TodoModel(id: "3", image: "shopping-cart-selected", title: "3. Shopping Center", date: dateFromString("2015-11-13")!),
        TodoModel(id: "4", image: "travel-selected", title: "4. Travel to Europe", date: dateFromString("2015-12-12")!)]
        
        // 注意：这里设置了导航条左侧按钮为默认的Edit方式
        navigationItem.leftBarButtonItem = editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
        注意：UITableViewDataSource要发挥作用，条件之一是必须设置protocol的方法，而且所有的public func都需要设置（optional func可根据需要定义）；
        条件之二是必须在storyBoard中将指定tableView的控件和定义该dataSource方法的swift文件进行绑定，具体操作是按住ctrl，用鼠标连接tableView控件和ViewController控件（实际上，因为开始时已经将tableView控件与ViewController.swift进行了绑定，也就是@IBOutlet weak var tableView的语句左侧的标记），并在弹出窗口中选择dataSource（还有一个选项是delegate）
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 根据TableViewCell的Identifier参数（在故事板中手工设置），生成内存中的动态cell队列，列号信息在indexPath中
        let cell = self.tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath) as UITableViewCell
        let todo = todos[indexPath.row] as TodoModel
        
        // 根据TabelViewCell中的tag标记（在故事板中手工设置），依次取出cell中的各个控件
        let image = cell.viewWithTag(101) as! UIImageView
        let title = cell.viewWithTag(102) as! UILabel
        let date = cell.viewWithTag(103) as! UILabel
        
        // 根据todos中的数据设置各个控件的内容，其中date控件需要将todo.date的日期类型转换为字符串
        image.image = UIImage(named: todo.image)
        title.text = todo.title
        
        // 根据终端的locale参数，设置相应的日期显示方式
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd", options: 0, locale: NSLocale.currentLocale())
        date.text = dateFormat.stringFromDate(todo.date)
     
        return cell
    }
    
    // 设置删除的方法，并设置了其动画效果
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            todos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // 设置了Editing的方法，注意要结合viewDidLoad中设置导航条的左侧按钮才能生效
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    // 设置了DetailViewController中的按钮返回方法，注意：必须在故事板中进行手工segue的绑定
    @IBAction func xclose(segue:UIStoryboardSegue) {
        NSLog("View will be closed!")
        tableView.reloadData()
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TodoEdit" {
            let vc = segue.destinationViewController as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            if let index = indexPath {
                vc.todo = todos[index.row]
            }
        }
    }
    */
}

