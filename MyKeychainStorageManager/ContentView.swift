//
//  ContentView.swift
//  MyKeychainStorageManager
//
//  Created by Hakob Ghlijyan on 27.03.2024.
//

import SwiftUI
import KeychainSwift

//MARK: - Defaults
struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, This Keychain Example")
        }
    }
}

#Preview {
    ContentView()
}

// ______________________________________________________________________________________

// evgenyneu/keychain-swift
//MARK: 1 - Use Environment for save password
/*
 struct ContentView: View {
     //MARK: 1 - Use Environment for save password
     @Environment(\.keychain) var keychain
     @State private var userPassword: String = ""

     var body: some View {
         VStack(spacing: 40.0) {
             Text(userPassword.isEmpty ? "No Password" : userPassword)
                 .font(.title2)
                 .foregroundStyle(userPassword.isEmpty ? .red : .green)
                 .fontWeight(userPassword.isEmpty ? .light : .bold)

             Button("Set User Password") {
                 let newPassword = "123"
 //                let newPassword = "abc"
                 keychain.set(newPassword, key: "user_password")
             }
             .buttonStyle(.borderedProminent)
         }
         .onAppear {
             userPassword = keychain.get(key: "user_password") ?? ""
         }
     }
 }

 #Preview {
     ContentView()
 }

 //MARK: - MANAGER
 final class KeychainManager {
     private let keychain: KeychainSwift
     
     init() {
         let keychain = KeychainSwift()
         keychain.synchronizable = true
         self.keychain = keychain
     }
     
     func set(_ value: String, key: String) {
         keychain.set(value, forKey: key)
     }

     func get(key: String) -> String? {
         keychain.get(key)
     }
 }

 //MARK: 1 - Use Environment for save password
 struct KeychainManagerKey: EnvironmentKey {
     static let defaultValue: KeychainManager = KeychainManager()
 }

 extension EnvironmentValues {
     var keychain: KeychainManager {
         get { self[KeychainManagerKey.self] }
         set { self[KeychainManagerKey.self] = newValue }
     }
 }
 */

// evgenyneu/keychain-swift
//MARK: 2 - Use @propertyWrapper KeychainStorage for save password
/*
 struct ContentView: View {
     //MARK: 2 - Use @propertyWrapper KeychainStorage for save password
     @KeychainStorage("user_password") var userPassword: String = ""
     
     var body: some View {
         VStack(spacing: 40.0) {
             Text(userPassword.isEmpty ? "No Password" : userPassword)
                 .font(.title2)
                 .foregroundStyle(userPassword.isEmpty ? .red : .green)
                 .fontWeight(userPassword.isEmpty ? .light : .bold)
             
             Button("Set User Password") {
 //                let newPassword = "456"
               let newPassword = "qwe"
                 
                 userPassword = newPassword
             }
             .buttonStyle(.borderedProminent)
         }
     }
 }

 #Preview {
     ContentView()
 }

 //MARK: - MANAGER
 final class KeychainManager {
     private let keychain: KeychainSwift
     
     init() {
         let keychain = KeychainSwift()
         keychain.synchronizable = true
         self.keychain = keychain
     }
     
     func set(_ value: String, key: String) {
         keychain.set(value, forKey: key)
     }

     func get(key: String) -> String? {
         keychain.get(key)
     }
 }

 //MARK: 2 - Use @propertyWrapper KeychainStorage for save password
 @propertyWrapper struct KeychainStorage: DynamicProperty {
     @State private var newValue: String
     let key: String
     let keychain: KeychainManager
     
     var wrappedValue: String {
         get { newValue }
         nonmutating set { save(newValue: newValue) }
     }
     
     var projectedValue: Binding<String> {
         Binding {
             wrappedValue
         } set: { newValue in
             wrappedValue = newValue
         }
     }
     
     init(wrappedValue: String, _ key: String) {
         self.key = key
         let keychain = KeychainManager()
         
         self.keychain = keychain
         newValue = keychain.get(key: key) ?? ""
         print("Load in File Manager: SUCCESS READ!")
     }

     func save(newValue: String) {
         keychain.set(newValue, key: key)
         self.newValue = newValue
         print("Save Success")
     }
 }
 */

