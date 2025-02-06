//
//  CoreDataViewModel.swift
//  swiftui_coredata_todolist
//
//  Created by Dan Dan on 2/6/25.
//

import Foundation
import CoreData


final class CoreDataViewModel: ObservableObject {
    // 存储所有Todo的Array
    @Published var todoArray = [Todo]()
    
    // 存储新增的todo string
    @Published var saveTodoString: String = ""
    
    // 存储更新或删除的title
    @Published var updateTodoString: String = ""
    
    // 判断是否跳到更新删除界面
    @Published var updateState: Bool = false
    
    // 透过使用者点击改变selectedIndex的值
    @Published var selectedIndex: Int = 0 {
        didSet {
            print("selectIndex changed: \(self.selectedIndex)")
        }
    }
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "TodoDataModel")
        persistentContainer.loadPersistentStores { NSEntityDescription, error in
            if let error = error {
                fatalError("Core data reading failed \(error.localizedDescription)")
            }
        }
    }
    
    func populateTodos() {
        todoArray = getTodos()
    }
    
    // 读取todos
    func getTodos() -> [Todo] {
        print("try to fetch todos...")
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    // 存储todo
    func saveTodo(todoTitle: String) {
        print("try to save todo...")
        
        let todo = Todo(context: persistentContainer.viewContext)
        todo.title = todoTitle
        
        do {
            try persistentContainer.viewContext.save()
        }catch{
            print("failed to save todo \(error.localizedDescription)")
        }
        
        selectedIndex = getIndexOnTap()
        saveTodoString = ""
    }
    
    func getIndexOnTap() -> Int {
        var index = 0
        
        for i in 0..<todoArray.count {
            if todoArray[i].title ?? "" == updateTodoString {
                index = i
            }
        }
        
        return index
    }
    
    func updateTodo() {
        print("try to update todo...")
        
        do {
            try persistentContainer.viewContext.save()
        }catch {
            persistentContainer.viewContext.rollback()
        }
        
        updateTodoString = ""
    }
    
    func deleteTodo(todo:Todo) {
        print("try to deleting todo")
        
        persistentContainer.viewContext.delete(todo)
        
        do {
            try persistentContainer.viewContext.save()
        }catch{
            persistentContainer.viewContext.rollback()
            print("delete reback failed \(error.localizedDescription)")
        }
    }
}
