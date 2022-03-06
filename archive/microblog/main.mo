import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Option "mo:base/Option";

actor {
    // 实例 Microblog
    public type Message = {
        time : Time.Time;
        content : Text;
        author : Text;
    };

    public type Microblog = actor {
        follow : shared (Principal) -> async (); // 添加关注对象
        follows : shared query () -> async [Principal]; // 返回关注列表
        post : shared (Text) -> async (); // 发布新消息
        posts : shared query (Time.Time) -> async [Message]; // 返回所有发布的消息
        timeline : shared (Time.Time) -> async [Message]; // 返回所有关注对象发布的消息
        fetchPosts : shared (Text) -> async [Message]; // 返回所有关注对象发布的消息
        set_name: shared (Text) -> async (); // 修改作者名字
        get_name: shared () -> async Text; // 获取作者名字
    };
    // 每个canister代表一个用户
    // canister可以通过canister id相互关注

    stable var author : Text = "Zhentao Liu (lenville@gmail.com)";

    public shared func set_name(name: Text) : async () {
        author := name;
    };

    public shared func get_name() : async Text {
        author;
    };

    // 使用 stable 来指定升级时不想被清掉的内存数据
    // stable var followed : List.List<Principal> = List.nil();
    stable var followed : List.List<Principal> = List.nil();

    public shared func follow(id: Principal) : async () {
        followed := List.push(id, followed);
    };

    public shared query func follows() : async [Principal] {
        List.toArray(followed)
    };

    stable var messages : List.List<Message> = List.nil();

    public shared func post(text: Text) : async () {
        let author = await get_name();
        let message = {
            time = Time.now();
            content = text;
            author = author;
        };

        messages := List.push(message, messages);
    };

    public shared query func posts(since: Time.Time) : async [Message] {
        // filter out all the messages which were posted great than or equal to "since" 
        let filtered : List.List<Message> = List.filter(messages,
            func (message : Message) : Bool { message.time >= since });
        
        List.toArray(filtered);
    };

    public shared func timeline(since: Time.Time) : async [Message] {
        var all : List.List<Message> = List.nil();

        for (id in Iter.fromList(followed)) {
            let canister : Microblog = actor(Principal.toText(id));
            let msgs = await canister.posts(since);
            for (msg in Iter.fromArray(msgs)) {
                all := List.push(msg, all);
            }
        };
        List.toArray(all)
    };

    public shared func fetchPosts(canisterId : Text) : async [Message] {
        var all : List.List<Message> = List.nil();

        let canister : Microblog = actor(canisterId);
        let msgs = await canister.posts(0);
        for (msg in Iter.fromArray(msgs)) {
            all := List.push(msg, all);
        };

        List.toArray(all)
    };
}