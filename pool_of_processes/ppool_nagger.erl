-module(ppool_nagger).
-behavior(gen_server).
-export([start_link/4, stop/1]).
-export([init/1, handle_call/3, handle_cast/2,
         handle_info/2, code_change/3, terminate/2]).

start_link(Task, Deplay, Max, SendTo) ->
    gen_server:start_link(?MODULE, {Task, Delay, Max, SendTo}, []).

stop(Pid) ->
    gen_server:call(Pid, stop).

init({Task, Delay, Max, SendTo}) ->
    {ok, {Task, Dealy, Max, SendTo}, Delay}.
