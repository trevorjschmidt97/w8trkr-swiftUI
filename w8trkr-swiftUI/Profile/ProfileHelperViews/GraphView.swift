//
//  GraphView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 11/10/21.
//

import SwiftUI
import AAInfographics

struct GraphView: UIViewRepresentable {
    var proxy: GeometryProxy
    var weights: [Weight]
    
    var categories: [String] {
        var returnList: [String] = []
        for weight in weights {
            returnList.append(weight.dateTime.toPrettyShortFormattedDateString())
        }
        return returnList
    }
    
    var data: [Double] {
        var returnList: [Double] = []
        for weight in weights {
            returnList.append(Double(weight.weight.formatted())!)
        }
        return returnList
    }
    
    func makeUIView(context: Context) -> AAChartView {
        let chartViewWidth  = proxy.size.width
        let chartViewHeight = proxy.size.height
        let aaChartView = AAChartView()
        aaChartView.scrollView.isScrollEnabled = false
        aaChartView.isClearBackgroundColor = true
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)

        let aaChartModel = AAChartModel()
            .chartType(.line)
            .animationType(.easeFromTo)
            .dataLabelsEnabled(false)
            .tooltipValueSuffix(" lbs")
            .categories(categories)
            .colorsTheme([AppViewModel.shared.accentColorHex])
            .series([
                AASeriesElement()
                    .name("Actual Weight")
                    .data(data)
            ])
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
        
        return aaChartView
    }
    
    func updateUIView(_ uiView: AAChartView, context: Context) {
        //
    }
    
    
    
  
}


