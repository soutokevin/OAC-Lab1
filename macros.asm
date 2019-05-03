.macro ABS(%reg)
	bgez %reg end
  sub %reg zero %reg
  end:
.end_macro
