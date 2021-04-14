//
//  Logging.swift
//  Einstein
//
//  Created by Adam Wulf on 4/14/21.
//

import Foundation
import SwiftyBeaver
import MMSwiftToolbox

class Logging: SwiftyBeaver {

    // MARK: - Private

    static private let log = Logging.self
    static private let PruneSince: TimeInterval = -21 * 24 * 60 * 60 // keep 3 weeks of logs available

    static private var LogDestination: URL {
        NSHomeDirectory()
        if let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            return url.appendingPathComponent("Logs")
        }
        fatalError("Cannot generate log file destination")
    }

    static private var CurrentLogFile: URL {
        // detect app vs sharing extension
        let context = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? "App"
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let dateStr = formatter.string(from: Date())
        try? FileManager.default.createDirectory(at: LogDestination, withIntermediateDirectories: true, attributes: nil)
        return LogDestination.appendingPathComponent("\(context)-\(dateStr).log")
    }

    // MARK: - Init

    static private var isInit = false
    static func initialize() {
        guard !isInit else { return }
        isInit = true

        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination(logFileURL: CurrentLogFile)  // log to default swiftybeaver.log file

        // use custom format and set console output to short time, log level & message
        console.format = "$DHH:mm:ss$d $L $M"

        // add the destinations to SwiftyBeaver
        log.addDestination(console)
        log.addDestination(file)

        log.info("log_setup", context: ["path": LogDestination.path])
    }

    static func pruneLogs() {
        DispatchQueue.global().async {
            if let contents = FileManager.default.enumerator(at: LogDestination, includingPropertiesForKeys: [.creationDateKey]) {
                for case let fileURL as URL in contents {
                    if
                        let resourceValues = try? fileURL.resourceValues(forKeys: Set<URLResourceKey>(arrayLiteral: .creationDateKey)),
                        let createdOn = resourceValues.creationDate,
                        createdOn.timeIntervalSinceNow < PruneSince {
                        try? FileManager.default.removeItem(at: fileURL)
                    }
                }
            }
        }
    }

    // MARK: - Log Methods

    override static func verbose(_ message: @autoclosure () -> Any,
                                _ file: String = #file,
                                _ function: String = #function,
                                line: Int = #line,
                                context: Any? = nil) {
        #if swift(>=5)
        logfmt(level: .verbose, message: message(), file: file, function: function, line: line, context: context)
        #else
        logfmt(level: .verbose, message: message, file: file, function: function, line: line, context: context)
        #endif
    }

    /// log something which help during debugging (low priority)
    override static func debug(_ message: @autoclosure () -> Any,
                              _ file: String = #file,
                              _ function: String = #function,
                              line: Int = #line,
                              context: Any? = nil) {
        #if swift(>=5)
        logfmt(level: .debug, message: message(), file: file, function: function, line: line, context: context)
        #else
        logfmt(level: .debug, message: message, file: file, function: function, line: line, context: context)
        #endif
    }

    /// log something which you are really interested but which is not an issue or error (normal priority)
    override static func info(_ message: @autoclosure () -> Any,
                             _ file: String = #file,
                             _ function: String = #function,
                             line: Int = #line,
                             context: Any? = nil) {
        #if swift(>=5)
        logfmt(level: .info, message: message(), file: file, function: function, line: line, context: context)
        #else
        logfmt(level: .info, message: message, file: file, function: function, line: line, context: context)
        #endif
    }

    /// log something which may cause big trouble soon (high priority)
    override static func warning(_ message: @autoclosure () -> Any,
                                _ file: String = #file,
                                _ function: String = #function,
                                line: Int = #line,
                                context: Any? = nil) {
        #if swift(>=5)
        logfmt(level: .warning, message: message(), file: file, function: function, line: line, context: context)
        #else
        logfmt(level: .warning, message: message, file: file, function: function, line: line, context: context)
        #endif
    }

    /// log something which will keep you awake at night (highest priority)
    override static func error(_ message: @autoclosure () -> Any,
                              _ file: String = #file,
                              _ function: String = #function,
                              line: Int = #line,
                              context: Any? = nil) {
        #if swift(>=5)
        logfmt(level: .error, message: message(), file: file, function: function, line: line, context: context)
        #else
        logfmt(level: .error, message: message, file: file, function: function, line: line, context: context)
        #endif
    }

    // MARK: - Logfmt Formatting

    static func format(object: PListCompatible, prefix: String = "") -> String {
        if let dict = object as? [String: PListCompatible] {
            let prefix = prefix.isEmpty ? "" : prefix + "."
            var ret = ""
            for key in dict.keys.sorted() {
                if let value = dict[key] {
                    ret += ret.isEmpty ? "" : " "
                    if let val2 = value as? [String: PListCompatible] {
                        ret += format(object: val2, prefix: prefix + key)
                    } else {
                        if
                            JSONSerialization.isValidJSONObject(value),
                            let data = try? JSONSerialization.data(withJSONObject: value, options: .sortedKeys),
                            let json = String(data: data, encoding: .utf8) {
                            let escaped = json.replacingOccurrences(of: "\"", with: "\\\"")
                            ret += "\(prefix + key)=\"\(escaped)\""
                        } else {
                            let formatted = format(object: value)
                            ret += "\(prefix + key)=\(formatted)"
                        }
                    }
                }
            }
            return ret
        } else {
            let str = String(describing: object).replacingOccurrences(of: "\n", with: " ")

            if str.contains(" ") || str.contains("\"") {
                return "\"" + str.replacingOccurrences(of: "\"", with: "\\\"") + "\""
            } else {
                return str
            }
        }
    }

    static func logfmt(level: SwiftyBeaver.Level,
                       message: @autoclosure () -> Any,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line,
                       context: Any? = nil) {
        if let context = context as? PListCompatible {
            let formatted = format(object: context)
            let message = "\(message()) \(formatted)"
            log.custom(level: level, message: message, file: file, function: function, line: line, context: nil)
        } else if context != nil {
            assertionFailure("context must be PListCompatible")
        } else {
            // evaluate the message immediately so that it doesn't end up
            // as a closure getting evaluated on a swifty-beaver background thread
            let message = "\(message())"
            log.custom(level: level, message: message, file: file, function: function, line: line, context: nil)
        }
    }
}
