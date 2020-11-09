module Sample

open TLS.Curve25519

let dhtest () =
    let (gx, x) = keygen 4 in
    let (gy, y) = keygen 4 in
    let gxy = scalarmult y gx in
    let gyx = scalarmult x gy in
    //assert (gxy == gyx);
    0

// let pubshare k =
//   let KSEC  ks = ks in S_EC ecg (ECGroup.pubshare #ecg ks)
//   match k with
//   | KSCC p  -> S_CC p
//   | KS_X25519 k -> S_X25519 (TLS.Curve25519.pubshare k)
//   | KSX448 p  -> S_X448 p

