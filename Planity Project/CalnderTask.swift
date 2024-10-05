//
//  TaskHeadingView.swift
//  Planity Project
//
//  Created by Aliah Alhameed on 02/04/1446 AH.
//


import SwiftUI


// TaskHeading Struct to represent the task title and details
struct TaskHeading: Hashable {
    var title: String
    var details: [String]
}

// Task Struct to represent each posting task
struct Task: Identifiable, Hashable {
    enum Platform: String, Identifiable, Hashable {
        case tiktok = "TikTok"
        case instagram = "Instagram"

        var id: String {
            self.rawValue
        }

        var image: String {
            switch self {
            case .tiktok:
                return "tik" // Use the appropriate image name for TikTok
            case .instagram:
                return "instagrma" // Use the appropriate image name for Instagram
            }
        }
    }

    let id = UUID()
    var platform: Platform
    var time: String
    var content: String?
    var heading: TaskHeading
    var isUserAdded: Bool // Flag to indicate if the task is user-added

    init(platform: Platform = .tiktok, time: String = "", content: String? = nil, heading: TaskHeading, isUserAdded: Bool = false) {
        self.platform = platform
        self.time = time
        self.content = content
        self.heading = heading
        self.isUserAdded = isUserAdded
    }
}

struct CalnderTask: View {
    @AppStorage("userName") var userName: String = ""
        @AppStorage("userField") var userField: String = ""
    @State private var contentPlan: [String: [Task]] = [:] // Stores the plan with dates as keys
    @State private var selectedDate: Date = Date() // Stores the selected date, initialized to today
    @State private var tasksForSelectedDate: [Task] = []
    @State private var showSheetType: SheetType? = nil // Controls which sheet is visible
    @State private var currentMonth: Int // Represents the current month
    @State private var currentYear: Int // Represents the current year

    enum SheetType: Identifiable {
        case taskSheet
        case addTask

