%%%-------------------------------------------------------------------
%% @doc telco public API
%% @end
%%%-------------------------------------------------------------------

-module(telco_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    telco_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
