//
//  ContentView.swift
//  FirebaseAnalyticsPractice
//
//  Created by Arjunan on 01/08/24.
//

import SwiftUI
import FirebaseCrashlytics

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                NavigationLink(destination: ContentView1()) {
                    Text("Hello, world!")
                }
                Button(action: {
                    AnalyticsManager.shared.logEvent(name: "TapMe")
                }, label: {
                    Text("Tap Me")
                })
            }
            .padding()
        }
        .onAppear {
            let count = 3
            AnalyticsManager.shared.logEvent(name: "ContentView")
        }
    }
}

#Preview {
    ContentView()
}

struct ContentView1: View {
    @State var isSelectIndex = []
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
//            Button("Crash") {
//                fatalError("Crash was triggered")
//            }
            NavigationLink(destination: ContentView2()) {
                Text("Hello, world!")
            }
        }
        .padding()
        .onAppear {
            AnalyticsManager.shared.logEvent(name: "ContentView1")
        }
    }
}

struct ContentView2: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            NavigationLink(destination: ContentView3()) {
                Text("Hello, world!")
            }
        }
        .padding()
        .onAppear {
            AnalyticsManager.shared.logEvent(name: "ContentView2")
        }
    }
}

struct ContentView3: View {
    @State var isShow: Bool = false
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                    .onTapGesture {
                        isShow = true
                    }
            }
            .padding()
            if isShow {
                BottomSheet()
            }
        }
        .onAppear {
            AnalyticsManager.shared.logEvent(name: "ContentView3")
        }
    }
}

struct BottomSheet: View {
    @Environment (\.dismiss) var dismiss
    @State private var offset = CGSize.zero
    @State private var heightOffset: CGFloat = 100
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Text("Drag")
                            .foregroundStyle(Color.black)
                        Spacer()
                        dragView
                        Spacer()
                        Image(systemName: "xmark")
                            .onTapGesture {
                               dismiss()
                            }
                    }
                    .padding(10)
                    ScrollView(showsIndicators: false) {
                        ForEach(0..<10,id: \.self) { _ in
                            HStack {
                                Text("Close")
                                Spacer()
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .background(Color.white)
                .frame(height: heightOffset)
            }
            .background(Color.clear)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    var dragView: some View {
        Image(systemName: "line.3.horizontal.decrease")
            .foregroundStyle(Color.black)
            .background(Color.white)
            .gesture(
                DragGesture()
                    .onChanged({ proxy in
                        print("proxy===>",proxy.translation.height)
                        offset = proxy.translation
                    })
                    .onEnded({ value in
                        DispatchQueue.main.async {
                            withAnimation(Animation.easeInOut(duration: 0.2)) {
                                if  offset.height < 0 {
                                    heightOffset -= offset.height
                                }else {
                                    heightOffset -= offset.height
                                }
                                offset = .zero
                            }
                        }
                    })
            )
    }
}

struct UiviewRep: UIViewRepresentable {

    func makeUIView(context: Context) -> some UIView {
        let view = UIStackView()
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.keyboardType = .default
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
        ])
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    class Coordinator: NSObject, UISearchBarDelegate {
        let parent: UiviewRep
        init(parent: UiviewRep) {
            self.parent = parent
        }
    }
}

#Preview{
    UiviewRep()
}
