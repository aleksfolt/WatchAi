import Foundation
import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let sender: Sender

    enum Sender {
        case user, ai
    }
}

struct ChatCompletionResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let message: APIMessage
}

struct APIMessage: Decodable {
    let role: String
    let content: String
}

class ChatService: ObservableObject {
    @Published var message: String = ""
    @Published var messages: [ChatMessage] = []
    private var token: String = ""
    
    init() {
        if let config = loadConfig() {
            token = config.token
        } else
        {
            print("Could not load config file")
        }
    }
    
    
    func sendMessage() {
        let trimmed = message.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        let userMsg = ChatMessage(content: trimmed, sender: .user)
        messages.append(userMsg)
        message = ""
        
        let placeholder = ChatMessage(content: "...", sender: .ai)
        messages.append(placeholder)
        let placeholderIndex = messages.count - 1
        
        sendToAPI(placeholderIndex: placeholderIndex)
    }
    
    func sendToAPI(placeholderIndex: Int) {
        guard let url = URL(string: "https://openrouter.ai/api/v1/chat/completions") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let apiMessages = messages.map { msg in
            [
                "role": msg.sender == .user ? "user" : "assistant",
                "content": msg.content
            ]
        }
        
        let jsonBody: [String: Any] = [
            "model": "google/gemini-2.0-flash-lite-preview-02-05:free",
            "messages": apiMessages
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
        } catch {
            print("Ошибка сериализации JSON: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка запроса: \(error)")
                return
            }
            
            guard let data = data else {
                print("Нет данных в ответе")
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
                if let reply = apiResponse.choices.first?.message.content {
                    DispatchQueue.main.async {
                        self.messages[placeholderIndex] = ChatMessage(content: reply, sender: .ai)
                    }
                } else {
                    print("Ответ от API пуст")
                }
            } catch {
                print("Ошибка декодирования: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response string: \(responseString)")
                }
            }
        }
        task.resume()
    }
    
    func clearChat() {
        messages.removeAll()
    }
}

