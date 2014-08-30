/*
  Copyright: Martin Nowak 2013 -
  License: Subject to the terms of the MIT license, as written in the included LICENSE file.
  Authors: $(WEB code.dawg.eu, Martin Nowak)
*/
import std.stdio, std.string, std.path, std.process;
import core.stdc.string : strlen;
import deimos.linenoise;
import dawg.drepl;

void main(string[] args)
{
    writeln("Welcome to D REPL.");

    auto history = buildPath(environment.get("HOME", ""), ".drepl_history").toStringz();
    linenoiseHistoryLoad(history);

    auto intp = interpreter(dmdEngine());

    char *line;
    const(char) *prompt = "D> ";
    while((line = linenoise(prompt)) !is null)
    {
        linenoiseHistoryAdd(line);
        linenoiseHistorySave(history);

        auto res = intp.interpret(line[0 .. strlen(line)]);
        final switch (res.state) with(InterpreterResult.State)
        {
        case incomplete:
            prompt = " | ";
            break;

        case success:
        case error:
            if (res.stdout.length) writeln(res.stdout);
            prompt = "D> ";
            break;
        }
    }
}
