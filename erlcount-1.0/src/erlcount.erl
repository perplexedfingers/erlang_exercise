-module(erlcount).
-behavior(application).
-export([start/2, stop/1]).

start(normal, _Args) ->
    elrcount_sup:start_link().

stop(_State) ->
    ok.
