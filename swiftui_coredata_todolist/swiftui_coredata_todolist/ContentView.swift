//
//  ContentView.swift
//  swiftui_coredata_todolist
//
//  Created by Dan Dan on 2/6/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: CoreDataViewModel = CoreDataViewModel()
    
    var body: some View {
        VStack {
            if !vm.updateState {
                VStack {
                    Spacer(minLength: 20)
                    TextField("Please enter a movie title", text: $vm.saveTodoString)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        vm.saveTodo(todoTitle: vm.saveTodoString)
                        vm.populateTodos()
                    } label: {
                        Text("save todo")
                    }
                    Spacer(minLength: 50)
                    ScrollView {
                        ForEach(vm.todoArray, id: \.self) { todo in
                            VStack {
                                Text("\(todo.title ?? "")")
                            }
                            .onTapGesture {
                                vm.updateTodoString = todo.title ?? ""
                                vm.selectedIndex = vm.getIndexOnTap()
                                vm.updateState = true
                            }
                        }
                    }
                }
            }else{
                UpdateAndDeleteTodoView(vm: vm, todo: vm.todoArray[vm.selectedIndex])
            }
        }
        .onAppear {
            vm.populateTodos()
        }
    }
}
