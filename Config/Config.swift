import Foundation
import Toml

struct Config {
    let token: String
}

func loadConfig() -> Config? {
    guard let fileURL = Bundle.main.url(forResource: "config", withExtension: "toml") else {
        print("⚠️ Config файл не найден!")
        return nil
    }
    
    do {
        let toml = try Toml(contentsOfFile: fileURL.path)
        guard let token = toml.string("token") else {
            print("❌ Не удалось найти ключ token в config")
            return nil
        }
        return Config(token: token)
    } catch {
        print("❌ Ошибка загрузки или парсинга config: \(error)")
        return nil
    }
}
