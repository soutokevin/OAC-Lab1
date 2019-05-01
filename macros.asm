#macro para valor absoluto
.macro ABS(%reg)
	bgez %reg return
  sub %reg zero %reg
return:
.end_macro


#macro para raiz 