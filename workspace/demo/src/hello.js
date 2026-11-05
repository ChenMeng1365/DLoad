/**
 * DLoad 示例工程 - 用于体验 DSH IDE 的编辑 / LSP / 运行能力
 */

/** 计算斐波那契数列第 n 项（迭代实现） */
export function fibonacci(n) {
  if (n <= 1) return n;
  let prev = 0;
  let curr = 1;
  for (let i = 2; i <= n; i++) {
    const next = prev + curr;
    prev = curr;
    curr = next;
  }
  return curr;
}

/** 简单的统计工具 */
export function summarize(numbers) {
  if (!Array.isArray(numbers) || numbers.length === 0) {
    return { count: 0, min: 0, max: 0, avg: 0 };
  }
  const min = Math.min(...numbers);
  const max = Math.max(...numbers);
  const avg = numbers.reduce((a, b) => a + b, 0) / numbers.length;
  return { count: numbers.length, min, max, avg };
}

console.log('fib(10) =', fibonacci(10));
console.log('summary  =', summarize([3, 1, 4, 1, 5, 9, 2, 6]));
