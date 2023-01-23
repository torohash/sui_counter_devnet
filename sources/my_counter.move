module my_first_package::my_counter {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct CountHistory has store {
        up: u64,
        down: u64
    }

    struct Counter has key {
        id: UID,
        count: u64,
        count_history: CountHistory
    }

    fun init(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            count: 0,
            count_history: CountHistory {
                up: 0,
                down: 0,
            }
        };
        // transfer::transfer(counter, tx_context::sender(ctx));
        transfer::share_object(counter);
    }

    public entry fun count_up(self: &mut Counter) {
        self.count = self.count + 1;
        self.count_history.up = self.count_history.up + 1;
    }

    public entry fun count_down(self: &mut Counter) {
        if(self.count > 0){
            self.count = self.count - 1;
            self.count_history.down = self.count_history.down + 1;
        } else {
            abort 0
        }
    }

}
