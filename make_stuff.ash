void BuyWhatINeed( int qty, item it ){
	int need = qty - item_amount(it);
	buy(need, it);
}

void main(){
	use(1, $item[BittyCar MeatCar]);

	if( my_mp() < 10 ){
		restore_mp(10);
	}			
	use_skill(1, $skill[Perfect Freeze]);
	if( get_property( "_clipartSummons" ) == 0 ){
		create(1, $item[Potion of the field gar]);
		create(1, $item[bucket of wine]);
		create(1, $item[bucket of wine]);
	}
	cli_execute('camp dnapotion 3');
	BuyWhatINeed(1, $item[VYKEA instructions]);
	BuyWhatINeed(5, $item[VYKEA rail]);
	BuyWhatINeed(5, $item[VYKEA plank]);
	cli_execute('make level 2 couch');
	visit_url('place.php?whichplace=chateau&action=chateau_desk1');
	// need to vamp out
}