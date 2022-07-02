//
//  CacheManager.swift
//  Profiles
//
//  Created by Егор Шкарин on 02.07.2022.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    //Наш кеш
    private let wrapped = NSCache<WrappedKey, Entry>()
    // Замыкание, которое формирует дату при инициалицации кеша. По умолчанию текущая дата
    private let dateProvider: () -> Date
    // Интервал через которых кеш удаляется
    private let entryLifetime: TimeInterval
    // ???
    private let keyTracker = KeyTracker()
    
    init(dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 12 * 60 * 60,
         maximumEntryCount: Int = 50) {
        //Добавляем время от которого отсчитывается жизненный цикл значения
        self.dateProvider = dateProvider
        // Время жизни значения
        self.entryLifetime = entryLifetime
        // Максимальное число записей
        wrapped.countLimit = maximumEntryCount
        // Делегат кеша
        wrapped.delegate = keyTracker
        
    }
    
    /// Функция вставки значения в кеш
    /// - value - Значние
    /// - key - ключ
    func insert(_ value: Value, forKey key: Key) {
        // Добавляем временной интервал к дате, которую указали в инициализаторе
        let date = dateProvider().addingTimeInterval(entryLifetime)
        // Создаем значение для кеша
        let entry = Entry(value: value, key: key, expirationDate: date)
        // Кладем значение в кеш по задонному ключу Key
        insert(entry)
    }
    
    /// Функция получения значения из кеша
    /// - key - ключ
    func value(forKey key: Key) -> Value? {
        // Получаем значение по ключу, если его нет возвращаем nil
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        // Сравниваем текущее время и время которе указано для значение
        // Если меньше то все ок, возвращаем значение, если больше то удаляем значение по ключу
        // и возвращаем nil
        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }
        return entry.value
    }
    /// Функция удаления значения из кеша
    /// - key - ключ
    func removeValue(forKey key: Key) {
        // Удаляем значение по ключу
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

private extension Cache {
    /// Класс для значний ключа в кеше
    // Наследуется от NSObject из за требований NSCache
    final class WrappedKey: NSObject {
        // Сам ключ, долже быть Hashable, так как он должен быть уникальным
        let key: Key
        
        init(_ key: Key) { self.key = key }
        
        override var hash: Int { return key.hashValue }
        // Эта перегрузка нудна чтобы мы могли сравнивать два значения по ключу
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }
}
extension Cache {
    /// Класс для значения в кеше.
    /// Хранить может что угодно
    final class Entry {
        // Ключ для значения в кеше
        let key: Key
        // Само значение
        let value: Value
        // Дата для удаление из кеша
        let expirationDate: Date
        
        init(value: Value, key: Key, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}

extension Cache {
    /// Сабскрипт для обращению к кешу в виде: cache[key]
    /// и такого же получения из него данных
    subscript(key: Key) -> Value? {
        get { return value(forKey: key)}
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            self.insert(value, forKey: key)
        }
    }
}

private extension Cache {
    // Класс для отслеживания клбючей значений
    // Он нужен для хранения значений в памяти устройтва, так как обычный кеш хранит все в оперативной памяти и при завершении приложения все чистит
    final class KeyTracker: NSObject, NSCacheDelegate {
        // массив ключей значений
        var keys = Set<Key>()
        // Функция, которая уведомляет NSCache каждый раз, когда что то было удалено из него
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
            guard let entry = obj as? Entry else {
                return
            }
            keys.remove(entry.key)
        }
    }
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}
extension Cache {
    //Эти методы нужны для того, чтобы делать вставку и удаление при кодировании и декодировании
    private func entry(forKey key: Key) -> Entry? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        
        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }
        
        return entry
    }
    
    private func insert(_ entry: Entry) {
        wrapped.setObject(entry, forKey: WrappedKey(entry.key))
        // Добаляем новый ключ в множество ключей в keyTraker
        keyTracker.keys.insert(entry.key)
    }
}
// Это расширение нужно для кодирования и декодирования занчений и ключей кеша
extension Cache: Codable where Key: Codable, Value: Codable {
    // Инициализатор для декодирования
    convenience init(from decoder: Decoder) throws {
        self.init()
        // Создание контенера для значений
        let container = try decoder.singleValueContainer()
        //        декодирование в массив [Entry]
        let entries = try container.decode([Entry].self)
        //        добавление в кеш значений
        entries.forEach(insert)
    }
    // Функция для кодирования
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
}
