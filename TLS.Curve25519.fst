module TLS.Curve25519

//open EverCrypt

open FStar.Int32
open FStar.Bytes
open FStar.Error

open FStar.HyperStack.ST

module B = FStar.Bytes
module LB = LowStar.Buffer

type scalar = lbytes 32
type point = lbytes 32
type keyshare = point * scalar

// type eqPoint = hasEq point
// type eqBytes = hasEq (lbytes 32)

let pubshare (k:keyshare) : Tot point = fst k

assume val generated (sc:scalar) (p:point) (i:nat{FStar.Bytes.repr_bytes i <= 32}): bool
assume val keygen (i:nat{FStar.Bytes.repr_bytes i <= 32}) : (ks:keyshare{ generated (snd ks) (fst ks) i  })
assume val composed (k:scalar) (p:point) (tp:point) : bool
assume val mul (k:scalar) (p:point) : (tp:point{composed k p tp})

// let (gx, x) = keygen 4 in
//     let (gy, y) = keygen 5 in
//     let gxy = mul y gx in
//     let gyx = mul x gy in
//     // assert (generated x gx 4);
//     assert (gxy = gyx);

// val mulEq2: k1:scalar -> k2:scalar -> p1:point -> p2:point ->
//   Lemma (requires(k1=k2 /\ p1=p2))
//       (ensures(mul k1 p1 = mul k2 p2))
    
val mulEq3: sec1:nat -> sec2:nat ->
    Lemma (requires(True))
        (ensures(
          let (gx, x) = keygen sec1 in
          let (gy, y) = keygen sec2 in
          ((mul y gx) = (mul x gy))))

val mulEq: x:scalar -> y:scalar -> gx:point -> gy:point -> gxy:point -> gyx:point -> (s1:nat{FStar.Bytes.repr_bytes s1 <= 32}) -> ( s2:nat{FStar.Bytes.repr_bytes s2 <= 32}) ->
  Lemma (requires(generated x gx s1 /\ generated y gy s2 /\ composed y gx gxy /\ composed x gy gyx))
      (ensures(gxy = gyx))

// let scalarmult (secret:Bytes.lbytes 32) (point:Bytes.lbytes 32)
//   : ST (lbytes 32)
//   (requires (fun h -> True))
//   (ensures (fun h0 _ h1 -> modifies_none h0 h1)) =
//   push_frame ();
//   let lp = B.len point in
//   let ls = B.len secret in
//   let pb = LB.alloca 0uy lp in
//   let sb = LB.alloca 0uy ls in
//   let out = LB.alloca 0uy 32ul in
//   B.store_bytes point pb;
//   B.store_bytes secret sb;
//   assume false;
//   ignore (EverCrypt.Curve25519.ecdh out sb pb);
//   pop_frame (); B.of_buffer 32ul out

// let keygen (i:nat{FStar.Bytes.repr_bytes i <= 32}) : ST keyshare
//   (requires (fun h0 -> True))
//   (ensures (fun h0 _ h1 -> modifies_none h0 h1))
//   =
//   let s : lbytes 32 = bytes_of_int 32 i in //sample32 32ul in
//   let basepoint = Bytes.create 1ul 9uy @| Bytes.create 31ul 0uy in
//   scalarmult s basepoint, s

// let mul (k:scalar) (p:point) : ST point
//   (requires (fun h0 -> True))
//   (ensures (fun h0 _ h1 -> modifies_none h0 h1))
//   = scalarmult k p