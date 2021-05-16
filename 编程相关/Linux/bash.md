1. $() 和 `` 用来计算命令并且输出值，如

    $(ls ./) or `ls ./`

2. $var 和 ${} 用来取变量的值，如
    
    $var or ${var}

3. 建立只读变量

    var=value
    readonly var

4. 获取字符串长度 # 符号

    string="abcd"
    echo ${#string}

5. 