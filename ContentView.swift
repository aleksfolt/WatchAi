import SwiftUI

struct ContentView: View {
    @StateObject private var chatService = ChatService()
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    
                    Button(action: chatService.clearChat) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 20, height: 20)
                    .offset(y: -25)
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(chatService.messages) { msg in
                        HStack {
                            if msg.sender == .user {
                                Spacer()
                                Text(msg.content)
                                    .padding(10)
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(10)
                            } else {
                                Text(msg.content)
                                    .padding(10)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .frame(minHeight: 100, maxHeight: 100)
            
            HStack (spacing: 0) {
                TextField("Type here...", text: $chatService.message)
                    .padding(.leading)
                    .padding(.trailing, 15)
                    .frame(height: 20)
                    .layoutPriority(1)
                
                
                Button(action: { chatService.sendMessage() }) {
                    Image(systemName: "arrow.up.right.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 35))
                        .frame(width: 20, height: 10)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
