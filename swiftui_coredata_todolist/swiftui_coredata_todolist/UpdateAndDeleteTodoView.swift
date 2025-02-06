//
//  UpdateAndDeleteTodoView.swift
//  swiftui_coredata_todolist
//
//  Created by Dan Dan on 2/6/25.
//

import SwiftUI

struct UpdateAndDeleteTodoView: View {
    @StateObject var vm: CoreDataViewModel
    
    let todo: Todo
    
    var body: some View {
        VStack {
            TextField(todo.title ?? "", text: $vm.updateTodoString)
                .textFieldStyle(.roundedBorder)
            
            Button {
                if !vm.updateTodoString.isEmpty {
                    todo.title = vm.updateTodoString
                    vm.updateTodo()
                    vm.updateState = false
                }
            } label: {
                Text("change")
            }
            
            Button {
                vm.deleteTodo(todo: vm.todoArray[vm.selectedIndex])
                vm.updateState = false
            } label: {
                Text("delete")
            }
        }
        .padding()
    }
}

