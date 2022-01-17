// 类型标注辅助类型推断
var seed : [var Nat8] = [var 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,];

// 布尔型
Bool
// 自然数
Nat, Nat8, Nat16, Nat32, Nat64
// 整数
Int, Int8, Int16, Int32, Int64
// 浮点数
Float
// 字符串
Text
// 字符
Char

// 
Principal
// 
Blob
// 空集合
None
// 异步跑出的错误和异常
Error

// 组合类型：Reord 记录结构
let person = {
    name = "Jacky Chan";
    age = 67;
};
func f() : {name: Text; age: Nat} {
    person
}
// 特殊的记录结构，元组（tuple）是记录结构（record）的特殊形式
let x : (Int, Bool) = (10, false);
let y : Bool = x.1;

// 组合类型：Variant 枚举结构
type Gender = {
    #male;
    #female;
    #unspecified: {retire_age: Nat};
};
let person = {
    name = "Jacky Chan";
    age = 67;
    gender = #male;
};
func f() : {name: Text; age: Nat} {
    person;
}

// 模式匹配 Pattern match
switch (person.gender) {
    case (#male) (person.age >= 60);
    case (#female) (person.age >= 55);
    case (#unspecified({retire_age})) (person.age >= retire_age);
}

// Option 和 Result
func retired(person: Person) : ?Bool {
    switch (person.gender) {
        case (#male) ?(person.age >= 60);
        case (#female) ?(person.age >= 55);
        case (#unspecified) null;
    }
};
// Option类型 ?Bool, ?Nat
// Option的值 ?true, ?12, null

type Result<Ok, Err> = {
    #ok : Ok;
    #err : Err;
};
// import Result "mo:base/Result";
// type Result<R, E> = Result.Result<R, E>;

func retired(person : Person) : Result<Bool, Text> {
    switch (person.gender) {
        case (#male) #ok(person.age >= 60);
        case (#female) #ok(person.age >= 55);
        case (#unspecified) #err("Unknown");
    }
};
// Result类型 Result<R, E>
// Result的值 #ok(true), #err("Unknown")

// 函数
() -> Result<Bool, Text>;
() -> ();
// 命名函数定义
func dec(a: Int) : Int { a - 1 };
func inc(a: Nat) : Nat { a + 1 };
// 匿名函数定义
let dec : Int -> Int = func (a) { a - 1 };
let inc = func (a: Nat) : Nat { a + 1 };

// 高阶函数
// From "mo:base/Array"
// Initialize a mutable array with `size` copies of the initial value.
public func init<A>(size : Nat, initVal : A) : [var A] {
    Prim.Array_init<A>(size, initVal);
};
// Initialize an immutable array of the given size, and use the `gen` function to produce the initial value for every index.
public func tabulate<A>(size : Nat, gen : Nat -> A) : [var A] {
    Prim.Array_tabulate<A>(size, gen);
};

// arr = [var 42, 42, 42, 42, 42] : [var Int]
let arr = Array.init<Int>(5, 42);

// brr = [0, 1, 2, ..., 99] : [Nat]
let brr = Array.tabulate<Nat>(100, func (i) { i });

// crr = [0, 2, 4, ..., 198] : [Int]
let crr = Array.tabulate<Int>(100, func (i) { i * 2 });



// 对象
Object counter {
    var count = 0;
    public func inc() { count += 1 };
    public func read() : Nat { count };
    public func bump() : Nat {
        inc();
        read();
    };
};

type Counter = {
    inc: () -> ();
    read: () -> Nat;
    bump: () -> Nat;
};

let counter : Counter = object {
    var count = 0;
    public func inc() { count += 1 };
    public func read() : Nat { count };
    public func bump() : Nat {
        inc();
        read();
    };
};

let counter : Counter = do {
    var count = 0;
    let inc = func () { count += 1; };
    let read = func () : Nat { count };
    {
        inc = inc;
        read = read;
        bump = func () : Nat { inc(); read(); };
    }
};


// Actor 特殊的Object，在Motoko中支持异步调用，对应Canister
// 1. func必须是shared，返回值必须是async

actor Counter {
    var count = 0;
    public shared func inc() : async () { count += 1 };
    public shared func read() : async Nat { count };
    public shared func bump() : async Nat {
        count += 1;
        count;
    };
};
type Counter = actor {
    inc : shared () -> async ();
    read : shared () -> async Nat;
    bump : shared () -> async Nat;
}

actor Counter {
    var count = 0;
    public shared func inc() : async () { count += 1 };
    // 标注 query 为 query call，不标注默认为 update call
    public shared query func read() : async Nat { count };
    public shared func bump() : async Nat {
        await inc();
        await read();
    };
};
type Counter = actor {
    inc : shared () -> async ();
    read : shared query () -> async Nat;
    bump : shared () -> async Nat;
}
