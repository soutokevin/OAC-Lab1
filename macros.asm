.macro ABS(%reg)
	bgez %reg return
  sub %reg zero %reg
return:
.end_macro