// my HakobGhlijyn
//MARK: 3 - MY Use @propertyWrapper Keychain for save password
/*
 
 struct ContentView: View {
     
     @State private var password: String = ""
     @State private var savedPasswordStatus: String = ""
 
     @Keychain(key: "use_face_password", account: "LoginFaceIDApp") var storedPassword
 
     var body: some View {
         VStack {
             Text("Hello, This Keychain Example")
             TextField("Entre password...", text: $password)
                 .textFieldStyle(.roundedBorder)
                 .padding()
 
             Text(password)
                 .frame(height: 50)
             Button("SAVE") {
                 storedPassword = password.data(using: .utf8) ?? Data()
             }
 
             Text(savedPasswordStatus)
                 .frame(height: 50)
             Button("See Password") {
                 savedPasswordStatus = String(decoding: storedPassword ?? Data(), as: UTF8.self)
             }
         }
 
     }
     
     @State private var savedPasswordStatus: String = ""
     
     @Keychain(key: "use_face_password", account: "LoginFaceIDApp") var storedPassword
     
     var body: some View {
         VStack {
             Text("Hello, This Keychain Example")
                 .frame(height: 50)
             
             Button("SAVE") {
                 let password = "1234567890"
 //                let password = "qwertyuiop"
 //                let password = "asdfghjkl"
                 
                 storedPassword = password.data(using: .utf8) ?? Data()
             }
             
             Text("\(String(decoding: storedPassword ?? Data(), as: UTF8.self))")
                 .frame(height: 50)
         }
     }
 }

 #Preview {
     ContentView()
 }

 //MARK: - Keychain Helper class
 final class KeychainManagerStorage {
     //To Acess Class Data - SINGLTONE
     static let instance = KeychainManagerStorage()
     
     //MARK: - Save - data - my password
     func save(data: Data, key: String, account: String) {
         // Creating Query
         let query = [
             kSecValueData: data,
             kSecAttrAccount: account,
             kSecAttrService: key,
             kSecClass: kSecClassGenericPassword
         ] as CFDictionary
         
         // Adding Data to KeyChain
         let status = SecItemAdd(query, nil)
         
         // Checking for Status
         switch status {
             // For Success ->
         case errSecSuccess:
             print("Success SAVED!!!")
             // For DuplicateItem -> Updating Data
         case errSecDuplicateItem:
             let updateQuery = [
                 kSecValueData: data,
                 kSecAttrAccount: account,
                 kSecAttrService: key,
                 kSecClass: kSecClassGenericPassword
             ] as CFDictionary
             // Update filed
             let updateAttr = [kSecValueData: data] as CFDictionary
             SecItemUpdate(updateQuery, updateAttr)
             // For Error ->
         default:
             print("Error \(status)")
         }
     }
     
     //MARK: - Get - Reading Keychain data
     func read(key: String, account: String) -> Data? {
         // Creating Query
         let readingQuery = [
             kSecAttrAccount: account,
             kSecAttrService: key,
             kSecClass: kSecClassGenericPassword,
             kSecReturnData: true
         ] as CFDictionary
         
         // To copy the data
         var resultData: AnyObject?
         
         let status = SecItemCopyMatching(readingQuery, &resultData)
         
         switch status {
         case errSecSuccess:
             print("Success Data Read!!!")
         default:
             print("Error \(status)")
         }
         
         return resultData as? Data
     }
     
     //MARK: - Delete in Keychain data
     func delete(key: String, account: String) {
         // Creating Query
         let deletedQuery = [
             kSecAttrAccount: account,
             kSecAttrService: key,
             kSecClass: kSecClassGenericPassword,
             kSecReturnData: true
         ] as CFDictionary
         
         //Delete for data
         SecItemDelete(deletedQuery)
     }
 }

 //MARK: - Custom Wraper for Keychain
 // for easy to use
 @propertyWrapper struct Keychain: DynamicProperty {
     
     @State var data: Data?

     init(key: String, account: String) {
         self.key = key
         self.account = account
         
         // Setting Intial State Keychain Data
         // init state data - read
         // Установка данных связки ключей начального состояния
         // Данные состояния инициализации - чтение
         _data = State(wrappedValue: KeychainManagerStorage.instance.read(key: key, account: account) )
     }
     
     var key: String
     var account: String
     
     //1
     /*
      var wrappedValue: Data? {
          get { data }
          nonmutating set {
              // guard
              guard let newData = newValue else {
                  // if we set data to nil...
                  // Simple delete the the Keychain data
                  // если мы установим значение data равным нулю...
                  // Просто удалите данные из связки ключей
                  data = nil
                  KeychainHelper.instance.delete(key: key, account: account)
                  return
              }
              //Updating or Setting KeyChain Data
              KeychainHelper.instance.save(data: newData, key: key, account: account)
          }
      }
      */
     //2
     var wrappedValue: Data? {
         get { KeychainManagerStorage.instance.read(key: key, account: account) }
         nonmutating set {
             // guard
             guard let newData = newValue else {
                 // if we set data to nil...
                 // Simple delete the the Keychain data
                 // если мы установим значение data равным нулю...
                 // Просто удалите данные из связки ключей
                 data = nil
                 KeychainManagerStorage.instance.delete(key: key, account: account)
                 return
             }
             //Updating or Setting KeyChain Data
             KeychainManagerStorage.instance.save(data: newData, key: key, account: account)
          
             // Updating Data
             data = newValue
         }
     }
     
     var projectedValue: Binding<Data?> {
         Binding {
             wrappedValue
         } set: { newValue in
             wrappedValue = newValue
         }

     }
 }
 
 */

