//
//  HomeView.swift
//  Peter011_1
//
//  Created by DONG SHENG on 2022/7/3.
//

// 問題1: 元件 Stepper 小於範圍還是可以多點擊 2次 (bug)
// 問題2: 當 dooog 使用同一個陣列 判斷>10之後 remove 或 直接重設  再使用.insert都會失效 (因此>10後改為使用不同陣列)

// 內容:
// 臘腸狗 初始會有 3張圖片 頭、身體、尾  (點擊 +號 身體會增加 頭尾不變)
// 圖片利用陣列顯示   [頭、身體、尾] -> ["Image1","Image2","Image3"]
// Ex: [頭、身體、身體、身體、身體、身體、尾] -> ["Image1","Image2","Image2","Image2","Image2","Image2","Image3"]


import SwiftUI

class HomeViewModel: ObservableObject{
    
    @Published var dooog1: [String] = [
        "Image1" , "Image2" , "Image3"
    ]
    @Published var dooog2: [String] = [
        "Image1" , "Image2" , "Image3"
    ]
    @Published var dooog3: [String] = [
        "Image1" , "Image2" , "Image3"
    ]
    @Published var dooog4: [String] = [
        "Image1" , "Image2" , "Image3"
    ]
    @Published var dooog5: [String] = [
        "Image1" , "Image2" , "Image3"
    ]
    
    @Published var bodyAmount = 1 {
        // 追蹤數量變化 依據條件 更改背景圖片
        didSet {
            if bodyAmount < 11{
                self.backgroundView = "Background1"
            } else if bodyAmount < 21 {
                self.backgroundView = "Background2"
            } else if bodyAmount < 31 {
                self.backgroundView = "Background3"
            } else if bodyAmount < 41 {
                self.backgroundView = "Background4"
            } else if bodyAmount < 51 {
                self.backgroundView = "Background5"
            } else {
                withAnimation(.easeInOut){
                    self.showUFO = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.gameOver()
                }
            }
        }
    }
    @Published var backgroundView: String = "Background1"
    
    @Published var showUFO: Bool = false
    @Published var gameIsOver: Bool = false
    
    
    //
    func addBody(){
        self.bodyAmount += 1
        
        guard bodyAmount > 11 else {
            self.dooog1.insert(contentsOf: ["Image2","Image2","Image2","Image2","Image2"], at: 1) // [0] -> 頭 所以從1加入
            return
        }
        
        guard bodyAmount > 21 else {
            self.dooog2.insert(contentsOf: ["Image2","Image2","Image2","Image2","Image2"], at: 1)
            return
        }

        guard bodyAmount > 31 else {
            self.dooog3.insert(contentsOf: ["Image2","Image2","Image2","Image2","Image2"], at: 1)
            return
        }
      
        guard bodyAmount > 41 else {
            self.dooog4.insert(contentsOf: ["Image2","Image2","Image2","Image2","Image2"], at: 1)
            return
        }
        
        self.dooog5.insert(contentsOf: ["Image2","Image2","Image2","Image2","Image2"], at: 1)
    }
    
    func minusBody(){
        self.bodyAmount -= 1

        guard bodyAmount > 10 else {
            self.dooog1.removeSubrange(1...5)
            return
        }
        
        guard bodyAmount > 20 else {
            self.dooog2.removeSubrange(1...5)
            return
        }
        
        guard bodyAmount > 30 else {
            self.dooog3.removeSubrange(1...5)
            return
        }

        guard bodyAmount > 40 else {
            self.dooog4.removeSubrange(1...5)
            return
        }
        self.dooog5.removeSubrange(1...5)
    }
    
    func gameOver(){
            self.gameIsOver = true
    }
    
    func reset(){
        self.gameIsOver = false
        self.showUFO = false
        self.dooog1 = ["Image1" , "Image2" , "Image3"]
        self.dooog2 = ["Image1" , "Image2" , "Image3"]
        self.dooog3 = ["Image1" , "Image2" , "Image3"]
        self.dooog4 = ["Image1" , "Image2" , "Image3"]
        self.dooog5 = ["Image1" , "Image2" , "Image3"]
        self.bodyAmount = 1
    }
    
}

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack{
            BackgroundView
            DogView
            InformationView
            
            if viewModel.gameIsOver{
               GameOverView
            }
        }
        .overlay(
            Image("UFO")
                .resizable()
                .scaledToFit()
                .opacity(viewModel.showUFO ? 1 : 0)
                .frame(width: 230)
                .position(x: viewModel.showUFO ? UIScreen.main.bounds.width / 2 : UIScreen.main.bounds.width, y: 0)
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
.previewInterfaceOrientation(.landscapeLeft)
    }
}

