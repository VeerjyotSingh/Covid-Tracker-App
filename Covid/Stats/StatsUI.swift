//
//  StatsUI.swift
//  Covid
//
//  Created by Veerjyot Singh on 21/05/22.
//

import SwiftUI
import Charts


class StatsUI : UIViewController {
    
    var array:[Int] = []
    var nothing:Bool = false
    let baseURL = "https://api.covid19api.com/dayone/country/india/status/confirmed"
    
    override func viewDidLoad() {
        super .viewDidLoad()
        fetch()
        while nothing == false {
            print("waiting")
        }
        createBarChart()
    }
    
    func fetch() {
        
        let urlString = baseURL
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let safeData = data {
                    if let covidCases = self.parseJSON(safeData) {
                        var x = 1
                        while x < covidCases.count{
                            self.array.append(covidCases[x]-covidCases[x-1])
                            x=x+1
                            
                        }
                        self.nothing = true
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
    
    func parseJSON(_ data: Data) -> [Int]? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([Course].self, from: data)
            var x = 0
            var array : [Int] = []
            while x < decodedData.count{
                array.append(decodedData[x].Cases)
                x = x+1
            }
            return array
            
        } catch {
            return []
        }
    }
    
    
    
    
    
    func createBarChart(){
        let barChart = BarChartView(frame: CGRect(x: 0, y: 0,
                                                          width:  view.frame.size.width,
                                                                                                height: view.frame.size.width))
        
        BarChartView().animate(xAxisDuration: 2.5)
        var entries = [BarChartDataEntry]()
        var y:Int = 0
        while y < array.count{
            entries.append(BarChartDataEntry(x: Double(y), y:Double(array[Int(y)])))
            y = y+1
        }
        let set = BarChartDataSet(entries: entries,
                                  label: "Covid Cases in India")
        set.drawValuesEnabled = false
        set.drawIconsEnabled = false 
        set.colors = ChartColorTemplates.material()
        let data = BarChartData(dataSet: set)
        barChart.data = data
        view.addSubview(barChart)
        barChart.center = view.center
    }
    
}
