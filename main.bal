import ballerina/lang.array;
import ballerina/io;

public class Node {
    int freq;
    string:Char? char;

    Node? left;
    Node? right;

    function init() {
        self.freq = 0;
        self.char = null;
        self.left = null;
        self.right = null;
    }
}

function getCodes(Node root, string s, map<string> codes) returns map<string> {
    if (root.left == null && root.right == null && root.char != null) {
        codes[<string:Char>root.char] = s;
        return codes;
    }

    _ = getCodes(<Node>root.left, s + "0", codes);
    _ = getCodes(<Node>root.right, s + "1", codes);

    return codes;
}

function strToFreqMap(string data) returns map<int> {
    map<int> freqMap = {};
    foreach string:Char char in data {
        if (freqMap.hasKey(char)) {
            freqMap[char] = <int>(freqMap[char] + 1);
        } else {
            freqMap[char] = 1;
        }
    }

    return freqMap;
}

function getEncodedBitStr(string data, map<string> codes) returns string {
    string bitStr = "";
    foreach string:Char char in data {
        bitStr += <string>codes[char];
    }

    return bitStr;
}

public class HuffmanPriorityQueue {
    Node[] nodes;

    function init() {
        self.nodes = [];
    }

    public function add(Node node) {
        self.nodes.push(node);
        self.nodes = self.nodes.sort(array:ASCENDING, isolated function(Node n) returns int => n.freq);
    }
}

public function main() returns error? {

    string data = "AAABCCAB";

    map<int> charFreqMap = strToFreqMap(data);

    HuffmanPriorityQueue queue = new HuffmanPriorityQueue();

    map<[string, int]> entries = charFreqMap.entries();
    foreach [string, int] entry in entries {
        Node node = new Node();
        node.char = <string:Char?>entry[0];
        node.freq = entry[1];

        queue.add(node);
    }

    Node? root = null;

    while (queue.nodes.length() > 1) {
        Node first = queue.nodes.shift();
        Node second = queue.nodes.shift();

        Node newNode = new Node();
        newNode.freq = first.freq + second.freq;
        newNode.left = first;
        newNode.right = second;
        root = newNode;

        queue.add(newNode);
    }

    if (root != null) {
        map<string> codes = getCodes(root, "", {});
        io:println("Character symbol to frequency codes mapping: ", codes);
        string encodedBitStr = getEncodedBitStr(data, codes);
        io:println("Encoded bits: ", encodedBitStr);

    }
}
