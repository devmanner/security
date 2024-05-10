-module(hcrypt).
-export([test/0]).
-export([doit/2]).

-export([pow2/1]).
-export([mult/1]).
-export([sum/1]).
-export([sum2/1]).
-export([divide/1]).

% Example of Homeomorphic encryption.
% doit/1 does all the things. pow2 is the function to be calculated on an insecure system and only gets the input in 
% encrypted form. Result from the function is the result of X*X in ints encrypted form. Mind blown.

pack(X, Len) ->
    XEnc = binary:encode_unsigned(X),
    PadSize = Len - erlang:bit_size(XEnc),
    <<0:PadSize, XEnc/binary>>.

unpack(Bin) ->
    binary:decode_unsigned(Bin).

doit(Input, Fun) ->
    PubExp = 65537, % Should probably be carefully selected...
    KeyLen = 4096,
    RSAOpt = [{rsa_padding,  rsa_no_padding}],

    {RSAPublic, RSAPrivate} = crypto:generate_key(rsa, {KeyLen, PubExp}),
    [_, Mod] = RSAPublic,

    Cipher = lists:map(fun(X) -> crypto:public_encrypt(rsa, pack(X, KeyLen), RSAPublic, RSAOpt) end, Input),

    R = calc(Fun, Cipher, Mod),
    
    Plain = crypto:private_decrypt(rsa, R, RSAPrivate, RSAOpt),
    unpack(Plain).

calc(Fun, Blind, M) ->
    Decoded = lists:map(fun(X) -> binary:decode_unsigned(X) end, Blind),
    Mod = binary:decode_unsigned(M),
    R = erlang:apply(?MODULE, Fun, [Decoded]),
    binary:encode_unsigned(R rem Mod).

% Remember that the operands here may be very large... so don't do too complex operations.
pow2([X]) ->
    X * X.
mult([X, Y]) ->
    X * Y.
divide([X, Y]) ->
    X div Y.
sum2([X, Y]) ->
    X + Y.
sum(L) ->
    lists:foldl(fun(X, Acc) -> X + Acc end, 0, L).

test() ->
    0 = unpack(pack(0, 2048)),
    101 = unpack(pack(101, 2048)),
    1234567 = unpack(pack(1234567, 2048)),

    lists:foreach(fun(_) -> 
        A = rand:uniform(100000) + 1,
        B = rand:uniform(100000) + 1, % Avoid divide by 0
        io:format("A: ~p~nB:~p~n~n", [A, B]),
        A2 = pow2([A]),
        A2 = doit([A], pow2),

        AB = mult([A, B]),
        AB = mult([B, A]),
        AB = doit([A, B], mult),
        AB = doit([B, A], mult),

        ApB = sum2([A, B]),
        ApB = sum2([B, A]),
        ApB = doit([A, B], sum2),
        ApB = doit([B, A], sum2),
        


        AdivB = divide([A, B]),
        AdivB2 = doit([A, B], divide),
        io:format("Exp result: ~p Result: ~p~n", [AdivB, AdivB2]),
        AdivB = AdivB2
    end, lists:seq(1,10)),

    2 = doit([1, 1], sum2),

    10 = doit([3, 7], sum2),
    55 = doit(lists:seq(1, 10), sum),

    10 = doit([100, 10], divide),

    ok.



