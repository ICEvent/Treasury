// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
  public type AccountIdText = Text;
  public type AccountIdText__1 = Text;
  public type Balance = { #e6s : Nat64; #e8s : Nat64 };
  public type Comment = { ctime : Int; user : Principal; comment : Text };
  public type Currency = { #ICP; #ICET };
  public type Currency__1 = { #ICP; #ICET };
  public type EscrowAccount = { id : AccountIdText; index : Subaccount };
  public type Item = {
    id : Nat;
    status : Status;
    listime : Int;
    owner : Principal;
    name : Text;
    currency : { #ICP; #ICET };
    image : Text;
    itype : Itype;
    price : Nat64;
  };
  public type Itype = { #NFT; #MERCHANDIS; #SERVICE; #OTHER };
  public type Log = {
    log : Text;
    logger : { #seller; #buyer; #escrow };
    ltime : Int;
  };
  public type NewItem = {
    name : Text;
    currency : { #ICP; #ICET };
    image : Text;
    itype : { #NFT; #MERCHANDIS; #SERVICE; #OTHER };
    price : Nat64;
  };
  public type NewOrder = {
    memo : Text;
    seller : Principal;
    expiration : Int;
    currency : Currency;
    amount : Nat64;
  };
  public type Order = {
    id : Nat;
    status : Status__1;
    blockout : Nat64;
    updatetime : Int;
    blockin : Nat64;
    logs : [Log];
    memo : Text;
    seller : Principal;
    createtime : Int;
    expiration : Int;
    currency : Currency;
    lockedby : Principal;
    account : EscrowAccount;
    buyer : Principal;
    comments : [Comment];
    amount : Nat64;
  };
  public type Result = { #ok : Nat; #err : Text };
  public type Status = { #list; #sold; #locked : Principal };
  public type Status__1 = {
    #new;
    #deposited;
    #closed;
    #canceled;
    #refunded;
    #released;
    #delivered;
    #received;
  };
  public type Subaccount = Nat;
  public type Self = actor {
    accountBalance : shared (AccountIdText__1, Currency__1) -> async Balance;
    availableCycles : shared query () -> async Nat;
    cancel : shared Nat -> async Result;
    changeItemStatus : shared (Nat, Status) -> async Result;
    close : shared Nat -> async Result;
    comment : shared (Nat, Text) -> async Result;
    create : shared NewOrder -> async Result;
    deleteItem : shared Nat -> async Result;
    deliver : shared Nat -> async Result;
    deposit : shared Nat -> async Result;
    getAccountId : shared query Nat -> async Text;
    getAllOrders : shared Nat -> async [Order];
    getBalanceBySub : shared (Nat, Currency__1) -> async Balance;
    getMyAccountId : shared query Nat -> async Text;
    getMyBalanceBySub : shared (Nat, Currency__1) -> async Balance;
    getMyItems : shared query Nat -> async [Item];
    getOrder : shared Nat -> async ?Order;
    getOrders : shared () -> async [Order];
    listItem : shared NewItem -> async Result;
    lockItem : shared Nat -> async Result;
    receive : shared Nat -> async Result;
    refund : shared Nat -> async Result;
    release : shared Nat -> async Result;
    searchItems : shared query (Itype, Nat) -> async [Item];
  }
}