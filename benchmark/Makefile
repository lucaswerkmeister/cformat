iterations := 25

.PHONY: all clean

all: comparison-$(iterations).png

timings-cformat-$(iterations).dat:
	systemctl --user start cformat.socket # make sure the daemon is running…
	systemctl --user stop cformat.service # but make sure we’re including the startup time
	for i in {1..$(iterations)}; do /usr/bin/time -f %e -ao $@ cformat       ../../ceylon.formatter/source --to formatted1; done
	$(RM) -r formatted1
timings-ceylon-format-$(iterations).dat:
	for i in {1..$(iterations)}; do /usr/bin/time -f %e -ao $@ ceylon format ../../ceylon.formatter/source --to formatted2; done
	$(RM) -r formatted2
comparison-$(iterations).png: comparison.gp timings-cformat-$(iterations).dat timings-ceylon-format-$(iterations).dat
	gnuplot -e "iterations=$(iterations)" $<

clean:
	$(RM) timings-cformat-*.dat timings-ceylon-format-*.dat comparison-*.png
	$(RM) -r formatted1 formatted2
