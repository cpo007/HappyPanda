//
//  HPLocalStorageManager.swift
//  HappyPanda
//
//  Created by cpo007@qq.com on 2019/5/17.
//  Copyright © 2019年 cpo007@qq.com. All rights reserved.
//

import Foundation
import WCDBSwift

class HPLocalStorangeManager {
    
    struct HPLocalStorangeDataBasePath {
        
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                         .userDomainMask,
                                                         true).last! + "/HMDB/HMDB.db"
    }
    
    
    static let share = HPLocalStorangeManager.init()
    static let dbPath = HPLocalStorangeDataBasePath.init().dbPath
    
    var database: Database?
    
    private init() {
        
    }
    
    private func getDatabase() -> Database {
        if database == nil {
            let database = Database.init(withPath: HPLocalStorangeManager.dbPath)
            self.database = database
            return database
        }
        return database!
    }
    
    public func createTable<T:TableCodable>(tableName: HPLocalStorageTable, tableClass: T.Type){
        do {
            try getDatabase().create(table: tableName.rawValue, of:tableClass)
        } catch let error {
            debugPrint("create table error: \(error)")
        }
    }
    
    //增
    public func insertToTable<T:TableCodable>(table: HPLocalStorageTable, tableClasses: [T]){
        do {
            try getDatabase().insert(objects: tableClasses, intoTable: table.rawValue)
        } catch let error {
            debugPrint("insert table error: \(error)")
        }
    }
    
    //增，若主键相同则进行替换
    public func replaceToTable<T:TableCodable>(table: HPLocalStorageTable, tableClasses: [T]){
        do {
            try getDatabase().insertOrReplace(objects: tableClasses, intoTable: table.rawValue)
        } catch let error {
            debugPrint("insert table error: \(error)")
        }
    }
    
    ///改
    public func updateToTable<T: TableCodable>(table: HPLocalStorageTable,on propertys: [PropertyConvertible],    with object: T, where condition: Condition? = nil){
        
        do {
            try getDatabase().update(table: table.rawValue, on: propertys, with: object, where:condition)
        } catch let error {
            debugPrint("update table error: \(error)")
        }
    }
    
    //删
    public func deleteFromTable(table: HPLocalStorageTable,where condition: Condition? = nil){
        do {
            try getDatabase().delete(fromTable: table.rawValue, where: condition)
        } catch let error {
            debugPrint("delete table error: \(error)")
        }
    }
    
    
    //查
    public func queryFromTable<T: TableCodable>(table: HPLocalStorageTable,to cName: T.Type, where condition: Condition? = nil, orderBy orderList:[OrderBy]? = nil) -> [T]? {
        
        do {
            let objects: [T] = try getDatabase().getObjects(fromTable: table.rawValue, where: condition, orderBy: orderList)
            return objects
        } catch let error {
            debugPrint("query table error: \(error)")
        }
        return nil
    }
    
    
    //删除数据表
    public func dropTable(table: HPLocalStorageTable){
        do {
            try getDatabase().drop(table: table.rawValue)
        } catch let error {
            debugPrint("drop table error: \(error)")
        }
    }
    
    //移除本地数据库文件
    public func removeDBFile(){
        
        do {
            try getDatabase().close {
                try getDatabase().removeFiles()
            }
        } catch let error {
            debugPrint("close DB error: \(error)")
        }
        
    }
    
}


enum HPLocalStorageTable:String {
    case Comic = "Comic"
    case Page = "Page"
}
