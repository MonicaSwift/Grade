//
//  main.swift
//  Grade_hwang_seon_yu
//
//  Created by celia me on 2017. 6. 5..
//  Copyright © 2017년 celia me. All rights reserved.
//

import Foundation

let fileName = "students.json"
var filePath = ""
var contentFromFile:NSString = NSString()
var total:Float = 0.0
var totalCount:Float = 0.0
var average:String = ""
var grades:[String] = []
var completions:[String] = []

let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.userDirectory, FileManager.SearchPathDomainMask.localDomainMask, true)

if dirs.count > 0 {
    let dir = dirs[0]
    filePath = dir.appending("/\(NSUserName())/")
} else {
    print("Could not find local directory to store file")
}

do {
    contentFromFile = try NSString(contentsOfFile: filePath + fileName, encoding: String.Encoding.utf8.rawValue)
    
    let students = try JSONSerialization.jsonObject(with: contentFromFile.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
    
    totalCount = Float(students.count)
    for student in students {
        
        let tempGrades = (student as! NSDictionary)["grade"] as! NSDictionary
        let tempTotal = (tempGrades["algorithm"] == nil ? 0.0 : tempGrades["algorithm"] as! Float)
         + (tempGrades["data_structure"] == nil ? 0.0 : tempGrades["data_structure"] as! Float)
         + (tempGrades["database"] == nil ? 0.0 : tempGrades["database"] as! Float)
         + (tempGrades["operating_system"] == nil ? 0.0 : tempGrades["operating_system"] as! Float)
         + (tempGrades["networking"] == nil ? 0.0 : tempGrades["networking"] as! Float)
        let tempAverage = tempTotal / Float(tempGrades.count)
        
        var tempRating:String = ""
        switch tempAverage {
        case 90...100 : tempRating = "A"
        case 80..<90 : tempRating = "B"
        case 70..<80 : tempRating = "C"
        case 60..<70 : tempRating = "D"
        default: tempRating = "F"
        }
        
        if tempAverage >= 70 {
            completions.append((student as! NSDictionary)["name"] as! String)
        }
        
        total += tempAverage
        grades.append("\((student as! NSDictionary)["name"] as! String) \t : \(tempRating)")
        
    }
    average = String(format: "%.2f", total / totalCount)
}
catch let error as NSError {
    print("An error took place: \(error)")
}

let manager = FileManager()
let resultFile = filePath + "result.txt"
if !manager.fileExists(atPath: resultFile) {
    manager.createFile(atPath: resultFile, contents:nil, attributes: nil)
}

let file : FileHandle? = FileHandle(forUpdatingAtPath: resultFile)

var resultString = "성적 결과표\n\n전체 평균 : \(average)\n\n개인별 학점\n"
grades.sort(by: < )
for grade in grades {
    resultString += "\(grade)\n"
}

resultString += "\n수료생\n"
completions.sort(by: < )
for (index,completion) in completions.enumerated() {
    if index == 0 {
        resultString += "\(completion)"
    } else {
        resultString += ", \(completion)"
    }
}

if file == nil {
    print("file write fail")
} else {
    
    let stringData = resultString as NSString
    let data = stringData.data(using: String.Encoding.utf8.rawValue)
    file?.truncateFile(atOffset: 0)
    file?.seekToEndOfFile()
    file?.write(data!)
    file?.closeFile()
    
}

