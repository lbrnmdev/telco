-module(telco_h).

-export([init/2]).

init(Req0, Opts) ->
  Method = cowboy_req:method(Req0),
  #{msisdn := Msisdn} = cowboy_req:match_qs([{msisdn, [], undefined}], Req0),
  Req = process_transaction(Method, Msisdn, Req0),
  {ok, Req, Opts}.

process_transaction(<<"GET">>, undefined, Req) ->
  cowboy_req:reply(400, #{}, <<"Missing MSISDN parameter.">>, Req);
process_transaction(<<"GET">>, Msisdn, Req) ->
  cowboy_req:reply(200, #{
    <<"content-type">> => <<"application/json">>
   }, evaluate_msisdn(Msisdn), Req);
process_transaction(_, _, Req) ->
  cowboy_req:reply(405, Req).

json_body_success(Msisdn) ->
  list_to_binary("{
                    \"msisdn\":\"" ++ binary_to_list(Msisdn) ++ "\",
                    \"status\":\"success\"
                }").

json_body_fail(Msisdn) ->
  list_to_binary("{
                    \"msisdn\":\"" ++ binary_to_list(Msisdn) ++ "\",
                    \"status\":\"fail\"
                }").

evaluate_msisdn(Msisdn) ->
  case length(binary_to_list(Msisdn)) < 6 of
    true -> json_body_fail(Msisdn);
    false -> json_body_success(Msisdn)
  end.
