# a0 = x0
# a1 = y0
# a2 = x1
# a3 = y1
distancia:
  sub t0 a0 a2
  mul t0 t0 t0
  sub t1 a1 a3
  mul t1 t1 t1
  add t0 t0 t1
  fcvt.s.w ft0 t0
  fsqrt.s fa0 ft0
  ret