        var id: Int {
            hashValue
        }
    }

    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 7) // Increased column spacing for more space between ovals

    // Initialize currentMonth and currentYear with today's date values
    init() {
        let currentDate = Date()
        let calendar = Calendar.current
        _currentMonth = State(initialValue: calendar.component(.month, from: currentDate))
        _currentYear = State(initialValue: calendar.component(.year, from: currentDate))
    }

    var body: some View {
        NavigationView {

        
    

            VStack {
                ZStack {
                    Spacer()
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: HintView()) {
                            Image("light-bulb")
                                .resizable()
                                .frame(width: 80.0, height: 80.0)
                        }
                        }
                    }
                }
                                // User Greeting Section
                                VStack(spacing: 20) {
                                    Text("Hello, \(userName)")
                                        .font(.title)
                                        .bold()
                                    

                                    Text("The best plan for \(userField) field.")
                                        .font(.headline)
                                      
                                }
                // Month View Header
                HStack {
                    Button(action: {
                        if currentMonth > 1 {
                            currentMonth -= 1
                        } else {
                            currentMonth = 12
                            currentYear -= 1
                        }
                        selectedDate = Date.distantPast // Deselect the current date
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("\(monthString(currentMonth)) \(String(currentYear))") // Modified to ensure the year displays without commas
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        if currentMonth < 12 {
                            currentMonth += 1
                        } else {
                            currentMonth = 1
                            currentYear += 1
                        }
                        selectedDate = Date.distantPast // Deselect the current date
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 10)
                
                // Day Labels (Sun, Mon, ...)
                HStack {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                // Calendar Grid for the Selected Month
                let days = getDaysForMonth(currentMonth, currentYear)
                LazyVGrid(columns: columns, spacing: 20) { // Increased row spacing for more space between rows
                    ForEach(days, id: \.self) { date in
                        CalendarDayView(
                            date: date,
                            isSelected: Calendar.current.isDate(selectedDate, inSameDayAs: date),
                            isToday: Calendar.current.isDateInToday(date),
                            contentPlan: contentPlan
                        )
                        .onTapGesture {
                            selectedDate = date
                            loadTasksForDate()
                            showSheetType = .taskSheet
                        }
                    }
                }
                .padding()
                
                // Add Task Button
                Button(action: {
                    showSheetType = .addTask
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding()
                
                Spacer()
            }
            .onAppear {
                generateContentPlan()
                loadTasksForDate() // Load tasks for today when the view appears
            }
            .sheet(item: $showSheetType) { sheetType in
                switch sheetType {
                case .taskSheet:
                    TaskSheetView(date: selectedDate, tasks: $tasksForSelectedDate, deleteTask: deleteTask)
                case .addTask:
                    AddTaskView(selectedDate: selectedDate) { newTask in // Pass selectedDate here
                        addTask(newTask, for: selectedDate)
                    }
                }
            }
        }
        
    }
    // Function to generate the list of days for the given month
    func getDaysForMonth(_ month: Int, _ year: Int) -> [Date] {
        var dates = [Date]()
        let dateComponents = DateComponents(year: year, month: month)

        if let startOfMonth = Calendar.current.date(from: dateComponents),
           let monthRange = Calendar.current.range(of: .day, in: .month, for: startOfMonth) {

            // Add blank dates for the first week day of the month
            let weekday = Calendar.current.component(.weekday, from: startOfMonth)
            for _ in 1..<weekday {
                dates.append(Date.distantPast) // Placeholder dates for empty cells
            }

            for day in monthRange {
                if let date = Calendar.current.date(bySetting: .day, value: day, of: startOfMonth) {
                    dates.append(date)
                }
            }
        }

        return dates
    }

    // Helper function to get month name
    func monthString(_ month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let adjustedMonth = max(1, min(month, 12))
        let dateComponents = DateComponents(year: currentYear, month: adjustedMonth)
        if let date = Calendar.current.date(from: dateComponents) {
            return dateFormatter.string(from: date)
        }
        return ""
    }

    // Function to generate content plan for the entire month
    func generateContentPlan() {
        let platforms = ["TikTok", "Instagram", "Both TikTok and Instagram"]
        let foodIdeas = [
            TaskHeading(title: "Recipe Tutorial", details: ["Explain the recipe step by step", "Show ingredients in detail"]),
            TaskHeading(title: "Street Food Review", details: ["Find popular street food places", "Interview vendors for insights"]),
            TaskHeading(title: "Cooking Tips", details: ["Share basic cooking hacks", "Demonstrate with visual examples"]),
            TaskHeading(title: "Viral Food Challenge", details: ["Attempt a trending food challenge", "Encourage audience participation"]),
            TaskHeading(title: "Healthy Meal Prep", details: ["Show how to prepare healthy meals", "Provide nutritional information"]),
            TaskHeading(title: "Behind-the-scenes Cooking", details: ["Show the cooking process", "Talk about challenges faced"]),
            TaskHeading(title: "Local Dish Highlight", details: ["Describe the history of the dish", "Show preparation in a traditional way"]),
            TaskHeading(title: "Quick Snack Ideas", details: ["Share 3-5 minute snack recipes", "Use common household ingredients"]),
            TaskHeading(title: "Cooking Myths", details: ["Bust popular cooking myths", "Provide scientific explanations"]),
            TaskHeading(title: "Seasonal Specialties", details: ["Showcase seasonal dishes", "Explain the importance of each ingredient"])
        ]

        var newPlan: [String: [Task]] = [:]
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)

        if let startOfMonth = Calendar.current.date(from: dateComponents),
           let monthRange = Calendar.current.range(of: .day, in: .month, for: startOfMonth) {

            for day in monthRange {
                if let date = Calendar.current.date(bySetting: .day, value: day, of: startOfMonth) {
                    let platform = platforms[(day - 1) % platforms.count]
                    let idea = foodIdeas[(day - 1) % foodIdeas.count]
                    var tasks: [Task] = []

                    // Define rush hours for TikTok and Instagram
                    let tiktokRushHours = ["9 AM", "11 AM", "1 PM", "3 PM", "5 PM", "7 PM"]
                    let instagramRushHours = ["10 AM", "12 PM", "2 PM", "4 PM", "6 PM", "8 PM"]

                    // Randomly select rush times for the platform
                    let selectedTikTokTime = tiktokRushHours.randomElement() ?? "9 AM"
                    let selectedInstagramTime = instagramRushHours.randomElement() ?? "10 AM"

                    if platform == "Both TikTok and Instagram" {
                        tasks.append(Task(platform: .tiktok, time: selectedTikTokTime, heading: idea, isUserAdded: false))
                        tasks.append(Task(platform: .instagram, time: selectedInstagramTime, heading: idea, isUserAdded: false))
                    } else if platform == "TikTok" {
                        tasks.append(Task(platform: .tiktok, time: selectedTikTokTime, heading: idea, isUserAdded: false))
                    } else {
                        tasks.append(Task(platform: .instagram, time: selectedInstagramTime, heading: idea, isUserAdded: false))
                    }

                    let dateKey = dateFormatter().string(from: date)
                    newPlan[dateKey] = tasks
                }
            }
        }

        contentPlan = newPlan
        saveContentPlan()
    }

    // Save content plan locally
    func saveContentPlan() {
        UserDefaults.standard.set(contentPlan.mapValues { $0.map { $0.content ?? "" } }, forKey: "contentPlan")
    }

    // Load tasks for the selected date
    func loadTasksForDate() {
        let dateKey = dateFormatter().string(from: selectedDate)
        tasksForSelectedDate = contentPlan[dateKey] ?? []
    }

    // Add new task to the selected date
    func addTask(_ task: Task, for date: Date) {
        let dateKey = dateFormatter().string(from: date)
        var updatedTask = task
        updatedTask.isUserAdded = true // Mark task as user-added
        if contentPlan[dateKey] != nil {
            contentPlan[dateKey]?.append(updatedTask)
        } else {
            contentPlan[dateKey] = [updatedTask]
        }
        saveContentPlan()
        loadTasksForDate()
    }

    // Delete a user-added task from the selected date
    func deleteTask(_ task: Task) {
        let dateKey = dateFormatter().string(from: selectedDate)
        contentPlan[dateKey]?.removeAll { $0.id == task.id && $0.isUserAdded }
        saveContentPlan()
        loadTasksForDate()
    }

    // Date formatter to convert Date to String and vice versa
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

// Calendar Day View with Oval Shape for Days and Consistent Spacing
struct CalendarDayView: View {
    var date: Date
    var isSelected: Bool
    var isToday: Bool
    var contentPlan: [String: [Task]]
    let calendar = Calendar.current

    var body: some View {
        VStack {
            if date != Date.distantPast {
                VStack {
                    Text("\(calendar.component(.day, from: date))")
                        .font(.headline)

                    let dateKey = formattedDateKey(date)
                    if let tasks = contentPlan[dateKey] {
                        let platforms = Array(Set(tasks.map { $0.platform }))
                        HStack {
                            ForEach(platforms, id: \.rawValue) { platform in
                                Image(platform.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 20)
                            }
                        }
                    }
                }
                .frame(width: 44, height: 75)
                .background(isToday ? Color.blue : (isSelected ? Color.purple : Color(UIColor.systemGray6)))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .foregroundColor(isToday || isSelected ? .white : .black)
            } else {
                Text("")
                    .frame(width: 55, height: 75)
            }
        }
    }

    // Helper function to convert Date to String
    func formattedDateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

// Task Sheet View for presenting tasks in a sheet with delete functionality for user-added tasks
struct TaskSheetView: View {
    var date: Date
    @Binding var tasks: [Task]
    var deleteTask: (Task) -> Void

    var body: some View {
        VStack {
            Text("Tasks for \(formattedDate(date))")
                .font(.headline)
                .padding()

            List {
                ForEach(tasks, id: \.self) { task in
                    HStack {
                        Image(task.platform.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding()

                        VStack(alignment: .leading) {
                            Text(task.heading.title)
                                .font(.headline)

                            if let content = task.content {
                                Text(content)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .padding(.top, 2)
                            }

                            ForEach(task.heading.details, id: \.self) { detail in
                                Text(detail)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }

                            Text("Scheduled at \(task.time)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let task = tasks[index]
                        if task.isUserAdded {
                            deleteTask(task)
                        }
                    }
                }
            }
        }
        .padding()
    }

    // Helper function to format date for the sheet title
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

// Updated AddTaskView to include Date and Time
struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTime: Date = Date()
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedPlatform: Task.Platform = .tiktok

    var selectedDate: Date // Add selected date parameter
    var onSave: (Task) -> Void

    let allPlatforms: [Task.Platform] = [.tiktok, .instagram]

    // Get the selected date as a formatted string
    private var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: selectedDate) // Use the passed selected date
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date")) {
                    // Display the selected date
                    Text(currentDate)
                        .font(.body)
                        .foregroundColor(.gray)
                }

                Section(header: Text("Select Time")) {
                    DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }

                Section(header: Text("Platform")) {
                    Picker("Select Platform", selection: $selectedPlatform) {
                        ForEach(allPlatforms, id: \.self) { platform in
                            Text(platform.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Title")) {
                    TextField("New Title", text: $title)
                }

                Section(header: Text("Description")) {
                    TextField("Task Description", text: $description)
                }
            }
            .navigationBarTitle("Add Task", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                let timeFormatter = DateFormatter()
                timeFormatter.timeStyle = .short
                let timeString = timeFormatter.string(from: selectedTime)

                let newTask = Task(
                    platform: selectedPlatform,
                    time: timeString,
                    content: description,
                    heading: TaskHeading(title: title, details: []),
                    isUserAdded: true
                )
                onSave(newTask)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct CalnderTask_Previews: PreviewProvider {
    static var previews: some View {
        CalnderTask()
    }
}
