-module(ws_h).

-export([init/2, websocket_init/1, websocket_handle/2, websocket_info/2]).

init(Req, Opts) ->
  {cowboy_websocket, Req, Opts}.

websocket_init(State) ->
  gproc_ps:subscribe(l, msg_test),
  {reply, {text, <<"WS connection established">>}, State}.

websocket_handle({text, Msg}, State) ->
  {reply, {text, << "Client sent: ", Msg/binary >>}, State};
websocket_handle(_Data, State) ->
  {ok, State}.

websocket_info({gproc_ps_event, msg_test, Msg}, State) ->
  case Msg of
    {success, Msisdn} ->
      {reply, {text, <<"Successfully processed: ", Msisdn/binary >>}, State};
    {fail, Msisdn} ->
      {reply, {text, <<"Unable to process: ", Msisdn/binary >>}, State}
  end;
websocket_info(_Info, State) ->
  {reply, {text, <<"Received erlang message">>}, State}.
