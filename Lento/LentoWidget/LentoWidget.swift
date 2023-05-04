//
//  LentoWidget.swift
//  LentoWidget
//
//  Created by zhang on 2023/4/11.
//

import WidgetKit
import SwiftUI
import AFNetworking

struct StudyProvider: TimelineProvider {
    
    typealias Entry = SimpleEntry
    let placeholderList = [LentoProductSummary.luoji, LentoProductSummary.shaoheng]
    
    func placeholder(in context: Context) -> SimpleEntry {
        var obj = SimpleEntry(date: Date())
        obj.isLoading = true
        obj.list = []
        return obj
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let successed = true
        if successed {
            var sumary = LentoProductSummary()
            sumary.title = "xx头条"
            sumary.tag = "课程"
            sumary.image = UIImage(named: "Study_Shaoheng")
            sumary.ddUrl = "xx"
            let models = [sumary]
            
            var entry = SimpleEntry(date: Date())
            entry.isLoading = false
            entry.list = models
            completion(entry)
        } else { 
            let entry1 = SimpleEntry(date: Date(), list: placeholderList, isLoading: false)
            completion(entry1)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let successed = true
        if successed {
            var sumary = LentoProductSummary()
            sumary.title = "xx头条"
            sumary.tag = "课程"
            sumary.image = UIImage(named: "Study_xx")
            sumary.ddUrl = "xx"
            let models = [sumary]
            
            let currentDate = Date()
            let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let entry = SimpleEntry(date: currentDate, list: models, isLoading: false)
            let nextUpdateEntry = SimpleEntry(date: nextUpdateDate, list: models, isLoading: false)
            let timeline = Timeline(entries: [entry, nextUpdateEntry], policy: .atEnd)
            completion(timeline)
        } else {
            let entry = SimpleEntry(date: Date(), list: placeholderList, isLoading: false)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    var list: [LentoProductSummary] = []
    var isLoading: Bool = false
}

struct LentoWidgetEntryView : View {
    var entry: StudyProvider.Entry

    var body: some View {
        if entry.isLoading {
            StudyWidgetPlaceholderView()
        } else {
            StudyWidgetContentView(list: entry.list)
        }
    }
}

@main
struct LentoWidget: Widget {
    let kind: String = "LentoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StudyProvider()) { entry in
            LentoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("最近在学")
        .description("查看最近学习的内容并继续学习")
        .supportedFamilies([WidgetFamily.systemMedium])
    }
}

struct LentoWidget_Previews: PreviewProvider {
    static var previews: some View {
        LentoWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
