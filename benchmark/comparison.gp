#!/usr/bin/gnuplot -f
if (!exists("iterations")) iterations = 25
set terminal "png"
set output ("iterations-" . iterations . ".png")
set title "Timings of formatting ceylon.formatter’s source/ directory"
set xlabel "iteration number"
set ylabel "seconds"
plot ("timings-cformat-"       . iterations . ".dat") title "cformat"       with lines, \
     ("timings-ceylon-format-" . iterations . ".dat") title "ceylon format" with lines
