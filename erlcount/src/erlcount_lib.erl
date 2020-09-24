-module(erlcount_lib).
-export([find_erl/1]).
-include_lib("kernel/include/file.hrl").

find_erl(Directory) ->
    find_erl(Directory, queue:new()).

find_erl(Name, Queue) ->
    {ok, F = #file_info{}} = file:read_file_info(Name),
    case F#file_info.type of
        directory -> handle_directory(Name, Queue);
        regular -> handle_regular_file(Name, Queue);
        _Other -> dequeue_and_run(Queue)
    end.
