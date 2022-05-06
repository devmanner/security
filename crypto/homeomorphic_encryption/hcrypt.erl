-module(hcrypt).
-export([test/0]).
-export([doit/2]).
-export([pow2/1, pow3/1]).

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

    Cipher = crypto:public_encrypt(rsa, pack(Input, KeyLen), RSAPublic, RSAOpt),

    R = calc(Fun, Cipher, Mod),
    
    Plain = crypto:private_decrypt(rsa, R, RSAPrivate, RSAOpt),
    unpack(Plain).


calc(Fun, Blind, M) ->
    Decoded = binary:decode_unsigned(Blind),
    Mod = binary:decode_unsigned(M),
    binary:encode_unsigned(erlang:apply(?MODULE, Fun, [Decoded]) rem Mod).


pow2(X) ->
    X*X.
pow3(X) ->
    X*X*X.

test() ->
    0 = unpack(pack(0, 2048)),
    101 = unpack(pack(101, 2048)),
    1234567 = unpack(pack(1234567, 2048)),
    4 = doit(2, pow2),

    ok.



