import ceylon.collection {
    ArrayList,
    MutableList
}
import ceylon.formatter {
    runFormatter=run
}
import ceylon.formatter.options {
    SparseFormattingOptions,
    commandLineOptions
}
import ceylon.logging {
    addLogWriter
}
import de.lucaswerkmeister.ceylond.daemonizeProgram {
    daemonizeProgram,
    writeSystemdLog
}

shared void run() {
    addLogWriter(writeSystemdLog());
    daemonizeProgram {
        runFormatter;
        fd = 0;
        String[] argumentsMap(String[] arguments, String? workingDirectory) {
            assert (exists workingDirectory);
            if (arguments.any((argument) => argument.startsWith("--help")) || "--version" in arguments) {
                // commandLineOptions will print something and exit –
                // printing and exiting aren’t trapped yet, so return immediately
                // (in this case, we don’t need to adjust paths anyways)
                return arguments;
            }
            value [formattingOptions, remainingArguments] = commandLineOptions(arguments);
            "[[remainingArguments]] with [[workingDirectory]] prepended to the path arguments,
             as well as [[formattingOptions]] in string format."
            MutableList<String> patchedArguments = ArrayList<String> { initialCapacity = remainingArguments.size; };
            String makePathAbsolute(String path) {
                if (path.startsWith("/")) {
                    return path;
                } else {
                    return workingDirectory + "/" + path;
                }
            }
            variable Integer i = 0;
            while (i < remainingArguments.size) {
                assert (exists argument = remainingArguments[i]);
                value nextArgument = remainingArguments[i+1];
                switch (argument)
                case ("--and" | "--to") {
                    patchedArguments.add(argument);
                    if (exists nextArgument) {
                        patchedArguments.add(makePathAbsolute(nextArgument));
                        i++;
                    } else {
                        // ceylon.formatter will warn about missing argument
                    }
                }
                case ("--pipe") {
                    patchedArguments.add(argument);
                }
                else {
                    patchedArguments.add(makePathAbsolute(argument));
                }
                i++;
            }
            String stringifyOption(Object option) {
                if (is {String*} option) {
                    return " ".join(option.map(stringifyOption));
                } else {
                    return option.string;
                }
            }
            for (option in `SparseFormattingOptions`.getDeclaredAttributes<SparseFormattingOptions>(`SharedAnnotation`, `DefaultAnnotation`)) {
                if (exists val = option.bind(formattingOptions).get()) {
                    patchedArguments.add("--" + option.declaration.name);
                    patchedArguments.add(stringifyOption(val));
                }
            }
            return patchedArguments.sequence();
        }
        maximumStandardInput = 640k; // ought to be enough for anybody
    };
}