//  ______________________________________________________________________________________

// evgenyneu/keychain-swift
/*

 https://github.com/evgenyneu/keychain-swift
 
 https://github.com/evgenyneu/keychain-swift.git
 
 Keychian for Git repo
 Keychian Helper -> @propertyWrapper Keychain DynamicProperty
 
 //MARK: - MANAGER
 final class KeychainManager {
     private let keychain: KeychainSwift
     
     init() {
         let keychain = KeychainSwift()
         keychain.synchronizable = true
         self.keychain = keychain
     }
     
     func set(_ value: String, key: String) {
         keychain.set(value, forKey: key)
     }
 
     func get(key: String) -> String? {
         keychain.get(key)
     }
 }

 //MARK: 1 - Use Environment for save password
 struct KeychainManagerKey: EnvironmentKey {
     static let defaultValue: KeychainManager = KeychainManager()
 }

 extension EnvironmentValues {
     var keychain: KeychainManager {
         get { self[KeychainManagerKey.self] }
         set { self[KeychainManagerKey.self] = newValue }
     }
 }

 //MARK: 2 - Use @propertyWrapper KeychainStorage for save password
 @propertyWrapper struct KeychainStorage: DynamicProperty {
     @State private var newValue: String
     let key: String
     let keychain: KeychainManager
     
     var wrappedValue: String {
         get { newValue }
         nonmutating set { save(newValue: newValue) }
     }
     
     var projectedValue: Binding<String> {
         Binding {
             wrappedValue
         } set: { newValue in
             wrappedValue = newValue
         }
     }
     
     init(wrappedValue: String, _ key: String) {
         self.key = key
         let keychain = KeychainManager()
         
         self.keychain = keychain
         newValue = keychain.get(key: key) ?? ""
         print("Load in File Manager: SUCCESS READ!")
     }

     func save(newValue: String) {
         keychain.set(newValue, key: key)
         self.newValue = newValue
         print("Save Success")
     }
 }

 struct Lesson03KeychainSwift: View {
     
     //MARK: 1 - Use Environment for save password
     @Environment(\.keychain) var keychain
     @State private var userPassword: String = ""

     var body: some View {
         VStack(spacing: 40.0) {
             Text(userPassword.isEmpty ? "No Password" : userPassword)
                 .font(.title2)
                 .foregroundStyle(userPassword.isEmpty ? .red : .green)
                 .fontWeight(userPassword.isEmpty ? .light : .bold)

             Button("Set User Password") {
                 let newPassword = "123"
 //                let newPassword = "abc"
                 keychain.set(newPassword, key: "user_password")
             }
             .buttonStyle(.borderedProminent)
         }
         .onAppear {
             userPassword = keychain.get(key: "user_password") ?? ""
         }
     }
     
     //MARK: 2 - Use @propertyWrapper KeychainStorage for save password
     @KeychainStorage("user_password") var userPassword: String = ""
     
     var body: some View {
         VStack(spacing: 40.0) {
             Text(userPassword.isEmpty ? "No Password" : userPassword)
                 .font(.title2)
                 .foregroundStyle(userPassword.isEmpty ? .red : .green)
                 .fontWeight(userPassword.isEmpty ? .light : .bold)
             
             Button("Set User Password") {
 //                let newPassword = "456"
               let newPassword = "qwe"
                 
                 userPassword = newPassword
             }
             .buttonStyle(.borderedProminent)
         }
     }
     
 }
 */

