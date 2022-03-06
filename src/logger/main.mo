import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Deque "mo:base/Deque";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Option "mo:base/Option";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

import Logger "mo:ic-logger/Logger";

shared (msg) actor class TextLogger() {
  let n = 5;
  var loggers : List.List<Logger.Logger<Text>> = List.nil();

  func generate_logger() : Logger.Logger<Text> {
    var state : Logger.State<Text> = Logger.new<Text>(0, null);
    let logger = Logger.Logger<Text>(state);
    loggers := List.push(logger, loggers);
    loggers := List.reverse(loggers);
    return logger;
  };

  // Add a set of messages to the log.
  public shared (msg) func append(msgs: [Text]) {
    for (i in Iter.range(0, msgs.size() - 1)) {
      var logger : Logger.Logger<Text> =
        switch(List.last(loggers)) {
          case null generate_logger();
          case (?logger) logger;
        };

      let view = logger.view(0, n);
          
      if (view.messages.size() >= n) {
        logger := generate_logger();            
      };
      
      logger.append([msgs[i]]);
    }
  };

  // Return the messages between from and to indice (inclusive).
  public shared query (msg) func view(from: Nat, to: Nat) : async Logger.View<Text> {
    // let result : [var Logger.View<Text>] = [var];
    var state : Logger.State<Text> = Logger.new<Text>(0, null);
    let result = Logger.Logger<Text>(state);
    let start_index = from / n;
    let end_index = to / n;

    for (i in Iter.range(from, to)) {
      let logger_index = i / n;
      let offset = i % n;

      switch(List.get(loggers, logger_index)) {
        case null ();
        case (?logger) {
          let view = logger.view(
            offset,
            offset
          );

          result.append(view.messages);
        }
      };
    };

    return result.view(0, to - from);
  };
}
