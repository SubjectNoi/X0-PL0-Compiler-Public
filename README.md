# X0-Compiler-Snapshot(完整版带翻译模式解禁，谢谢茄子)

| **Modules** | **Status** | **Test Source** |
| :------------- | :------------- | :------------- |
| `多类型支持(integer, real, string, char, bool)` | √ | TestingSrc/Test10_TypeTest |
| `for语句` | √ |  TestingSrc/Test06_ForBreak, TestingSrc/Test08_ForLoopPrimeNumber, TestingSrc/Test12_ForContinue |
| `break/continue` | √ | TestingSrc/Test03_SimpleWhileBreak, TestingSrc/Test11_WhileContinue |
| `++/--` | √ | TestingSrc/Test07_IncPlusMinus, TestingSrc/Test09_TwoWhileLoop |
| `while-for-if-do嵌套` | √ | TestingSrc/Test13_IfElseInIf, TestingSrc/Test04_ComplexWhileIfBreak, TestingSrc/Test02_WhileIfTest |
| `switch-case` | √ | TestingSrc/Test16_WhileCase |
| `立即数` | √ | N/A |
| `参数返回值函数` | × | N/A |
| `作用域` | × | N/A |
| `常量` | √ | N/A |
| `n维数组` | √ | TestingSrc/Test00_ArrayTest, TestingSrc/Test05_WhileArray |
| `全运算符` | √ | TestingSrc/Test15_BoolTest |
| `语法错误检查` | 不高兴做了 | N/A |
| `语义错误检查` | √ | N/A |

Now complete compiler with complete translation model is available. Any questions? Contact **ilovehanhan1120@hotmail.com**. But be attention, please do not copy this repo entirely for your academic work, it contains some fatal errors to be adjusted. Thanks. 

Usage：

```
Ubuntu>$ git clone http://github.com/SubjectNoi/X0-Compiler-Public
```
```
Ubuntu>$ cd X0-Compiler-Public
```
```
Ubuntu>$ make
```
```
Ubuntu>$ ./X0-Snapshot [Your source file]
```
