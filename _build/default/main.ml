open Hacl_star.EverCrypt
open Hacl_star.Hacl
open Hacl_star.SharedFunctors
open Hacl_star.SharedDefs

let () =
  (*
  In this block, we can use Curve25519.secret_to_public,
  Curve25519.scalarmult & Curve25519.ecdh from EverCrypt to
  perform a ECDH key exchange. The documentation of The
  c-counterpart to Evercrypt is described here:
  https://hacl-star.github.io/HaclECDH.html
   *)
  print_endline "Done"