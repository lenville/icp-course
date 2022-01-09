import Array "mo:base/Array";
import Int "mo:base/Int";

actor {
    func partition(arr: [var Int], lowIn: Int, highIn: Int) : Int {
        var low = Int.abs(lowIn);
        var high = Int.abs(highIn);

        let pivot = arr[low];


        while(low < high) {
            while(low < high and arr[high] >= pivot) {
                high -= 1;
            };

            arr[low] := arr[high];

            while(low < high and arr[low] <= pivot) {
                low += 1;
            };

            arr[high] := arr[low];
        };

        arr[low] := pivot;

        return low;
    };

    func quicksortHelper(arr: [var Int], lowIn: Int, highIn: Int) : [var Int] {
        var low = lowIn;
        var high = highIn;

        var result : [var Int]= arr;

        if (low < high) {
            let pivot = partition(arr, low, high);

            result := quicksortHelper(arr, low, pivot - 1);
            result := quicksortHelper(arr, pivot + 1, high);
        };

        return result;
    };

    func quicksort(arr: [Int]) : [Int] {
        // If the length of the array is less than 2, then return directly
        if (arr.size() < 2) {
            return arr
        };

        // Transform immutable array into mutable array
        var result : [var Int]= Array.thaw<Int>(arr);

        result := quicksortHelper(result, 0, result.size() - 1);

        // Transform mutable array into immutable array
        Array.freeze<Int>(result);
    };

    public func qsort(arr: [Int]): async [Int] {
        quicksort(arr);
    };
};
