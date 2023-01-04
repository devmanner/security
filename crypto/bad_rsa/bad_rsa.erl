-module(bad_rsa).
-compile(export_all).


gcd(A,A) -> A;
gcd(A,B) when A > B -> gcd(A-B, B);
gcd(A,B) -> gcd(A, B-A).

lcm(A,B) -> (A*B) div gcd(A, B).

find([], _) ->
    not_found;
find([Value|T], Fun) ->
    case Fun(Value) of
        true -> Value;
        false -> find(T, Fun)
    end.

gen_key(Bits) ->
    gen_key(Bits, 17, 11, 17).
gen_key(Bits, P, Q, E) ->

    % Public modulus
    N = P * Q,

    LambdaN = lcm(P-1, Q-1),

    % Public exponent
    % 3, 5, 17, 257, 65537
    true = E >= 3,
    true = E < N-1,

    1 = gcd(E, LambdaN),

    io:format("LambdaN: ~p~n", [LambdaN]),

    % Private exponent
    D = find(lists:seq(1, LambdaN), fun(D) -> (E * D) rem LambdaN == 1 end),
    true = (E * D) rem LambdaN == 1,
    true = D < N,

    % dP
    % e * dP == 1 (mod (p-1))
    % DP = 7,
    % DP = find(lists:seq(1, 1000), fun(DP) -> (E * DP) rem (P-1) == 1 end),
    DP = D rem (P-1),
    true = (E * DP) rem (P-1) == 1,

    % dQ
    % e * dQ == 1 (mod (q-1))
    % DQ = find(lists:seq(1, 1000), fun(DQ) -> (E * DQ) rem (Q-1) == 1 end),
    DQ = (D rem (Q-1)),
    true = (E * DQ) rem (Q-1) == 1,

    % qInv
    % q * qInv == 1 (mod p)
    QInv = find(lists:seq(1, P), fun(QInv) -> (Q * QInv) rem P == 1 end),
    true = (Q * QInv) rem P == 1,

    io:format("P: ~p~nQ: ~p~nE(PublicExponent): ~p~nLambdaN: ~p~nD(PrivateExponent): ~p~nDP: ~p~nDQ: ~p~n", [P, Q, E, LambdaN, D, DP, DQ]),

    RSAPublic = [<<E:24>>, <<N:Bits>>],
    RSAPrivate = [<<E:24>>, <<N:Bits>>, <<D:Bits>>, <<P:(Bits div 2)>>, <<Q:(Bits div 2)>>, <<DP:(Bits div 2)>>, <<DQ:(Bits div 2)>>, <<QInv:(Bits div 2)>>],

    {RSAPublic, RSAPrivate}.
