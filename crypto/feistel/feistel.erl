-module(feistel).
-export([encrypt/2, decrypt/2]).

%-export([feistel/3]).
%-export([crypt_fun/0]).

%-export([split_pad_n/2]).

-export([test/0]).


% Split binary to N-byte chunks, pad the last to N bytes.
split_pad_n(_, <<>>) ->
    [];
split_pad_n(N, Bin) ->
    case size(Bin) > N of
        true ->
            [binary:part(Bin, {0, N})|split_pad_n(N, binary:part(Bin, {N, size(Bin)-N}))];
        false ->
			Padding = crypto:strong_rand_bytes(N-size(Bin)),
            [<<Bin/binary, Padding/binary>>]
	end.

feistel([],_ ,_) ->
    <<>>;
feistel([Bin|T], Crypt, Keys) ->
    FeistelHead = feistel_block(Bin, Crypt, Keys),
    FeistelTail = feistel(T, Crypt, Keys),
    <<FeistelHead/binary, FeistelTail/binary>>.

feistel_block(B, Crypt, Keys) ->
    [L0, R0] = split_pad_n(16, B),
    {Ln, Rn} = lists:foldl(fun(Key, {L,R}) -> {R, crypto:exor(L, Crypt(Key, R))} end, {L0, R0}, Keys),
    <<Rn/binary, Ln/binary>>.

crypt_fun() ->
	fun(Key, Plain) ->
        crypto:exor(crypto:hash(md5, Key), crypto:hash(md5, Plain))
    end.

encrypt(Bin, Keys) ->
	Size = size(Bin),
	Enc = feistel(split_pad_n(32, Bin), crypt_fun(), Keys),
	<<Size:32, Enc/binary>>.

decrypt(<<Size:32, Bin/binary>>, Keys) ->
	Decr = feistel(split_pad_n(32, Bin), crypt_fun(), lists:reverse(Keys)),
	binary:part(Decr, {0, Size}).

test() ->
    io:format("Testing split_pad_n~n"),
	[<<1>>,<<2>>,<<3>>] = split_pad_n(1, <<1,2,3>>),
	[<<1,2>>,_] = split_pad_n(2, <<1,2,3>>),

    2 = length(split_pad_n(4, <<1,2,3,4,5,6>>)),
    1 = length(split_pad_n(32, <<1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2>>)),
    2 = length(split_pad_n(32, <<1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3>>)),

	io:format("Testing crypt/encrypt~n"),

	Key1 = [<<>>],
	<<>> = feistel:decrypt(feistel:encrypt(<<>>, Key1), Key1),

	% I know that a string is a bad key.
	Key2 = [<<"i know the secret song now">>],
	<<"foobar">> = feistel:decrypt(feistel:encrypt(<<"foobar">>, Key2), Key2),

	Key3 = Key2 ++ [<<"they kicked me out of the band">>],
	<<"foobar">> = feistel:decrypt(feistel:encrypt(<<"foobar">>, Key3), Key3),

	Key4 = lists:map(fun(_) -> crypto:strong_rand_bytes(128) end, lists:seq(1,100)),
	Text4 = <<"Beez gbazgen mauz gaysh, Bal gonskunn geez woazch, Ma meesken loas gouase,Geez gonskunn boz mosquiez">>,
	Text4 = feistel:decrypt(feistel:encrypt(Text4, Key4), Key4),

	ok.

