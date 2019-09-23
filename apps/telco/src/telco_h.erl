-module(telco_h).

-export([init/2]).

init(Req0, Opts) ->
  Method = cowboy_req:method(Req0),
  #{msisdn := Msisdn} = cowboy_req:match_qs([{msisdn, [], undefined}], Req0),
  Req = process_transaction(Method, Msisdn, Req0),
  {ok, Req, Opts}.

process_transaction(<<"GET">>, undefined, Req) ->
  cowboy_req:reply(400, #{
    <<"content-type">> => <<"application/json">>
   }, json_body_missing_parameter(), Req);
process_transaction(<<"GET">>, Msisdn, Req) ->
  cowboy_req:reply(200, #{
    <<"content-type">> => <<"application/json">>
   }, evaluate_msisdn(Msisdn), Req);
process_transaction(_, _, Req) ->
  cowboy_req:reply(405, Req).

json_body_success(Msisdn) ->
  list_to_binary("{
                    \"msisdn\":\"" ++ binary_to_list(Msisdn) ++ "\",
                    \"status\":\"successful\"
                }").

json_body_fail(Msisdn) ->
  list_to_binary("{
                    \"msisdn\":\"" ++ binary_to_list(Msisdn) ++ "\",
                    \"status\":\"failed\"
                }").

json_body_missing_parameter() ->
  list_to_binary("{
                    \"msisdn\":\"Missing MSISDN parameter\",
                    \"status\":\"failed\"
                  }").

evaluate_msisdn(Msisdn) ->
  case length(binary_to_list(Msisdn)) < 6 of
    true ->
      gproc_ps:publish(l, msg_test, {fail, Msisdn}),
      json_body_fail(Msisdn);
    false ->
      gproc_ps:publish(l, msg_test, {success, Msisdn}),
      json_body_success(Msisdn)
  end.
