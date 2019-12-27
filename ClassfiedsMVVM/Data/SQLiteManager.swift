//
//  SQLiteManager.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import Foundation
import SQLite3


class SQLiteManager {
    
    // A reference to the file mamanger
    let fileManager = FileManager.default
    
    // A reference to the SQLite database
    //  SQLite is a C-based API so the reference is a C pointer so in swift to reference it we use type OpaquePointer
    var sqliteDB: OpaquePointer? = nil
    
    // The database URL
    var dbUrl: URL? = nil
    
    
    init() {
        // Initialise the dbURL
        do {
            let baseUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbUrl = baseUrl.appendingPathComponent("categoriesDB.sqlite")
        } catch {
            print(error)
        }
        
        // Check if URL directory actually returned a workable directory
        if let dbUrl = dbUrl {
            
            // The flags which will be passed to the open function. The database is opened for reading and writing, and is created if it does not already exist
            let flags = SQLITE_OPEN_READWRITE
            
            // Open the DB and check the status code returned by the function
            if sqlite3_open_v2(dbUrl.path, &sqliteDB, flags, nil) != SQLITE_OK {
                
                createOpenNewDB(path: dbUrl.path)
                
                
            } else {
                print("Opening the database successful")
            }
            
        }
    }
    
    
    /// Creates and opens a new sqlite database file and creates Categories table with 6 categories
    /// - Parameter path: URL path of the sqlite database file where it will be created
    func createOpenNewDB(path: String) {
        let flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
        
        if sqlite3_open_v2(path, &sqliteDB, flags, nil) == SQLITE_OK {
            
            print("Database file could not be found/opened so new one was created and opened")
            
            // Create a table
            //    Tablese return an error message in case something has gone wrong
            //let errMsg: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
            
            let sqlStatement = "CREATE TABLE IF NOT EXISTS Categories (ID INTEGER PRIMARY KEY AUTOINCREMENT, Category TEXT, Clicks INTEGER)"
            
            if sqlite3_exec(sqliteDB, sqlStatement, nil, nil, nil) == SQLITE_OK {
                print("Table created")
            } else {
                let errMsg = String(cString: sqlite3_errmsg(sqliteDB)!)
                print("Error creating table: \(errMsg)")
            }
            
            var statement: OpaquePointer? = nil
            
            let insertStatement = "INSERT INTO Categories (Category, Clicks) values ('Nature', 0),('Sport', 0),('Food', 0),('Cars', 0),('Animals', 0),('Technology', 0);"
            sqlite3_prepare_v2(sqliteDB, insertStatement, -1, &statement, nil)
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Values inserted to the table")
            } else {
                print("Did not insert values to the table")
            }
            // Destroy the statement to remove from memory
            sqlite3_finalize(statement)
        }
    }


    
    /// Retrieves all rows from Categories table in the sqlite database and returnes the result as an array of Category objects
    func selectData() -> [Category] {
        
        var categories = [Category]()
        
        var statement: OpaquePointer? = nil
        
        // Select rows from the table
        let selectStatement = "SELECT * FROM Categories"
        
        if sqlite3_prepare_v2(sqliteDB, selectStatement, -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let rowId = sqlite3_column_int(statement, 0)
                
                let clicks = sqlite3_column_int(statement, 2)
                
                if let cString = sqlite3_column_text(statement, 1) {
                    let category = String(cString: cString)
                    categories.insert(Category(categoryId: Int(rowId), categoryName: category, clicks: Int(clicks), images: nil), at: Int(rowId-1))
                    print("\(rowId)  \(category)  \(clicks)")
                } else {
                    print("Category not found")
                }
            }
        }
        sqlite3_finalize(statement)
        
        return categories
    }
    
    
    /// Updates number of clicks for a particular category in the sql database
    /// - Parameters:
    ///   - id: the unique id of category in the table in the database
    ///   - clicks: integer - the new number of clicks
    func updateClicks(id: Int, clicks: Int) {
        let updateStatementString = "UPDATE Categories SET Clicks = \(clicks) WHERE ID = \(id);"
        
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(sqliteDB, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated clicks for id=\(id) and clicks=\(clicks)")
            } else {
                print("Could not update clicks.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
}
