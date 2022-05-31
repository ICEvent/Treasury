// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
  public type Address = {
    postcode : Text;
    country : Text;
    province : Text;
    city : Text;
    address : Text;
  };
  public type Contact = {
    fax : ?Text;
    url : ?Text;
    contact : ?Text;
    name : Text;
    email : Text;
    address : Address;
    wallet : ?Wallet;
    phone : Text;
  };
  public type Currency = Text;
  public type Invoice = {
    id : Text;
    to : Contact;
    tax : Tax;
    status : Status;
    paymentterms : [PaymentTerm];
    owner : Text;
    cost : Float;
    from : Contact;
    note : Text;
    createtime : Int;
    event : Nat;
    duetime : Nat;
    calendar : Nat;
    currency : Text;
    adjust : Float;
    discount : Float;
    items : [Item];
    amount : Float;
    receiver : ?Text;
  };
  public type InvoiceStatus = { #new; #canceled; #paid; #confirmed };
  public type Item = {
    desc : Text;
    quantity : Nat32;
    itype : { #cost; #income };
    price : Float;
  };
  public type NewInvoice = {
    id : Text;
    to : Contact;
    tax : Tax;
    paymentterms : [PaymentTerm];
    cost : Float;
    from : Contact;
    note : Text;
    event : Nat;
    duetime : Nat;
    calendar : Nat;
    currency : Text;
    adjust : Float;
    discount : Float;
    items : [Item];
    amount : Float;
    receiver : ?Text;
  };
  public type NewOrder = {
    memo : ?Text;
    seller : Text;
    orderid : Text;
    items : [OrderItem];
    amount : Float;
  };
  public type Order = {
    status : OrderStatus;
    changetime : ?Int;
    memo : ?Text;
    seller : Text;
    orderid : Text;
    ordertime : Int;
    buyer : Text;
    items : [OrderItem];
    amount : Float;
  };
  public type OrderItem = {
    item : { #ticket : Nat; #file; #mint : Nat; #solution : Nat };
    count : Nat;
  };
  public type OrderStatus = {
    #new;
    #canceled;
    #paid : TXID;
    #delivered;
    #processing : Text;
    #received;
  };
  public type OrderStatus__1 = {
    #new;
    #canceled;
    #paid : TXID;
    #delivered;
    #processing : Text;
    #received;
  };
  public type PaymentTerm = { name : Text; address : Text };
  public type Result = { #ok : Nat; #err : Text };
  public type Status = { #new; #canceled; #paid; #confirmed };
  public type TXID = Nat;
  public type Tax = {
    name : Text;
    rate : Float;
    number : Text;
    amount : Float;
  };
  public type UpdateInvoice = {
    tax : Tax;
    status : Status;
    paymentterms : [PaymentTerm];
    cost : Float;
    note : Text;
    duetime : Nat;
    adjust : Float;
    discount : Float;
    items : [Item];
    amount : Float;
  };
  public type Wallet = { currency : Currency; address : Text };
  public type Self = actor {
    addInvoice : shared NewInvoice -> async Result;
    addOrder : shared NewOrder -> async Result;
    availableCycles : shared query () -> async Nat;
    changeInvoiceStatus : shared (Text, InvoiceStatus) -> async Result;
    findOrdersByStatus : shared query OrderStatus__1 -> async [Order];
    getMyInvoice : shared query (InvoiceStatus, Nat) -> async [Invoice];
    getOrder : shared query Text -> async ?Order;
    getProcessOrders : shared query () -> async [Order];
    updateInvoice : shared (Text, UpdateInvoice) -> async Result;
  }
}