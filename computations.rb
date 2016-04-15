#!/usr/bin/env ruby

B = 1
KB = 1000 * B
MB = 1000 * KB
GB = 1000 * MB

def calc(i, t, n)
  (n / 2.0 * (2 * i + t * n)).to_i
end

def display(i, t, n, u)
  "during #{n} #{u}s, growing by #{t / KB} KB by #{u}, with initial size at #{i / KB} KB = #{calc(i, t, n) / MB} MB"
end

I1 = (4.3 * MB).round # init size
T1 = (100 * KB).round # grows by day
N1 = (18 * 30).round # 18 months * 30 days

I2 = (4.3 * MB).round # init size
T2 = (100 * KB / 2).round # grows by day/2
N2 = (18 * 30 * 2).round # 18 months * 30 days * 2

I3 = (4.3 * MB).round # init size
T3 = (100 * KB * 3.5).round # grows by week/2
N3 = (18 * 30 / 3.5).round # 18 months * 4 weeks

if __FILE__ == $0
  puts display(I2, T2, N2, "mi-day")
  puts display(I1, T1, N1, "day")
  puts display(I3, T3, N3, "mi-week")
end
