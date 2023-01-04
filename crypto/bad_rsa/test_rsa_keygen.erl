-module(test_rsa_keygen).
-compile(export_all).

% This is just to test if generated RSA keys have prines with little difference.


prime_diff([_E, _N, _D, P1, P2, _E1, _E2, _C]) ->
    binary:decode_unsigned(P1)-binary:decode_unsigned(P2).


test(KeyLen) ->
    F = fun(_) ->
        PubExp = 65537,
        %KeyLen = 1024,
        {RSAPublic, RSAPrivate} = crypto:generate_key(rsa, {KeyLen, PubExp}),
        case prime_diff(RSAPrivate) < 1000000 of
            true -> {RSAPublic, RSAPrivate};
            false -> []
        end
    end,
    lists:flatten(lists:map(F, lists:seq(1,1000))).


