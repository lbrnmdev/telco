%%%-------------------------------------------------------------------
%% @doc telco public API
%% @end
%%%-------------------------------------------------------------------

-module(telco_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
                                    {'_', [
                                           {"/", telco_h, []}
                                          ]}
                                   ]),
  {ok, _} = cowboy:start_clear(http, [{port, 8080}], #{env => #{dispatch => Dispatch}}),
  telco_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
