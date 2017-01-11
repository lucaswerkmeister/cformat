cformat
=======

A daemonized version of the `ceylon.formatter` command line tool (`ceylon format`),
mostly to showcase [ceylond].

[ceylond]: https://github.com/lucaswerkmeister/ceylond

Installation
------------

```sh
make install # install to home directory
systemctl --user daemon-reload # make user manager see cformat.{service,socket} units
systemctl --user enable cformat.socket # automatically start daemon
systemctl --user start cformat.socket # start daemon
```

The `cformat` binary will be installed in `$(systemd-path user-binaries)`,
which is `~/.local/bin` with the default XDG paths.
Ensure that this directory is contained in your `PATH`.

To uninstall, run the reverse commands:
```sh
systemctl --user stop cformat.service cformat.socket
systemctl --user disable cformat.socket
make uninstall
systemctl --user daemon-reload
```

Usage
-----

`cformat` is a drop-in replacement for `ceylon format` (except for some *very* minor caveats around pipe mode):

```sh
cformat source # to format all Ceylon code in source
cformat source --to source-formatted # if you’re afraid I might break your code – directory structure is preserved
cformat source test-source # to format all Ceylon code in source and test-source
cformat source --and test-source --to formatted # to format all Ceylon code in source and test-source into formatted
```

Performance
-----------

The first invocation of `cformat`, which launches the daemon, will be slightly slower,
since the JVM has to load, run and optimize more code.
But after that, `cformat` can be vastly faster than `ceylon format`,
since the daemon just keeps running and is optimized further and further by the JVM:

![](https://github.com/lucaswerkmeister/cformat/blob/master/benchmark/iterations-25.png)

License
-------

The content of this repository is released under the ASL v2.0
as provided in the LICENSE file that accompanied this code.

By submitting a “pull request” or otherwise contributing to 
this repository, you agree to license your contribution under 
the license mentioned above.

cformat uses ceylond, which is published under the LGPLv3,
as provided in the LICENSE.LGPLv3 file that accompanied this code.
