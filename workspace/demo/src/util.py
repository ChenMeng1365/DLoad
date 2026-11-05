"""DLoad 示例工程 - Python 部分：用于体验编辑器 / 终端 / 运行能力。"""


def fizzbuzz(n: int) -> str:
    """经典的 FizzBuzz 单元函数。"""
    parts = []
    for i in range(1, n + 1):
        if i % 15 == 0:
            parts.append("FizzBuzz")
        elif i % 3 == 0:
            parts.append("Fizz")
        elif i % 5 == 0:
            parts.append("Buzz")
        else:
            parts.append(str(i))
    return " ".join(parts)


def word_frequency(text: str) -> dict:
    """统计英文单词出现次数（简单实现）。"""
    freq = {}
    for word in text.lower().split():
        word = word.strip(",.;:!?\n\t\r()[]{}\"'")
        if word:
            freq[word] = freq.get(word, 0) + 1
    return freq


if __name__ == "__main__":
    print("fizzbuzz(20):", fizzbuzz(20))
    sample = "the quick brown fox jumps over the lazy dog the end"
    print("frequency   :", word_frequency(sample))
