//
//  ContentView.swift
//  FluidProgressDemo
//
//  Created by Dixit Rathod on 18/08/24.
//

import SwiftUI

struct ContentView: View {
    @State private var touchLocation: CGPoint = CGPoint(x: 30, y: 0)
    @State private var isDragging = false
    @State private var progress: CGFloat = 0
    let progressBarColor = Color.white
    let horizontalPadding: CGFloat = 30
    let thumbColor = Color.teal

    var body: some View {
        ZStack {
            Color.teal
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { bounds in
                ZStack {
                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(min: 0.5, color: progressBarColor))
                        context.addFilter(.blur(radius: 5))
                        
                        context.drawLayer { ctx in
                            let progressBar = ctx.resolveSymbol(id: 0)!
                            ctx.draw(progressBar, at: .zero, anchor: .topLeading)
                            
                            let thumb = ctx.resolveSymbol(id: 1)!
                            ctx.draw(thumb, at: .zero, anchor: .topLeading)
                            
                            if let infoView = ctx.resolveSymbol(id: 2) {
                                ctx.draw(infoView, at: .zero, anchor: .topLeading)
                                
                            }
                        }
                    } symbols: {
                        RoundedRectangle(cornerRadius: 5)
                            .padding(.horizontal, 20)
                            .frame(height: 10)
                            .offset(y: bounds.size.height - 25)
                            .tag(0)

                        Circle()
                            .frame(width: 40, height: 40)
                            .position(touchLocation)
                            .offset(y: bounds.size.height - 20)
                            .tag(1)
                        
                        RoundedRectangle(cornerRadius: isDragging ? 5 : 15.0)
                            .frame(width: isDragging ? 50 : 30, height: isDragging ? 40 : 30)
                            .position(touchLocation)
                            .offset(y: isDragging ? bounds.size.height - 70 : bounds.size.height - 20)
                            .animation(.bouncy, value: isDragging)
                            .animation(.bouncy(duration: 0.15), value: touchLocation)
                            .tag(2)
                    }
                    
                    Circle()
                        .fill(thumbColor)
                        .frame(width: 30, height: 30)
                        .position(touchLocation)
                        .offset(y: bounds.size.height - 20)
                        .tag(1)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(thumbColor.opacity(0.2))
                        .frame(width: 35, height: 25)
                        
                        .overlay {
                            Text("\(Int(progress))")
                                .foregroundColor(thumbColor)
                                .font(.system(size: 16, weight: .bold, design: .serif))
                                .animation(.none, value: progress)
                        }
                        .position(touchLocation)
                        .opacity(isDragging ? 1 : 0)
                        .offset(y: isDragging ? bounds.size.height - 70 : bounds.size.height - 20)
                        .animation(.bouncy, value: isDragging)
                        .animation(.bouncy(duration: 0.15), value: touchLocation)
                }
                .frame(height: bounds.size.height)
                .gesture(DragGesture().onChanged({ gesture in
                    isDragging = true
                    touchLocation = CGPoint(x: min(max(gesture.location.x, horizontalPadding), (bounds.size.width - horizontalPadding)), y: 0)
                    progress = ((touchLocation.x - horizontalPadding)/(bounds.size.width-(horizontalPadding*2))) * 100
                }).onEnded({ gesture in
                    isDragging = false
                }))
            }
            .frame(height: 100)
        }
        
        
    }
}

#Preview {
    ContentView()
}
