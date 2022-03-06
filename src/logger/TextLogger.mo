import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Deque "mo:base/Deque";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

import Logger "mo:ic-logger/Logger";

module {
  public class TextLogger() {
    var state : Logger.State<Text> = Logger.new<Text>(0, null);
    let logger = Logger.Logger<Text>(state);

    public func append(msgs: [Text]) {
      logger.append(msgs);
    };

    public func stats() : async Logger.Stats {
      logger.stats()
    };

    public func view(from: Nat, to: Nat) : async Logger.View<Text> {
      logger.view(from, to)
    };

    public func pop_buckets(num: Nat) {
      logger.pop_buckets(num)
    };

    public func getSize() : async Nat {
      logger.stats().bucket_sizes[0];
    };
  }
};

// shared(msg) actor class TextLogger() {
//   stable var state : Logger.State<Text> = Logger.new<Text>(0, null);
//   let logger = Logger.Logger<Text>(state);

//   public shared (msg) func append(msgs: [Text]) {
//     logger.append(msgs);
//   };

//   public query func stats() : async Logger.Stats {
//     logger.stats()
//   };

//   public shared query (msg) func view(from: Nat, to: Nat) : async Logger.View<Text> {
//     logger.view(from, to)
//   };

//   public shared (msg) func pop_buckets(num: Nat) {
//     logger.pop_buckets(num)
//   };

//   public shared query func getSize() : async Nat {
//     logger.stats().bucket_sizes[0];
//   };
// }