//My Keychian
/*
 
 My Keychian
 Keychian Helper -> @propertyWrapper Keychain DynamicProperty
 
 
 -------------------------------------------------------------------------------------------------------------
 
 example...
 
 -------------------------------------------------------------------------------------------------------------
 
 //MARK: - FaceID Keychain Properties
 @Keychain(key: "use_face_email", account: "LoginFaceIDApp") var storedEmail                         
 // Use THIS Keychain ...
 @Keychain(key: "use_face_password", account: "LoginFaceIDApp") var storedPassword                 
 // Use THIS Keychain ...
 
 
 -------------------------------------------------------------------------------------------------------------
 
 //MARK: - Keychain Helper class

 final class KeychainHelper {
     
     //To Acess Class Data - SINGLTONE
     static let instance = KeychainHelper()
     
     //MARK: - Save - data - my password
     func save(data: Data, key: String, account: String) {
         // Creating Query
         let query = [
             kSecValueData: data,
             kSecAttrAccount: account,
             kSecAttrService: key,
             kSecClass: kSecClassGenericPassword
         ] as CFDictionary
         
         // Adding Data to KeyChain
         let status = SecItemAdd(query, nil)
         
         // Checking for Status
         switch status {
             // For Success ->
         case errSecSuccess:
             print("Success SAVED!!!")
             // For DuplicateItem -> Updating Data
         case errSecDuplicateItem:
             let updateQuery = [
                 kSecValueData: data,
                 kSecAttrAccount: account,
                 kSecAttrService: key,
                 kSecClass: kSecClassGenericPassword
             ] as CFDictionary
             // Update filed
             let updateAttr = [kSecValueData: data] as CFDictionary
             SecItemUpdate(updateQuery, updateAttr)
             // For Error ->
         default:
             print("Error \(status)")
         }
     }
     
     //MARK: - Get - Reading Keychain data
     func read(key: String, account: String)  -> Data? {
         // Creating Query
         let readingQuery = [
             kSecAttrAccount: account,
             kSecAttrService: key,
             kSecClass: kSecClassGenericPassword,
             kSecReturnData: true
         ] as CFDictionary
         
         // To copy the data
         var resultData: AnyObject?
         
         let status = SecItemCopyMatching(readingQuery, &resultData)
         
         switch status {
         case errSecSuccess:
             print("Success Data Read!!!")
         default:
             print("Error \(status)")
         }
         
         return resultData as? Data
     }
     
     //MARK: - Delete in Keychain data
     func delete(key: String, account: String) {
         // Creating Query
         let deletedQuery = [
             kSecAttrAccount: account,
             kSecAttrService: key,
             kSecClass: kSecClassGenericPassword,
             kSecReturnData: true
         ] as CFDictionary
         
         //Delete for data
         SecItemDelete(deletedQuery)
     }
 }

 
 -------------------------------------------------------------------------------------------------------------
 
 //MARK: - Custom Wraper for Keychain
 // for easy to use

 @propertyWrapper struct Keychain: DynamicProperty {
     
     @State var data: Data?

     init(key: String, account: String) {
         self.key = key
         self.account = account
         
         // Setting Intial State Keychain Data
         // init state data - read
         // Установка данных связки ключей начального состояния
         // Данные состояния инициализации - чтение
         _data = State(wrappedValue: KeychainHelper.instance.read(key: key, account: account) )
     }
     
     var key: String
     var account: String
     
     //1
     /*
      var wrappedValue: Data? {
          get { data }
          nonmutating set {
              // guard
              guard let newData = newValue else {
                  // if we set data to nil...
                  // Simple delete the the Keychain data
                  // если мы установим значение data равным нулю...
                  // Просто удалите данные из связки ключей
                  data = nil
                  KeychainHelper.instance.delete(key: key, account: account)
                  return
              }
              //Updating or Setting KeyChain Data
              KeychainHelper.instance.save(data: newData, key: key, account: account)
          }
      }
      */
     //2
     var wrappedValue: Data? {
         get { KeychainHelper.instance.read(key: key, account: account) }
         nonmutating set {
             // guard
             guard let newData = newValue else {
                 // if we set data to nil...
                 // Simple delete the the Keychain data
                 // если мы установим значение data равным нулю...
                 // Просто удалите данные из связки ключей
                 data = nil
                 KeychainHelper.instance.delete(key: key, account: account)
                 return
             }
             //Updating or Setting KeyChain Data
             KeychainHelper.instance.save(data: newData, key: key, account: account)
          
             // Updating Data
             data = newValue
         }
     }
     
     var projectedValue: Binding<Data?> {
         Binding {
             wrappedValue
         } set: { newValue in
             wrappedValue = newValue
         }

     }
 }

 -------------------------------------------------------------------------------------------------------------
 
 */
