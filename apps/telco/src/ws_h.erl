-module(ws_h).

-export([init/2, websocket_init/1, websocket_handle/2, websocket_info/2]).

init(Req, Opts) ->
  {cowboy_websocket, Req, Opts}.

websocket_init(State) ->
  %erlang:start_timer(1000, self(), <<"Hello!">>),
  %{ok, State}.
  {reply, {text, <<"WS connection established">>}, State}.

websocket_handle({text, Msg}, State) ->
  {reply, {text, << "Client sent: ", Msg/binary >>}, State};
websocket_handle(_Data, State) ->
  {ok, State}.

%websocket_handle({text, Msg}, State) ->
%  {reply, {text, << "That's what she said! ", Msg/binary >>}, State};
%websocket_handle(_Data, State) ->
%  {ok, State}.

websocket_info(_Info, State) ->
  {reply, {text, <<"Received erlang message">>}, State}.

%websocket_info({timeout, _Ref, Msg}, State) ->
%  erlang:start_timer(1000, self(), <<"How' you doin'?">>),
%  {reply, {text, Msg}, State};
%websocket_info(_Info, State) ->
%  {ok, State}.