extension HomeView{
    
    private var BackgroundView: some View{
        Image(viewModel.backgroundView)
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
    }
    
    private var DogView: some View{
        // 底下補充 原本排法
        HStack(spacing: -2){
            // 根據 bodyAmount 來告訴 ForEach 使用的陣列
            ForEach(viewModel.bodyAmount <= 10 ? viewModel.dooog1 : viewModel.bodyAmount < 21 ? viewModel.dooog2 : viewModel.bodyAmount < 31 ? viewModel.dooog3 : viewModel.bodyAmount < 41 ? viewModel.dooog4 : viewModel.dooog5  ,id: \.self){
                // 三元運算 讓 圖片的位置及大小做調整
                // 根據陣列中 是頭尾還是 Body 做判斷 也可以 把頭尾拆開來寫
                Image($0)
                    .resizable()
                    .frame(width: $0 == "Image2" ? 10 : $0 == "Image1" ? 200 : 100, height: $0 == "Image2" ? 57 : $0 == "Image1" ? 150 : 82)
                    .offset(y: $0 == "Image2" ? 20 : $0 == "Image1" ? 0 : 32.5)
            }
        }
        .offset(y: viewModel.showUFO ? -300 : 70)
        .scaleEffect(viewModel.showUFO ? 0.2 : 1)
        .rotationEffect(Angle(degrees: viewModel.showUFO ? 0 : 720))
    }
    
    private var InformationView: some View{
        VStack {
            VStack(spacing: 6){
                Text("訂製你的專屬臘腸狗")
                    .font(.headline.bold())
                
                Text("$ : \(viewModel.bodyAmount * 5000)")
                    .font(.headline.bold())
                    .foregroundColor(.pink)
                
                // 元件有個小Bug 當值不能再減時 減的按鈕還能多點2次 才不能點擊
                Stepper("🍖🍖") {
                    viewModel.addBody()
                } onDecrement: {
                    guard self.viewModel.bodyAmount > 1 else { return }
                    viewModel.minusBody()
                }
                .padding(.horizontal ,160)
                
                Button {
                    viewModel.gameIsOver = true
                } label: {
                    Image("Button1")
                        .resizable()
                        .frame(width: 80, height: 60)
                }
                .disabled(viewModel.showUFO)
            }
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .frame(width: 500, height: 180)
            
            
            Spacer()
        }
        .padding(.top ,10)
        
    }
    
    private var GameOverView: some View {
        VStack{
            Spacer()
            
            Text(viewModel.showUFO ? "已經被外星人抓去研究了 👽" :"您的專屬臘腸狗價格是")
                .font(.title)
            Spacer()
            
            Text("$ \(viewModel.bodyAmount * 5000)")
                .font(.largeTitle.bold())
                .foregroundColor(.pink)
                .opacity(viewModel.showUFO ? 0 : 1)
            
            Spacer()
            
            Button {
                viewModel.reset()
            } label: {
                Image("Button2")
                    .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            }
      
            
        }
        .padding()
        .frame(width: 600, height: 300)
        .background(.white.opacity(0.3))
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}



// MARK: 補充
// 補充 還沒用 ForEach 的 初始排法
/*
 HStack(spacing: -2){
        
     Image("Image1")
         .resizable()
         .frame(width: 200, height: 150)
     Image("Image2")
         .resizable()
         .frame(width: 10, height: 57)
         .offset(y: 20)
     Image("Image2")
         .resizable()
         .frame(width: 10, height: 57)
         .offset(y: 20)
     
     Image("Image2")
         .resizable()
         .frame(width: 10, height: 57)
         .offset(y: 20)

     Image("Image2")
         .resizable()
         .frame(width: 10, height: 57)
         .offset(y: 20)
     Image("Image2")
         .resizable()
         .frame(width: 10, height: 57)
         .offset(y: 20)
     
     Image("Image2")
         .resizable()
         .frame(width: 10, height: 57)
         .offset(y: 20)

     
     Image("Image3")
         .resizable()
         .frame(width: 100, height: 82)
         .offset(y: 32.5)
 }
 */
