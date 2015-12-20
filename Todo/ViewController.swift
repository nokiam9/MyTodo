//
//  ViewController.swift
//  Todo
//
//  Created by imac on 15/12/6.
//  Copyright © 2015年 caogo.cn. All rights reserved.
//

import UIKit

// 定义了全局变量todos，也就是本APP需要的运行数据库，是一个TodoModel的class数组
var todos:[TodoModel] = []

// 定义一个用于搜索的todos数组
var filteredTodos: [TodoModel] = []

// 自定义的一个方法，将指定格式的字符串转化为NSDate类型，为了初始化时给todos赋值方便
func dateFromString(dateStr: String) -> NSDate? {
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    
    return dateFormat.dateFromString(dateStr)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{

    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 给todos数据库设置初值，注意：todos是class，设置的方式实际上是调用init()，而非变量赋初值，因此只能在初始化函数中进行，而非头文件
        todos = [TodoModel(id: "1", image: "child-selected", title: "1. Go to Zone", date: dateFromString("2015-11-11")!),
        TodoModel(id: "2", image: "phone-selected", title: "2. Phone Call", date: dateFromString("2015-11-12")!),
        TodoModel(id: "3", image: "shopping-cart-selected", title: "3. Shopping Center", date: dateFromString("2015-11-13")!),
        TodoModel(id: "4", image: "travel-selected", title: "4. Travel to Europe", date: dateFromString("2015-12-12")!)]
        
        // 注意：这里设置了导航条左侧按钮为默认的Edit方式
        navigationItem.leftBarButtonItem = editButtonItem()
        
        searchController = UISearchController(searchResultsController: nil)
        if searchController != nil {
            searchController.searchResultsUpdater = self
            
            // 设置输入框的提示语
            searchController.searchBar.placeholder = "Searching here ..."
            
            // 设置搜索结果是否可以选中，默认是true；考虑到数据可能被修改，最好还是用默认的不可修改状态
            searchController.dimsBackgroundDuringPresentation = false
            
            // 设置搜索框为可见
            tableView.tableHeaderView = searchController.searchBar
        }
        
        // 启动时隐藏搜索框，但用户下拉时可见
        // 注意：contentOffset时一个CGPoint的类型，包含x和y两个CGPoint变量，而frame包含了控件的框架结构信息
        var contentOffset = tableView.contentOffset
        
        //contentOffset.y += self.searchDisplayController!.searchBar.frame.size.height
        contentOffset.y += self.searchController.searchBar.frame.size.height
        
        tableView.contentOffset = contentOffset
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
        
    /*  ----------------------------
        注意：
        1、编译时警告searchResultController在iOS8.0以后不支持，修改为searchController，但改名后报错不支持，怎么办呢！！！！
        2、searchBar控件自带了一个searchResultTableView用于显示搜索结果数据，但本例中直接覆盖在tableView中，因此判断方法就是检查tableView 和self.searchDisplayController?.searchResultsTableView是否相同
        3、但是本例中有一个bug，当搜索结果显示时，如果点击cell将调用segue打开detailViewController，但是todo的参数传递存在问题，不能准确判断原始View是来自searchResultTableView还是tableView，误判为新增todo，有时可转为编辑，但内容错行，目前尚未找到解决方案，因为第2点的方法似乎失效了！！！！
        ---------------------------- */

        // 判断当前tableView是否是搜索结果View
        /*
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return filteredTodos.count
        }
        else {
            return todos.count
        } */
        
        return searchController.active ? filteredTodos.count : todos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 根据TableViewCell的Identifier参数（在故事板中手工设置），生成内存中的动态cell队列，列号信息在indexPath中
        let cell = self.tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath) as UITableViewCell
        
        // 根据主表还是搜索结果表，导入相应cell的内容
        var todo: TodoModel
        
        /*
        if tableView == self.searchDisplayController?.searchResultsTableView {
            todo = filteredTodos[indexPath.row]
        }
        else {
            todo = todos[indexPath.row]
        } */
        
        todo = searchController.active ? filteredTodos[indexPath.row] : todos[indexPath.row]
        
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
    
    // 自定义设置cell的高度为80，为了解决搜索结果显示时高度为默认值44
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    // 设置删除模式，并设置了其动画效果
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            todos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // 设置编辑模式，注意要结合viewDidLoad中设置导航条的左侧按钮才能生效
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: true)
    }
    
    // 设置移动模式，返回设置为只有在editing模式下才允许移动item
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return editing
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let todo = todos.removeAtIndex(sourceIndexPath.row)
        todos.insert(todo, atIndex: destinationIndexPath.row)
    }
    
    /*-------此函数删除，改为searchController中需要定义的接口
    // 设置搜索模式
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        
        // 注意，todos.filer(){}是一个闭包，$0是指第一个入参，直接判断是否包含searchString，并返回Bool
        filteredTodos = todos.filter(){$0.title.rangeOfString(searchString!) != nil}
        
        return true
    }
    --------*/
    
    // 定义searchController中需要的新方法
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        filteredTodos = todos.filter(){$0.title.rangeOfString(searchString!) != nil}
        tableView.reloadData()
    }
    
    // 设置了DetailViewController中的按钮返回方法，注意：必须在故事板中进行手工segue的绑定
    @IBAction func xclose(segue:UIStoryboardSegue) {
        NSLog("View will be closed!")
        tableView.reloadData()
    }
    
    // 设置调用segue的准备工作，包括传递todo参数的任务
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 有两个segue，检查是否是编辑状态，负责就是新增
        if segue.identifier == "TodoEdit" {
            
            // 取出新ViewController的指针，为了在两个ViewController之间传递参数todo
            let vc = segue.destinationViewController as! DetailViewController
            
/*  -------------------------------------------
    注意，indexPathForSelectedRow的老版本是一个函数，调用方法是tableView.indexPathForSelectedRow()
    新版本成了一个只有get方法的闭包，只能通过tableView.indexPathForSelectedRow的方式调用
---------------------------------------------*/
            let indexPath = tableView.indexPathForSelectedRow
            if let index = indexPath {
/*  -------------------------------------------
    注意，搜索结果的编辑bug就出在这里，因为不能准确区分调用todos，还是filterTodos
    Note：现在用searchController.active可以准确判断了，但是为保险起见，还是设置搜索结果不可选择吧
---------------------------------------------*/
                vc.todo = searchController.active ? filteredTodos[index.row] : todos[index.row]
            }

        }
        
    }
    
}

