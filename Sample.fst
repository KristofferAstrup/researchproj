module Sample

open TLS.Curve25519
open FStar.HyperStack.ST
open FStar.Bytes
open FStar.All


//#set-options "--max_fuel 1000 --max_ifuel 1000 --z3rlimit 5000"
// let dhtest () =
//     let (gx, x) = keygen 4 in
//     let (gy, y) = keygen 4 in
//     let gxy = scalarmult y gx in
//     let gyx = scalarmult x gy in
//     assert (gxy == gyx);
//     0

// val multEq: s1:nat{FStar.Bytes.repr_bytes s1 <= 32} -> s2:nat{FStar.Bytes.repr_bytes s2 <= 32} -> 
//     Lemma (requires(_->True))
//         (ensures(scalarmult s2 (scalarmult s1 ))) 

assume val deformat_point: bytes -> point
assume val format_point: (p:point) -> (b:bytes{(deformat_point b) = p})

// val multEq: p1:point -> s1:scalar -> s2:scalar ->
//     Lemma (requires(True))
//         (ensures((mul s2 (mul s1 p1)) = (mul s1 (mul s2 p1))))

// val multEq: (s1: nat) (p1: point) (sc1: scalar) (s2: nat) (p2: point) (sc2: scalar) ->
//     Lemma (requires(true)) 
// ensures((p1, sc1) = keygen s1 /\ (p2, sc2) = keygen s2 ==> scalarmult sc1 p2 = scalarmult sc2 p1)

// assume MultEq: forall (s1: nat) (p1: point) (sc1: scalar) (s2: nat) (p2: point) (sc2: scalar). {(p1, sc1) = keygen s1 /\ (p2, sc2) = keygen s2 ==> scalarmult sc1 p2 = scalarmult sc2 p1  }

val clientHello: (s:nat{FStar.Bytes.repr_bytes s <= 32}) -> ST (bytes * scalar)
    (requires (fun h0 -> True))
    (ensures (fun h0 t h1 -> modifies_none h0 h1 /\ generated (snd t) (deformat_point (fst t)) s))
let clientHello s =
    let (gx, x) = keygen s in
    ((format_point gx), x)

val serverResponse: (s:nat{FStar.Bytes.repr_bytes s <= 32}) -> b:bytes -> ST (bytes * scalar * point)
    (requires (fun h0 -> True))
    (ensures (fun h0 tr h1 -> modifies_none h0 h1 /\ (
        let (d, y, _) = tr in 
        generated y (deformat_point d) s
    ) /\ (
        let (_, y, p) = tr in
        composed y (deformat_point b) p
    )))
let serverResponse s b =
    let (gy, y) = keygen s in
    let gx = deformat_point b in
    let gxy = mul y gx in
    ((format_point gy), y, gxy)

val clientConfirm: b:bytes -> x:scalar -> ST bytes
    (requires (fun h0 -> True))
    (ensures (fun h0 tb h1 -> modifies_none h0 h1 /\ composed x (deformat_point b) (deformat_point tb) ))
let clientConfirm b x =
    let gy = deformat_point b in
    let gyx = mul x gy in
    (format_point gyx)

val serverConfirm: b:bytes -> gxy:point -> Tot bool
let serverConfirm b gxy =
    let gyx = deformat_point b in
    (gyx = gxy)

let ecdhtest =
    let sec1 = 1 in
    let sec2 = 2 in
    let (bgx, x) = (clientHello sec1) in
    let (bgy, y, gxy) = (serverResponse sec2 bgx) in
    let bgyx = (clientConfirm bgy x) in
    mulEq x y (deformat_point bgx) (deformat_point bgy) gxy (deformat_point bgyx) sec1 sec2;
    let eq = (serverConfirm bgyx gxy) in
    assert (eq)
    


// val sendClientHello: s:nat{FStar.Bytes.repr_bytes s <= 32} -> ST keyshare
//     (requires (fun h0 -> True))
//     (ensures (fun h0 _ h1 -> modifies_none h0 h1))

// let sendClientHello s =
//     keygen s

// val recieveClientHello: (s:nat{FStar.Bytes.repr_bytes s <= 32}) -> gx:point -> ST (point * point)
//     (requires (fun h0 -> True))
//     (ensures (fun h0 _ h1 -> modifies_none h0 h1))

// let recieveClientHello s gx =
//     let (gy, y) = keygen s in
//     let gxy = mul y gx in
//     (gy, gxy)

// val sendServerResponse: gy:point -> point
// let sendServerResponse gy =
//     gy

// val recieveServerResponse: gy: point -> x:scalar -> ST point
//     (requires (fun h0 -> True))
//     (ensures (fun h0 _ h1 -> modifies_none h0 h1))
// let recieveServerResponse gy x =
//     mul x gy

// // val sendClientConfirm: gxy:nat -> Tot hash
// // let sendClientConfirm gxy =
// //     let h = hashNat gxy in
// //     h

// // val recieveClientConfirm: gxy_hash:hash -> gxy: nat -> Tot bool
// // let recieveClientConfirm gxy_hash gxy =
// //     let gxy_hash' = hashNat gxy in
// //     gxy_hash = gxy_hash'

// #set-options "--max_fuel 1000 --max_ifuel 1000 --z3rlimit 5000"
// let dhtest =

//     //Client hello    
//     let (gx, x) = sendClientHello 8 in
//     //assert (verify client_keypair.pkey gx gx_sign) in

//     //Server response
//     let (gy, server_gxy) = recieveClientHello 9 gx in
//     let gy' = sendServerResponse gy in

//     //Client confirm
//     let client_gxy = recieveServerResponse gy' x in
//     // let client_gxy_hash = sendClientConfirm client_gxy in

//     let b = format_point gx in
//     assert (gx = deformat_point b)


    // //Server confirm
    // let gxyHashesEqual = recieveClientConfirm client_gxy_hash server_gxy in
    // assert gxyHashesEqual
    //assert(client_gxy = server_gxy)

// #set-options "--max_fuel 1000 --max_ifuel 1000 --z3rlimit 5000"
// let dhtest () =
//     let sec1 = 1 in
//     let sec2 = 2 in
//     let (gx, x) = (keygen sec1) in
//     let (gy, y) = (keygen sec2) in
//     (mulEq3 sec1 sec2);
//     assert((mul y gx) <> (mul x gy))
    //assert (false)
    // let (gx, x) = keygen 4 in
    // let (gy, y) = keygen 5 in
    // // let gxy = mul y gx in
    // // let gyx = mul x gy in
    // // assert (generated x gx 4);
    // assert ((mul y gx) = (mul x gy));
    

//# use corecrypto to get ecDH
//# send recieve bytes (repr takes nat -> bytes and vice versa)
//# find props/guarantees: 
//# -- ***secrecy ?? keys not revealed to attacker
// -- perfect forward secr
// -- post-compromised secresy (device compr for a while)
//    -- recover after compromise (key-rotation)
// -- key-compromising impersonofication: for the client sessions attacker cannot get sessionkey (x gx gxy)
// -- session key independence: if the attacker knows a sessionkey, he does not learn anything about keys of any other sesions

