0:  nop                     # faz nada
1:  li x3, 5                # coloca 5 no registrador x3
2:  li x4, 8                # coloca 8 no registrador x4
3:  add x5, x4, x3          # soma os valores dos registradores x4 e x3 e coloca no registrador x5
4:  addi x5, x5, -1         # subtrai 1 do valor do registrador x5 e coloca no registrador x5
5:  j 20                    # salta para o endereço 20
6:  li x3, 0                # coloca 0 no registrador x3
7:  nop                     # faz nada
8:  nop                     # faz nada
9:  nop                     # faz nada
10: nop                     # faz nada
11: nop                     # faz nada
12: nop                     # faz nada
13: nop                     # faz nada
14: nop                     # faz nada
15: nop                     # faz nada
16: nop                     # faz nada
17: nop                     # faz nada
18: nop                     # faz nada
19: nop                     # faz nada
20: add x5, x0, x3          # soma os valores dos registradores x0 e x3 e coloca no registrador x5
21: j 3                     # salta para o endereço 3
22:  li x3, 0                # coloca 0 no registrador x3
