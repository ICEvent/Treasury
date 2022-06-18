import Prim "mo:prim";
 import Cycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";
import List "mo:base/List";
import AssocList "mo:base/AssocList";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
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

import CRC32     "./utils/CRC32";
import SHA224    "./utils/SHA224";
import Account      "./utils/account";
import Hex          "./utils/hex";
import Utils      "./utils/utils";

import Http "./http";
import HttpTypes "./http/types";

import Types "Types";


import TokenTypes "./TokenTypes";
import EscrowTypes "./EscrowTypes";

shared (install) actor class Ledger() = this {


  let ICET = "ot4zw-oaaaa-aaaag-qabaa-cai";
  let icet : TokenTypes.Self = actor "ot4zw-oaaaa-aaaag-qabaa-cai";
  let escrow : EscrowTypes.Self = actor "oslfo-7iaaa-aaaag-qakra-cai";

  // let RESERVE_SUBACCOUNT = 1;
  let PRIVATE_SALE_SUBACCOUNT = 1;
  let PUBLIC_SALE_SUBACCOUNT = 2;

  type WL = {
    id: Principal;
    amount: Nat;
  };
  
  stable var private_sale_whitelist_state: [(Principal,WL)] = [];
  var private_sale_whitelist = HashMap.HashMap<Principal, WL>(0, Principal.equal, Principal.hash);

  stable var private_sale_price = 0; //of ICP
  
  stable var private_sale_account = "";
  stable var public_sale_account = "";


  stable var _admins: [Principal] = [];
  var admins : List.List<Principal> = List.fromArray(_admins);

  stable var _allows: [Principal] = [];
  var allows : List.List<Principal> = List.fromArray(_allows);

  let e6s:Nat64 = 1_000_000;

  stable var FEE:Nat64 = 1_000;

  stable var default_page_size = 100; 
  stable var nextSubAccount : Nat = 10;

  let _HttpHandler = Http.HttpHandler();

  public shared({caller}) func addAdmin(admin: Principal): async Result.Result<Nat, Text>{
    if(Principal.equal(caller, install.caller)){

      admins := List.push(admin, admins);
      #ok(1)
    }else{
      #err("no permission")
    }
  };
  public shared({caller}) func addAllow(allow: Principal): async Result.Result<Nat, Text>{
    if(Principal.equal(caller, install.caller)){

      allows := List.push(allow, allows);
      #ok(1)
    }else{
      #err("no permission")
    }
  };
  //-------------------private sale--------------------------
  public shared({caller}) func setPrice(price: Nat): async (){
    private_sale_price := price;
  };

  public shared({caller}) func addWL(wl:WL): async Result.Result<Nat, Text>{
    if(_isAdmin(caller)){
        private_sale_whitelist.put(wl.id, wl);
        #ok(1)
    }else{
      #err("no permission")
    };
    
  };

  public query({caller}) func isEligible(): async ?{
    amount: Nat;
    price: Nat;
  }{
    let wl = private_sale_whitelist.get(caller);    
    switch(wl){
      case(?wl){
        ?{
          amount = wl.amount;
          price= private_sale_price;
        }
      };
      case(_){
        null
      };
    };
  };

  // public shared({caller}) func mint(): async Result.Result<Nat, Text>{
  //    if(Principal.isAnonymous(caller)){
  //      #err("no authenticated");
  //    }else{
  //      //check WL
  //      let wl = private_sale_whitelist.get(caller);
  //      switch(wl){
  //        case(?wl){
  //           //create escrow order
  //           let order = {
  //             memo="mint ICET";
  //             seller = getPrincipal();
  //             expiration = Time.now() + 1_000_000_000 * 3600 * 24 * 7;
  //             currency = #ICP;
  //             amount = Nat64.fromNat(wl.amount / private_sale_price);
  //           };
  //           await escrow.create(order);
  //        };
  //        case(_){
  //          #err("not in whitelist")
  //        };
  //      }


  //    }
  // };
  
  public shared({caller}) func fetchOrders(): async [EscrowTypes.Order]{
    if(_isAdmin(caller)){
      await escrow.getOrders();
    }else{
      []
    }
  };
  
  public shared({caller}) func claimFund(orderid: Nat): async Result.Result<Nat, Text>{
    if(_isAdmin(caller)){
      await escrow.release(orderid);
    }else{
      #err("no permission")
    }
  };

  public shared({caller}) func distribute(orderid: Nat, icets: Nat): async Result.Result<Nat, Text>{
    if(not _isAdmin(caller)){
      #err("no permission")
    }else{
       //check deposit
      let order = await escrow.getOrder(orderid);
      switch(order){
        case(?order){

            let balance = await escrow.accountBalance(order.account.id, #ICP);
            switch(balance){
              case(#e8s(a)){
                if(a >= order.amount){
                  let address = await getAccountId(PRIVATE_SALE_SUBACCOUNT);
                  let res = await icet.transfer(
                    { 
                    to = #principal(order.buyer);
                    token = ICET;
                    notify = false;
                    from = #address(address);
                    memo = Blob.toArray(Text.encodeUtf8(order.memo));
                    subaccount = ?Blob.toArray(Utils.subToSubBlob(PRIVATE_SALE_SUBACCOUNT));
                    amount = icets ;// Nat64.toNat(order.amount);
                    }
                  );
                  switch(res){
                    case(#ok(r)){
                      await escrow.deliver(orderid);
                      
                    };
                    case(#err(e)){
                      switch(e){
                          case(#CannotNotify(e)){
                                #err("CannotNotify");
                            };
                            case(#InsufficientBalance){
                                #err("InsufficientBalance")
                            };
                            case(#InvalidToken(e)){
                                #err("InvalidToken")
                            };
                            case(#Rejected){
                                #err("Rejected")
                            };
                            case(#Unauthorized(e)){
                                #err("Unauthorized")
                            };
                            case(#Other(o)){
                                #err(o)
                            };
                        }
                    }
                  };
                }else if(a == 0){
                  #err("no deposit");
                }else{
                  #err("deposit amount is less than order amount")
                };
              };
              case(_){
                #err("balance is not right")
              };
            };
       
          
        };
        case(_){
          #err("no order found");
        };
      };
    }   
    
  };

  public shared({caller}) func release(orderid: Nat) : async Result.Result<Nat, Text>{
    await escrow.release(orderid);
  };

  //---------------------public sale---------------------------



  //---------------------data--------------------------------



  func getPrincipal () : Principal {
      return Principal.fromActor(this);
  };

  public query func getAccountId(sub: Nat): async Text{
      let sublob = Utils.subToSubBlob(sub);
        Utils.accountIdToHex(Account.accountIdentifier(getPrincipal(), sublob));
  };


  func _isAdmin(user: Principal) : Bool{
    let fallow = Array.find<Principal>(List.toArray(admins), func(a){
      Principal.equal(a,user)
    });
    switch(fallow){
      case(?fallow){ true };
      case(_){ false };
    };
  };

  func _isAllowed(caller: Principal) : Bool{
    let fallow = Array.find<Principal>(List.toArray(allows), func(p){
      Principal.equal(p,caller)
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
    _admins := List.toArray(admins);
    _allows := List.toArray(allows);

    private_sale_whitelist_state := Iter.toArray(private_sale_whitelist.entries());  

  };

  system func postupgrade() {
    private_sale_whitelist := HashMap.fromIter<Principal, WL>(private_sale_whitelist_state.vals(), 10, Principal.equal, Principal.hash);
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