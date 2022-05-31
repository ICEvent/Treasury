// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
  public type Action = { #read; #delete; #create; #update };
  public type Address = {
    postcode : Text;
    country : Text;
    province : Text;
    city : Text;
    address : Text;
  };
  public type Comment = {
    comto : Comto__1;
    user : Text;
    comment : Text;
    timestamp : Int;
    attachments : [Text];
  };
  public type Comto = {
    #note : Nat;
    #todo : Nat;
    #event : Nat;
    #calendar : Nat;
  };
  public type Comto__1 = {
    #note : Nat;
    #todo : Nat;
    #event : Nat;
    #calendar : Nat;
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
  public type Function = {
    #contact : Nat;
    #other;
    #note : Nat;
    #todo : Nat;
    #user : Text;
    #event : Nat;
    #calendar : Nat;
    #comment : Nat;
  };
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
  public type Log = {
    function : Function;
    action : Action;
    user : Text;
    logtime : Int;
    message : Text;
  };
  public type Message = {
    id : Nat;
    note : Text;
    sender : Text;
    isread : Bool;
    readtime : Int;
    replyid : ?Nat;
    attachment : ?Text;
    receiver : Text;
    sendtime : Int;
  };
  public type NewComment = {
    comto : Comto__1;
    comment : Text;
    attachments : [Text];
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
  public type NewLog = {
    function : Function;
    action : Action;
    user : Text;
    message : Text;
  };
  public type NewMessage = {
    note : Text;
    replyid : ?Nat;
    attachment : ?Text;
    receiver : Text;
  };
  public type NewNotification = {
    note : Text;
    sender : Text;
    ntype : TypeNotification;
    receiver : Text;
  };
  public type NewOrder = {
    memo : ?Text;
    seller : Text;
    orderid : Text;
    items : [OrderItem];
    amount : Float;
  };
  public type Notification = {
    id : Nat;
    note : Text;
    sender : Text;
    isread : Bool;
    readtime : Int;
    ntype : TypeNotification;
    receiver : Text;
    sendtime : Int;
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
  public type TypeNotification = {
    #contact : Nat;
    #other;
    #note : Nat;
    #todo : Nat;
    #user : Text;
    #event : Nat;
    #calendar : Nat;
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
    addComment : shared NewComment -> async Result;
    addInvoice : shared NewInvoice -> async Result;
    addNotification : shared NewNotification -> async ();
    addOrder : shared NewOrder -> async Result;
    availableCycles : shared query () -> async Nat;
    changeInvoiceStatus : shared (Text, InvoiceStatus) -> async Result;
    findOrdersByStatus : shared query OrderStatus__1 -> async [Order];
    getComments : shared query (Comto, Nat) -> async [Comment];
    getLogs : shared query Nat -> async [Log];
    getMyInvoice : shared query (InvoiceStatus, Nat) -> async [Invoice];
    getMyMessages : shared query (Bool, Nat) -> async [Message];
    getMyNotifications : shared query (Bool, Nat) -> async [Notification];
    getOrder : shared query Text -> async ?Order;
    getProcessOrders : shared query () -> async [Order];
    getUserLogs : shared query Nat -> async [Log];
    log : shared NewLog -> async ();
    message : shared NewMessage -> async Result;
    readMessage : shared Nat -> async Result;
    readNotification : shared Nat -> async Result;
    updateInvoice : shared (Text, UpdateInvoice) -> async Result;
  }
}