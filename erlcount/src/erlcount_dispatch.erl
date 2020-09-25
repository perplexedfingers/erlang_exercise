-module(erlcount_dispatch).
-behavior(gen_fsm).
-export([start_link/0, complete/4]).
-export([init/1, dispatching/2, listening/2, handle_event/3,
         handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-define(POOL, erlcount).
-record(data, {regex=[], refs=[]}).

start_link() ->
    gen_fsm:start_link(?MODULE, [], []).

complete(Pid, Regex, Ref, Count) ->
    gen_fsm:send_all_state_event(Pid, {complete, Rext, Ref, Count}).

init([]) ->
    {ok, Regex} = application:get_env(regex),
    {ok, Dir} = application:get_env(directory),
    {ok, MaxFiles} = application:get_env(max_files),
    ppool:start_pool(?POOL, MaxFiles, {erlcount_counter, start_link, []}),
    case lists:all(fun valid_regex/1, Regex) of
        true ->
            self() ! {start, Dir},
            {ok, dispatching, #data{regex=[{R, 0} || R <- Regex]};
        false ->
            {stop, invalid_regex}
    end.

valid_regex(Regex) ->
    try re:run("", Regex) of
        _ -> true
    catch
        error:badarg -> false
    end.
