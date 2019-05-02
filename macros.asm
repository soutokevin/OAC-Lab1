.macro ABS(%reg)
	bgez %reg end
  sub %reg zero %reg
  end:
.end_macro

.macro LESS_THAN(%res, %left, %right)
  slt %res %left %right
  bnez %res end
  li %res -1
  end:
.end_macro
