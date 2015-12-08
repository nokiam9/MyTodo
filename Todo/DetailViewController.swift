//
//  DetailViewController.swift
//  Todo
//
//  Created by imac on 15/12/6.
//  Copyright © 2015年 caogo.cn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var childButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!
    
    
    @IBOutlet weak var todoItem: UITextField!
    @IBOutlet weak var todoDate: UIDatePicker!
    
    // 注意：设置todo变量是为了在两个View中间传递参数，此处是一个class的指针，而不是真实的数据，因此可以直接修改todos的数据
    var todo: TodoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 因为需要处理todoItem的键盘弹出事件，定义了两个函数，并说明实现方法就在本实例的定义中，而非AppDelegate.swift的文件中
        todoItem.delegate = self
        
/*  -------------------
        注意：设计思路是在两个View中间通过判断todo是否为空，来确定segue的后续动作是编辑，还是新增，但目前在处理搜索结果页时还存在bug
-----------------------*/
        if todo == nil {                                        // 注：todo为空，说明是新增状态，否则就是编辑状态
            childButton.selected = true                         // 设置默认的动作图标
            navigationItem.title = "新建"
        }
        else {
            navigationItem.title = "编辑"
            
            if todo?.image == "child-selected" {
                childButton.selected = true
            } else if todo?.image == "phone-selected" {
                phoneButton.selected = true
            } else if todo?.image == "shopping-cart-selected" {
                shoppingCartButton.selected = true
            } else if todo?.image == "travel-selected" {
                travelButton.selected = true
            }
            todoItem.text = todo?.title
            todoDate.setDate((todo?.date)!, animated: false)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // 复位所有的按钮为灰色
    func resetButtons() {
        childButton.selected = false
        phoneButton.selected = false
        shoppingCartButton.selected = false
        travelButton.selected = false
    }
    
    @IBAction func childTapped(sender: AnyObject) {
        resetButtons()
        childButton.selected = true
    }
    
    @IBAction func phoneTapped(sender: AnyObject) {
        resetButtons()
        phoneButton.selected = true
    }
    
    @IBAction func shoppingCartTapped(sender: AnyObject) {
        resetButtons()
        shoppingCartButton.selected = true
    }
    
    @IBAction func travelTapped(sender: AnyObject) {
        resetButtons()
        travelButton.selected = true
    }
    
    //  设置确定按钮的动作
    @IBAction func confirmTapped(sender: AnyObject) {
        var image = ""
 
        if childButton.selected {
            image = "child-selected"
        } else if phoneButton.selected {
            image = "phone-selected"
        } else if shoppingCartButton.selected {
            image = "shopping-cart-selected"
        } else if travelButton.selected {
            image = "travel-selected"
        }
        
        if todo == nil {
            // NSUUID是一个取出随机数ID的标准方法
            let uuid = NSUUID().UUIDString
            todo = TodoModel(id: uuid, image: image, title: todoItem.text!, date: todoDate.date)
            todos.append(todo!)
        }
        else {
            todo?.image = image
            todo?.title = todoItem.text!
            todo?.date = todoDate.date
        }
    }
    
    // 在输入框中按下return时，收回键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        todoItem.resignFirstResponder()
        return true
    }
    
    // 在除输入框外的任何地方按屏幕，都将收回键盘
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        todoItem.resignFirstResponder()
    }
  
}
