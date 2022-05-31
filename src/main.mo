import Prim "mo:prim";
 import Cycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";
import List "mo:base/List";
import AssocList "mo:base/AssocList";
import Array "mo:base/Array";
import Map "mo:base/HashMap";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Float "mo:base/Float";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Hash "mo:base/Hash";
import Order "mo:base/Order";

import Http "./http";
import HttpTypes "./http/types";

import Types "Types";


import TokenTypes "./TokenTypes";

shared (install) actor class Ledger() = this {



  let ICET = "ot4zw-oaaaa-aaaag-qabaa-cai";

  let icet : TokenTypes.Self = actor "ot4zw-oaaaa-aaaag-qabaa-cai";


  stable var _admins: [Text] = [
    "zrbbd-7qzdb-xp7r4-v3du3-sulj4-7fwm2-3v3hr-vitzv-4nnsy-mzeab-aae",
    "33cvj-3w7ku-d2k2n-nqueo-wkxpp-pmckv-rhyjh-jvn5t-fzw4x-xxwy6-qae"
  ];
  stable var _allows: [Text] = ["ukvuy-5aaaa-aaaaj-qabva-cai","owctf-4qaaa-aaaak-qaahq-cai"];
  
  let e6s:Nat64 = 1_000_000;

  stable var FEE:Nat64 = 1_000;

  stable var default_page_size = 100; 
  stable var nextSubAccount : Nat = 1;

    let _HttpHandler = Http.HttpHandler();

  func getPrincipal () : Principal {
      return Principal.fromActor(this);
  };

  func _isAdmin(user: Text) : Bool{
    let fallow = Array.find<Text>(_admins, func(a){
      a == user
    });
    switch(fallow){
      case(?fallow){ true };
      case(_){ false };
    };
  };

  func _isAllowed(caller: Text) : Bool{
    let fallow = Array.find<Text>(_allows, func(p){
      p == caller
    });
    switch(fallow){
      case(?fallow){ return true; };
      case(_){ return false; };
    }
  };

  func _getArrayPage<T>(data: [T],page: Nat, pageSize: Nat): [T]{

    if(data.size() == 0 and page < 1) return [];
    var size = pageSize;
    if(data.size() < size) size := data.size();
    
    var index = 0;
    if(page > 1) index := (page - 1)*size;
    if(index > data.size()) return [];
    if(index + size > data.size()) size := data.size() - index;

    Array.tabulate(size, func(i:Nat):T{
        data[index + i]
    })
   
  };
  /**
  System methods
  **/
  system func preupgrade() {
   

  };

  system func postupgrade() {

  };

    
  public query func availableCycles() : async Nat {
    return Cycles.balance();
  };

  
  public query func getSystemData(): async {
       cycles: Nat;
      memory: Nat;
      heap: Nat;
   }{
    return {
      cycles = Cycles.balance();
      memory = Prim.rts_memory_size();
      heap = Prim.rts_heap_size();
    };
  } ;

  public query func http_request(request : HttpTypes.Request) : async HttpTypes.Response {
      _HttpHandler.request(request);       
      
  };
};